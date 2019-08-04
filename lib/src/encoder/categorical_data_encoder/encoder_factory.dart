import 'package:ml_preprocessing/src/encoder/categorical_data_encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_encoder/encoding_type.dart';

abstract class CategoricalDataEncoderFactory {
  CategoricalDataEncoder fromType(CategoricalDataEncodingType encoderType,
      Iterable<String> values);
}
