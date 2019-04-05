import 'dart:typed_data';

import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/data_frame/encoders_processor/encoders_processor.dart';

class EncodersProcessorImpl implements EncodersProcessor {
  EncodersProcessorImpl(List<String> _columnNames, this._encoderFactory,
      [Type dtype = Float32x4])
      : _colNameToIdx = _columnNames.asMap().map(
          (idx, name) => MapEntry(name, idx)),
        _dtype = dtype;

  final Type _dtype;
  final Map<String, int> _colNameToIdx;
  final CategoricalDataEncoderFactory _encoderFactory;

  @override
  Map<int, CategoricalDataEncoder> createEncoders(
      Map<CategoricalDataEncoderType, String> encoderTypesToNames,
      Map<int, CategoricalDataEncoderType> indexesToEncoderTypes,
      Map<String, CategoricalDataEncoderType> namesToEncoderTypes,
  ) {
    if (indexesToEncoderTypes.isNotEmpty) {
      return _createEncodersFromIndexToEncoder(indexesToEncoderTypes);
    } else if (_colNameToIdx.isNotEmpty && namesToEncoderTypes.isNotEmpty) {
      return _createEncodersFromNameToEncoder(namesToEncoderTypes);
    }
    return {};
  }

  Map<int, CategoricalDataEncoder> _createEncodersFromNameToEncoder(
          Map<String, CategoricalDataEncoderType> nameToEncoder) =>
    nameToEncoder.map((colName, encoderType) {
      if (!_colNameToIdx.containsKey(colName)) {
        throw Exception('Column named `$colName` does not exist, please, '
            'double check your dataset column names');
      }
      final idx = _colNameToIdx[colName];
      final encoder = _encoderFactory.fromType(encoderType, _dtype);
      return MapEntry(idx, encoder);
    });

  Map<int, CategoricalDataEncoder> _createEncodersFromIndexToEncoder(
          Map<int, CategoricalDataEncoderType> indexToEncoderType) =>
    indexToEncoderType.map((idx, encoderType) =>
        MapEntry(idx, _encoderFactory.fromType(encoderType, _dtype)));
}
