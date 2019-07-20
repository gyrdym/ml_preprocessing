import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/categorical_encoder/one_hot_encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/ordinal_encoder.dart';

class CategoricalDataEncoderFactoryImpl implements
    CategoricalDataEncoderFactory {
  const CategoricalDataEncoderFactoryImpl();

  @override
  CategoricalDataEncoder fromType(CategoricalDataEncoderType encoderType,
      Iterable<String> values, [DType dtype]) {
    switch (encoderType) {
      case CategoricalDataEncoderType.oneHot:
        return OneHotEncoder(values, dtype);
      case CategoricalDataEncoderType.ordinal:
        return OrdinalEncoder(values, dtype);
      default:
        throw Exception('Unknown categorical data encoder type has been '
            'provided');
    }
  }

  @override
  CategoricalDataEncoder oneHot(Iterable<String> values, [DType dtype]) =>
      OneHotEncoder(values, dtype);

  @override
  CategoricalDataEncoder ordinal(Iterable<String> values, [DType dtype]) =>
      OrdinalEncoder(values, dtype);
}
