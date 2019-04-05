import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';

abstract class EncodersProcessor {
  Map<int, CategoricalDataEncoder> createEncoders(
      Map<int, CategoricalDataEncoderType> indexesToEncoderTypes,
      Map<CategoricalDataEncoderType, Iterable<String>> encoderTypesToNames,
      Map<String, CategoricalDataEncoderType> namesToEncoderTypes,
  );
}
