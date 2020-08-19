import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';

abstract class SeriesEncoderFactory {
  SeriesEncoder createByType(EncoderType type, Series fittingData, {
    String headerPrefix,
    String headerPostfix,
    UnknownValueHandlingType unknownValueHandlingType,
  });
}
