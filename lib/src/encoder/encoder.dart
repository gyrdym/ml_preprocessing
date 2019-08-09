import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';

final _seriesEncoderFactory = SeriesEncoderFactoryImpl();

abstract class Encoder {
  factory Encoder.oneHot(DataFrame fittingData, {
    Iterable<int> columns,
    Iterable<String> columnNames,
    String headerPrefix,
    String headerPostfix,
  }) => EncoderImpl(
    fittingData,
    EncoderType.oneHot,
    _seriesEncoderFactory,
    columnNames: columnNames,
    columns: columns,
  );

  factory Encoder.label(DataFrame fittingData, {
    Iterable<int> columns,
    Iterable<String> columnNames,
    String headerPrefix,
    String headerPostfix,
  }) => EncoderImpl(
    fittingData,
    EncoderType.label,
    _seriesEncoderFactory,
    columnNames: columnNames,
    columns: columns,
  );

  DataFrame encode(DataFrame data);
}
