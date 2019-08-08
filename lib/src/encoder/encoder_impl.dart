import 'package:ml_preprocessing/src/data_frame/data_frame.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder.dart';
import 'package:ml_preprocessing/src/pipeline/column_indices_helpers.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline_step_data.dart';
import 'package:quiver/iterables.dart';

class EncoderImpl implements Pipeable, Encoder {
  EncoderImpl(this._seriesEncoder, {
    Iterable<int> columns,
    Iterable<String> columnNames,
  }) :
        _columns = columns,
        _columnNames = columnNames;

  final Iterable<int> _columns;
  final Iterable<String> _columnNames;
  final SeriesEncoder _seriesEncoder;

  @override
  PipelineStepData process(PipelineStepData stepData) {
    var expandedColumns = stepData.expandedColumnIds;
    final data = stepData.data;
    final header = data.header;
    final columnIndices = _getColumnIndices(_columns, _columnNames, header);
    final encoded = enumerate(data.series).expand((indexedSeries) {
      final series = indexedSeries.value;
      final index = indexedSeries.index;
      final origIndex = getOriginalIndexByExpanded(index,
          stepData.expandedColumnIds);
      if (columnIndices.contains(origIndex)) {
        final encodedSeries = _seriesEncoder.encodeSeries(series);
        final shift = encodedSeries.length;
        expandedColumns = shiftExpandedColumnIndices(expandedColumns, origIndex,
            index, shift);
        return encodedSeries;
      }
      return [series];
    });

    return PipelineStepData(
      DataFrame.fromSeries(encoded),
      expandedColumns,
    );
  }

  @override
  DataFrame encode(DataFrame data) {
    // TODO: implement encode
    return null;
  }

  Iterable<int> _getColumnIndices(Iterable<int> indices, Iterable<String> names,
      Iterable<String> header) {
    if (indices != null) {
      return indices;
    }
    final uniqueNames = Set.from(names);
    return enumerate(header)
        .where((indexedName) => uniqueNames.contains(indexedName.value))
        .map((indexedValue) => indexedValue.index);
  }
}
