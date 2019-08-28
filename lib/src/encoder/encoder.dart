import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';

final _seriesEncoderFactory = SeriesEncoderFactoryImpl();

/// Categorical data encoder factory
abstract class Encoder {
  factory Encoder.oneHot(DataFrame fittingData, {
    Iterable<int> featureIds,
    Iterable<String> featureNames,
    String headerPrefix,
    String headerPostfix,
  }) => EncoderImpl(
    fittingData,
    EncoderType.oneHot,
    _seriesEncoderFactory,
    featureNames: featureNames,
    featureIds: featureIds,
  );

  factory Encoder.label(DataFrame fittingData, {
    Iterable<int> featureIds,
    Iterable<String> featureNames,
    String headerPrefix,
    String headerPostfix,
  }) => EncoderImpl(
    fittingData,
    EncoderType.label,
    _seriesEncoderFactory,
    featureNames: featureNames,
    featureIds: featureIds,
  );

  DataFrame encode(DataFrame data);
}
