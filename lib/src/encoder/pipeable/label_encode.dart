import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

PipeableOperatorFn labelsEncode({
  Iterable<int> columns,
  Iterable<String> columnNames,
  String headerPrefix,
  String headerPostfix,
}) => (data) => EncoderImpl(
  data,
  EncoderType.label,
  SeriesEncoderFactoryImpl(),
  columnNames: columnNames,
  columns: columns,
  encodedHeaderPostfix: headerPostfix,
  encodedHeaderPrefix: headerPrefix,
);