import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/encoder_helpers.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:quiver/iterables.dart';

class OneHotEncoder extends EncoderImpl {
  OneHotEncoder({
    Iterable<int> columns,
    Iterable<String> columnNames,
    String headerPrefix,
    String headerPostfix,
    DType dtype,
  }) : super(
      columns: columns,
      columnNames: columnNames,
      headerPostfix: headerPostfix,
      headerPrefix: headerPrefix,
      dtype: dtype,
  );

  @override
  Iterable<Series> encodeSeries(Series series,
      {ColumnHeaderTemplateFn columnHeaderTpl}) {
    final length = series.data.length;
    final columnIdByLabel = getColumnIdByLabelMapping(series);
    final labelByColumnId = columnIdByLabel.inverse;

    final headers = List.generate(
      columnIdByLabel.length,
      (id) => columnHeaderTpl != null
          ? columnHeaderTpl(labelByColumnId[id])
          : labelByColumnId[id],
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

Pipeable oneHotEncode({
  Iterable<int> columns,
  Iterable<String> columnNames,
  String headerPrefix,
  String headerPostfix,
  DType dtype,
}) => OneHotEncoder(
  columns: columns,
  columnNames: columnNames,
  headerPostfix: headerPostfix,
  headerPrefix: headerPrefix,
  dtype: dtype,
);
