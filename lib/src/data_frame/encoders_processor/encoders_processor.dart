import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';

abstract class EncodersProcessor {
  Map<int, CategoricalDataEncoder> createEncoders(
      Map<CategoricalDataEncoderType, String> encoderTypesToNames,
      Map<int, CategoricalDataEncoderType> indexesToEncoderTypes,
      Map<String, CategoricalDataEncoderType> namesToEncoderTypes,
  );
}
