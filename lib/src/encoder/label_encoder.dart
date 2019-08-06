import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/encoder_helpers.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

class LabelEncoder extends EncoderImpl {
  LabelEncoder({
    Iterable<int> columns,
    Iterable<String> columnNames,
    String headerPrefix,
    String headerPostfix,
  }) : super(
    columnNames: columnNames,
    columns: columns,
    headerPrefix: headerPrefix,
    headerPostfix: headerPostfix,
  );

  @override
  Iterable<Series> encodeSeries(Series series,
      {ColumnHeaderTemplateFn columnHeaderTpl}) {
    final labelToColumnId = getColumnIdByLabelMapping(series);
    return [
      Series(
          columnHeaderTpl != null
              ? columnHeaderTpl(series.header)
              : series.header,
          series.data.map((label) => labelToColumnId[label]),
      ),
    ];
  }
}

Pipeable labelEncode({
  Iterable<int> columns,
  Iterable<String> columnNames,
  String headerPrefix,
  String headerPostfix,
}) => LabelEncoder(
  columns: columns,
  columnNames: columnNames,
  headerPostfix: headerPostfix,
  headerPrefix: headerPrefix,
);