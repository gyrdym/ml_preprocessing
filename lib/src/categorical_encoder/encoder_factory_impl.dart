import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_mixin.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/categorical_encoder/one_hot_encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/ordinal_encoder.dart';

class CategoricalDataCodecFactoryImpl implements
    CategoricalDataEncoderFactory {
  const CategoricalDataCodecFactoryImpl();

  @override
  CategoricalDataCodec fromType(CategoricalDataEncoderType encoderType,
      Iterable<String> values, [DType dtype = DType.float32]) {
    switch (encoderType) {
      case CategoricalDataEncoderType.oneHot:
        return CategoricalDataCodecImpl(values, encodeOneHotLabel,  dtype);

      case CategoricalDataEncoderType.ordinal:
        return CategoricalDataCodecImpl(values, encodeOrdinalLabel,  dtype);

      default:
        throw Exception('Unknown categorical data encoder type has been '
            'provided');
    }
  }
}
