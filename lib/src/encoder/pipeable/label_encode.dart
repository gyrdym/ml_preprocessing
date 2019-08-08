import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

Pipeable labelEncode({
  Iterable<int> columns,
  Iterable<String> columnNames,
  String headerPrefix,
  String headerPostfix,
}) => EncoderImpl(
  LabelSeriesEncoder(
    headerPrefix: headerPrefix,
    headerPostfix: headerPostfix,
  ),
  columnNames: columnNames,
  columns: columns,
);