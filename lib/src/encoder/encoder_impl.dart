import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:quiver/iterables.dart';

import 'categorical_data_codec/encoder_factory.dart';
import 'encoding_mapping_processor/mapping_processor_factory.dart';
import 'numerical_converter/numerical_converter.dart';

class EncoderImpl implements Encoder {
  EncoderImpl(
      this._columnNameToEncodingType,
      this._columnIndexToEncodingType,
      this._encodingTypeToColumnNames,
      this._encoderFactory,
      this._numericalConverter,
      this._encodingMappingProcessorFactory,
      this._dtype,
  );

  final Map<String, CategoricalDataEncodingType> _columnNameToEncodingType;
  final Map<int, CategoricalDataEncodingType> _columnIndexToEncodingType;
  final Map<CategoricalDataEncodingType, Iterable<String>> _encodingTypeToColumnNames;
  final DType _dtype;
  final CategoricalDataEncoderFactory _encoderFactory;
  final NumericalConverter _numericalConverter;
  final EncodingMappingProcessorFactory _encodingMappingProcessorFactory;

  @override
  EncodingDescriptor encode(DataFrame data) {
    final encodersProcessor = _encodingMappingProcessorFactory
        .create(data.header);
    final indexToEncodingType = encodersProcessor.getIndexToEncodingTypeMapping(
        _columnIndexToEncodingType, _encodingTypeToColumnNames,
        _columnNameToEncodingType);
    return _encode(indexToEncodingType, data);
  }

  EncodingDescriptor _encode(
      Map<int, CategoricalDataEncodingType> columnIndexToEncodingType,
      DataFrame data) {
    final encodedData = enumerate(data.columns).map((indexedColumn) {
      final column = indexedColumn.value;
      if (columnIndexToEncodingType.containsKey(indexedColumn.index)) {
        final encoderType = columnIndexToEncodingType[indexedColumn.index];
        return _encoderFactory.fromType(encoderType, column).encode(column);
      }
      return [
        column.map(_numericalConverter.convert).toList(),
      ];
    });

    return EncodingDescriptor(
      DataFrame(encodedData, headerExists: false, dtype: _dtype),
      columnIndexToEncodingType.keys.toSet(),
    );
  }
}
