import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/records_processor/records_processor_factory.dart';
import 'package:quiver/iterables.dart';
import 'package:xrange/zrange.dart';

import 'categorical_data_codec/codec_factory.dart';
import 'encoding_mapping_processor/mapping_processor_factory.dart';
import 'numerical_converter/numerical_converter.dart';

class Encoder {
  Encoder(
      this._header,
      this._columnNameToEncodingType,
      this._columnIndexToEncodingType,
      this._encodingTypeToColumnNames,
      this._codecFactory,
      this._valueConverter,
      this._recordsProcessorFactory,
      this._encodingMappingProcessorFactory,
      this._dtype,
  );

  final Iterable<String> _header;
  final Map<String, CategoricalDataEncodingType> _columnNameToEncodingType;
  final Map<int, CategoricalDataEncodingType> _columnIndexToEncodingType;
  final Map<CategoricalDataEncodingType, Iterable<String>> _encodingTypeToColumnNames;
  final DType _dtype;
  final CategoricalDataCodecFactory _codecFactory;
  final NumericalConverter _valueConverter;
  final RecordsProcessorFactory _recordsProcessorFactory;
  final EncodingMappingProcessorFactory _encodingMappingProcessorFactory;

  EncodedData encode(List<List<dynamic>> data) {
    final rowsNum = data.length;
    final columnsNum = data.last.length;
    final rowIndices = count(0).take(rowsNum - (_header.isNotEmpty ? 1 : 0));
    final columnIndices = count(0).take(columnsNum);
    final records = data.sublist(_header.isNotEmpty ? 1 : 0);
    final encodersProcessor = _encodingMappingProcessorFactory.create(_header);
    final indexToEncodingType = encodersProcessor.getIndexToEncodingTypeMapping(
        _columnIndexToEncodingType, _encodingTypeToColumnNames, _columnNameToEncodingType);
    final _recordsProcessor = _recordsProcessorFactory.create(records,
        columnIndices, rowIndices, indexToEncodingType, _valueConverter,
        _codecFactory, _dtype);

    final encoded = _recordsProcessor.convertAndEncodeRecords();
    final rangeToCodec = _recordsProcessor.columnRangeToCodec;
//    _rangeToDecodingMap = _rangeToCodec.map((range, codec) =>
//        MapEntry(range, codec.originalToEncoded.inverse));
    return EncodedData(encoded, rangeToCodec);
  }
}

class EncodedData {
  EncodedData(this.records, this.rangeToCodec);

  final Matrix records;
  final Map<ZRange, CategoricalDataCodec> rangeToCodec;
}
