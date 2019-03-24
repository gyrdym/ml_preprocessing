import 'dart:typed_data';

import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/data_frame/encoders_processor/encoders_processor.dart';

class EncodersProcessorImpl implements EncodersProcessor {
  EncodersProcessorImpl(this.header, this.encoderFactory,
      [Type dtype = Float32x4]) : _dtype = dtype;

  final Type _dtype;
  final List<String> header;
  final CategoricalDataEncoderFactory encoderFactory;

  @override
  Map<int, CategoricalDataEncoder> createEncoders(
      Map<int, CategoricalDataEncoderType> indexesToEncoderTypes,
      Map<String, CategoricalDataEncoderType> namesToEncoderTypes,
  ) {
    if (indexesToEncoderTypes.isNotEmpty) {
      return _createEncodersFromIndexToEncoder(indexesToEncoderTypes);
    } else if (header.isNotEmpty && namesToEncoderTypes.isNotEmpty) {
      return _createEncodersFromNameToEncoder(namesToEncoderTypes);
    }
    return {};
  }

  Map<int, CategoricalDataEncoder> _createEncodersFromNameToEncoder(
          Map<String, CategoricalDataEncoderType> nameToEncoder) {
    final indexToEncoder = <int, CategoricalDataEncoder>{};
    for (int i = 0; i < header.length; i++) {
      if (nameToEncoder.containsKey(header[i])) {
        indexToEncoder[i] =
            encoderFactory.fromType(nameToEncoder[header[i]], _dtype);
      }
    }
    return indexToEncoder;
  }

  Map<int, CategoricalDataEncoder> _createEncodersFromIndexToEncoder(
          Map<int, CategoricalDataEncoderType> indexToEncoderType) =>
    indexToEncoderType.map((idx, encoderType) =>
        MapEntry<int, CategoricalDataEncoder>(idx,
            encoderFactory.fromType(encoderType, _dtype)));
}