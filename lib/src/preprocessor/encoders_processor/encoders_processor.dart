import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';

abstract class EncodersProcessor {
  Map<int, CategoricalDataEncodingType> createEncoders(
      Map<int, CategoricalDataEncodingType> indexesToEncoderTypes,
      Map<CategoricalDataEncodingType, Iterable<String>> encoderTypesToNames,
      Map<String, CategoricalDataEncodingType> namesToEncoderTypes,
  );
}
