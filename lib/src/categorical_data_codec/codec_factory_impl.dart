import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_impl.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/one_hot_encoder.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/ordinal_encoder.dart';

class CategoricalDataCodecFactoryImpl implements
    CategoricalDataCodecFactory {
  const CategoricalDataCodecFactoryImpl();

  @override
  CategoricalDataCodec fromType(CategoricalDataEncodingType encoderType,
      Iterable<String> values, [DType dtype = DType.float32]) {
    switch (encoderType) {
      case CategoricalDataEncodingType.oneHot:
        return CategoricalDataCodecImpl(values, encodeOneHotLabel,  dtype);

      case CategoricalDataEncodingType.ordinal:
        return CategoricalDataCodecImpl(values, encodeOrdinalLabel,  dtype);

      default:
        throw Exception('Unknown categorical data encoder type has been '
            'provided');
    }
  }
}
