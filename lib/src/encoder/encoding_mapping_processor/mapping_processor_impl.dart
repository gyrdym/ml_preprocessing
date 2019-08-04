import 'package:ml_preprocessing/src/encoder/categorical_data_encoder/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/encoding_mapping_processor/mapping_processor.dart';

class EncodingMappingProcessorImpl implements EncodingMappingProcessor {
  EncodingMappingProcessorImpl(List<String> _columnNames) :
        _colNameToIdx = _columnNames
            .asMap().map((idx, name) => MapEntry(name, idx));

  final Map<String, int> _colNameToIdx;

  @override
  Map<int, CategoricalDataEncodingType> getIndexToEncodingTypeMapping(
      Map<int, CategoricalDataEncodingType> columnIndexToEncodingType,
      Map<CategoricalDataEncodingType, Iterable<String>> encodingTypeToColumnName,
      Map<String, CategoricalDataEncodingType> columnNameToEncodingType,
  ) {
    if (columnIndexToEncodingType?.isNotEmpty == true) {
      return columnIndexToEncodingType;
    } else if (_colNameToIdx.isNotEmpty)  {
      if (encodingTypeToColumnName?.isNotEmpty == true) {
        return _typeToNameIntoIndexToType(encodingTypeToColumnName);
      } else if (columnNameToEncodingType?.isNotEmpty == true) {
        return _nameToTypeIntoIndexToType(columnNameToEncodingType);
      }
    }
    return {};
  }

  Map<int, CategoricalDataEncodingType> _typeToNameIntoIndexToType(
      Map<CategoricalDataEncodingType,
          Iterable<String>> encodingTypeToColumnName) {
    final encoders = <int, CategoricalDataEncodingType>{};
    for (final entry in encodingTypeToColumnName.entries) {
      for (final name in entry.value.toSet()) {
        final idxToEncoder = _createIndexToTypeEntry(name, entry.key);
        if (encoders.containsKey(idxToEncoder.key)) {
          throw Exception('Column `$name` is going to be encoded by two '
              'different encoders, please, re-check your input parameters');
        }
        encoders[idxToEncoder.key] = idxToEncoder.value;
      }
    }
    return encoders;
  }

  Map<int, CategoricalDataEncodingType> _nameToTypeIntoIndexToType(
          Map<String, CategoricalDataEncodingType> columnNameToEncodingType) =>
    columnNameToEncodingType.map((colName, encodingType) =>
        _createIndexToTypeEntry(colName, encodingType));

  MapEntry<int, CategoricalDataEncodingType> _createIndexToTypeEntry(
      String colName, CategoricalDataEncodingType encoderType) {
    if (!_colNameToIdx.containsKey(colName)) {
      throw Exception('Column named `$colName` does not exist, please, '
          'double check your dataset column names');
    }
    final idx = _colNameToIdx[colName];
    return MapEntry(idx, encoderType);
  }
}
