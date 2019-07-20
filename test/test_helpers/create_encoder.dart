import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/one_hot_encoder.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/ordinal_encoder.dart';

CategoricalDataCodec createEncoder({
  List<String> values,
  CategoricalDataEncodingType type = CategoricalDataEncodingType.oneHot,
}) {
  switch (type) {
    case CategoricalDataEncodingType.oneHot:
      return OneHotEncoder();
    case CategoricalDataEncodingType.ordinal:
      return OrdinalEncoder();
    default:
      throw Error();
  }
}
