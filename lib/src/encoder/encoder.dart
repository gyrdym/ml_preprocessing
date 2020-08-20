import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

final _seriesEncoderFactory = const SeriesEncoderFactoryImpl();

/// Categorical data encoder factory
abstract class Encoder implements Pipeable {
  factory Encoder.oneHot(DataFrame fittingData, {
    Iterable<int> featureIds,
    Iterable<String> featureNames,
    String headerPrefix,
    String headerPostfix,
    UnknownValueHandlingType unknownValueHandlingType =
        defaultUnknownValueHandlingType,
  }) => EncoderImpl(
    fittingData,
    EncoderType.oneHot,
    _seriesEncoderFactory,
    featureNames: featureNames,
    featureIds: featureIds,
    unknownValueHandlingType: unknownValueHandlingType,
  );

  factory Encoder.label(DataFrame fittingData, {
    Iterable<int> featureIds,
    Iterable<String> featureNames,
    String headerPrefix,
    String headerPostfix,
    UnknownValueHandlingType unknownValueHandlingType =
        defaultUnknownValueHandlingType,
  }) => EncoderImpl(
    fittingData,
    EncoderType.label,
    _seriesEncoderFactory,
    featureNames: featureNames,
    featureIds: featureIds,
    unknownValueHandlingType: unknownValueHandlingType,
  );
}
