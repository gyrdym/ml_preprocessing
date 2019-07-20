import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';

abstract class CategoricalDataEncoderFactory {
  CategoricalDataCodec fromType(CategoricalDataEncoderType encoderType,
      Iterable<String> values, [DType dtype]);
}
