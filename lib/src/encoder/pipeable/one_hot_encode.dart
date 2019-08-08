import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/one_hot_series_encoder.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

Pipeable oneHotEncode({
  Iterable<int> columns,
  Iterable<String> columnNames,
  String headerPrefix,
  String headerPostfix,
}) => EncoderImpl(
  OneHotSeriesEncoder(
    headerPrefix: headerPrefix,
    headerPostfix: headerPostfix,
  ),
  columnNames: columnNames,
  columns: columns,
);