import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

/// A factory function to use `one hot` categorical data encoder in pipeline
PipeableOperatorFn encodeAsOneHotLabels({
  Iterable<int> features,
  Iterable<String> featureNames,
  String headerPrefix = '',
  String headerPostfix = '',
  UnknownValueHandlingType unknownValueHandlingType =
      defaultUnknownValueHandlingType,
}) => (data, {dtype}) => EncoderImpl(
  data,
  EncoderType.oneHot,
  const SeriesEncoderFactoryImpl(),
  featureIds: features,
  featureNames: featureNames,
  encodedHeaderPostfix: headerPostfix,
  encodedHeaderPrefix: headerPrefix,
  unknownValueHandlingType: unknownValueHandlingType,
);
