import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/encoder.dart';
import 'package:ml_preprocessing/src/encoder/records_processor/records_processor_factory.dart';

import 'categorical_data_codec/codec_factory.dart';
import 'encoding_mapping_processor/mapping_processor_factory.dart';
import 'numerical_converter/numerical_converter.dart';

class EncoderImpl implements Encoder {
  EncoderImpl(
      this._columnNameToEncodingType,
      this._columnIndexToEncodingType,
      this._encodingTypeToColumnNames,
      this._codecFactory,
      this._valueConverter,
      this._recordsProcessorFactory,
      this._encodingMappingProcessorFactory,
      this._dtype,
  );

  final Map<String, CategoricalDataEncodingType> _columnNameToEncodingType;
  final Map<int, CategoricalDataEncodingType> _columnIndexToEncodingType;
  final Map<CategoricalDataEncodingType, Iterable<String>> _encodingTypeToColumnNames;
  final DType _dtype;
  final CategoricalDataCodecFactory _codecFactory;
  final NumericalConverter _valueConverter;
  final RecordsProcessorFactory _recordsProcessorFactory;
  final EncodingMappingProcessorFactory _encodingMappingProcessorFactory;

  @override
  EncodingDescriptor encode(DataFrame data) {
    final encodersProcessor = _encodingMappingProcessorFactory
        .create(data.header);
    final indexToEncodingType = encodersProcessor.getIndexToEncodingTypeMapping(
        _columnIndexToEncodingType, _encodingTypeToColumnNames,
        _columnNameToEncodingType);
    final _recordsProcessor = _recordsProcessorFactory.create(data,
        indexToEncodingType, _valueConverter, _codecFactory, _dtype);

    final encoded = _recordsProcessor.convertAndEncodeRecords();
    final rangeToCodec = _recordsProcessor.columnRangeToCodec;

    return EncodingDescriptor(encoded, rangeToCodec);
  }
}
