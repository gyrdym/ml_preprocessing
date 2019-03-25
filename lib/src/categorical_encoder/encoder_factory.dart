import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';

abstract class CategoricalDataEncoderFactory {
  CategoricalDataEncoder fromType(CategoricalDataEncoderType encoderType,
      [Type dtype]);
  CategoricalDataEncoder oneHot([Type dtype]);
  CategoricalDataEncoder ordinal([Type dtype]);
}
