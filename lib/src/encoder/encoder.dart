import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

/// Categorical data encoder factory
abstract class Encoder implements Pipeable {
  factory Encoder.oneHot(DataFrame fittingData, {
    Iterable<int>? featureIds,
    Iterable<String>? featureNames,
    UnknownValueHandlingType unknownValueHandlingType =
        defaultUnknownValueHandlingType,
  }) => EncoderImpl(
    fittingData,
    EncoderType.oneHot,
    const SeriesEncoderFactoryImpl(),
    featureNames: featureNames,
    featureIds: featureIds,
    unknownValueHandlingType: unknownValueHandlingType,
  );

  factory Encoder.label(DataFrame fittingData, {
    Iterable<int>? featureIds,
    Iterable<String>? featureNames,
    UnknownValueHandlingType unknownValueHandlingType =
        defaultUnknownValueHandlingType,
  }) => EncoderImpl(
    fittingData,
    EncoderType.label,
    const SeriesEncoderFactoryImpl(),
    featureNames: featureNames,
    featureIds: featureIds,
    unknownValueHandlingType: unknownValueHandlingType,
  );
}
