import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/encoder_helpers.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder.dart';
import 'package:quiver/iterables.dart';

class OneHotSeriesEncoder implements SeriesEncoder {
  OneHotSeriesEncoder({
    String headerPrefix,
    String headerPostfix,
  }) : _columnHeaderTpl = ((String label) => '${headerPrefix}${label}${headerPostfix}');

  final ColumnHeaderTemplateFn _columnHeaderTpl;

  @override
  Iterable<Series> encodeSeries(Series series) {
    final length = series.data.length;
    final columnIdByLabel = getColumnIdByLabelMapping(series);
    final labelByColumnId = columnIdByLabel.inverse;

    final headers = List.generate(
      columnIdByLabel.length,
      (id) => _columnHeaderTpl(labelByColumnId[id]),
    );

    final initialData = List.generate(
      columnIdByLabel.length,
      (id) => List.filled(length, 0),
    );

    final initialValue = _SeriesAccumulator(initialData, 0);

    final seriesAccumulator = series.data.fold<_SeriesAccumulator>(initialValue,
        (accumulator, label) {
          final seriesIdx = columnIdByLabel[label];
          final valueIdx = accumulator.counter;

          accumulator.data[seriesIdx][valueIdx] = 1;

          return _SeriesAccumulator(
              accumulator.data,
              accumulator.counter + 1,
          );
        });

    return enumerate(seriesAccumulator.data).map((indexedData) =>
        Series(headers[indexedData.index], indexedData.value));
  }
}

class _SeriesAccumulator {
  _SeriesAccumulator(this.data, this.counter);

  final List<List<int>> data;
  final int counter;
}
