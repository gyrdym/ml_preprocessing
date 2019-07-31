import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoder.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoder_factory.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/label_encoder.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/one_hot_encoder.dart';

class CategoricalDataEncoderFactoryImpl implements CategoricalDataEncoderFactory {
  const CategoricalDataEncoderFactoryImpl();

  @override
  CategoricalDataEncoder fromType(CategoricalDataEncodingType encoderType,
      Iterable<String> values) {
    switch (encoderType) {
      case CategoricalDataEncodingType.oneHot:
        return CategoricalDataEncoderImpl(values, encodeAsOneHot);

      case CategoricalDataEncodingType.label:
        return CategoricalDataEncoderImpl(values, encodeAsLabel);

      default:
        throw Exception('Unknown categorical data encoder type has been '
            'provided');
    }
  }
}
