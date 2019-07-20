import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';

abstract class CategoricalDataCodecFactory {
  CategoricalDataCodec fromType(CategoricalDataEncodingType encoderType,
      Iterable<String> values, [DType dtype]);
}
