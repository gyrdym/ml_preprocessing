import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoder.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';

abstract class CategoricalDataEncoderFactory {
  CategoricalDataEncoder fromType(CategoricalDataEncodingType encoderType,
      Iterable<String> values);
}
