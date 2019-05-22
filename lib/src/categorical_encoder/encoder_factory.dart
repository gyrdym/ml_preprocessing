import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';

abstract class CategoricalDataEncoderFactory {
  CategoricalDataEncoder fromType(CategoricalDataEncoderType encoderType,
      [DType dtype]);
  CategoricalDataEncoder oneHot([DType dtype]);
  CategoricalDataEncoder ordinal([DType dtype]);
}
