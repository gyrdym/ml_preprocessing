import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory_impl.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/data_reader/data_reader.dart';
import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/header_extractor/header_extractor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/index_ranges_combiner/index_ranges_combiner_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/index_ranges_combiner/index_ranges_combiner_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/numerical_converter/numerical_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/numerical_converter/numerical_converter_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/preprocessor.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator_impl.dart';
import 'package:xrange/zrange.dart';

import 'header_extractor/header_extractor_factory_impl.dart';

class PreprocessorImpl implements Preprocessor {
  PreprocessorImpl(
      this._dataReader, {
      DType dtype,
      int labelIdx,
      String labelName,
      bool headerExists = true,
      Map<CategoricalDataEncodingType, Iterable<String>> encodingTypeToColumnName,
      Map<String, CategoricalDataEncodingType> columnNameToEncodingType,
      Map<int, CategoricalDataEncodingType> columnIndexToEncodingType,
      List<ZRange> rows,
      List<ZRange> columns,

      CategoricalDataCodecFactory codecFactory =
        const CategoricalDataCodecFactoryImpl(),

      PreprocessorArgumentsValidator argumentsValidator =
        const DataFrameParamsValidatorImpl(),

      NumericalConverter valueConverter =
        const NumericalConverterImpl(),

      DataFrameHeaderExtractorFactory headerExtractorFactory =
        const DataFrameHeaderExtractorFactoryImpl(),

      RecordsProcessorFactory recordsProcessorFactory =
        const RecordsProcessorFactoryImpl(),

      IndexRangesCombinerFactory indexRangesCombinerFactory =
        const IndexRangesCombinerFactoryImpl(),

      EncodersProcessorFactory encodersProcessorFactory =
        const EncodersProcessorFactoryImpl(),
    }) :
      _dtype = dtype ?? DType.float32,
      _labelIdxFromArgs = labelIdx,
      _labelName = labelName,
      _headerExists = headerExists,
      _encodingTypeToColumnName = encodingTypeToColumnName,
      _columnNameToEncodingType = columnNameToEncodingType ?? {},
      _columnIndexToEncodingType = columnIndexToEncodingType ?? {},
      _codecFactory = codecFactory,
      _argumentsValidator = argumentsValidator,
      _valueConverter = valueConverter,
      _headerExtractorFactory = headerExtractorFactory,
      _recordsProcessorFactory = recordsProcessorFactory,
      _indexRangesCombinerFactory = indexRangesCombinerFactory,
      _encodersProcessorFactory = encodersProcessorFactory {

    final errorMsg = _argumentsValidator.validate(
      labelIdx: _labelIdxFromArgs,
      labelName: _labelName,
      rows: rows,
      columns: columns,
      headerExists: _headerExists,
      namesToEncoders: _columnNameToEncodingType,
      indexToEncoder: _columnIndexToEncodingType,
    );

    if (errorMsg.isNotEmpty) {
      throw Exception(_wrapErrorMessage(errorMsg));
    }
    _initialization = _init(rows, columns);
  }

  final DataReader _dataReader;
  final DType _dtype;
  final int _labelIdxFromArgs;
  final String _labelName;
  final bool _headerExists;
  final CategoricalDataCodecFactory _codecFactory;
  final PreprocessorArgumentsValidator _argumentsValidator;
  final NumericalConverter _valueConverter;
  final IndexRangesCombinerFactory _indexRangesCombinerFactory;
  final DataFrameHeaderExtractorFactory _headerExtractorFactory;
  final RecordsProcessorFactory _recordsProcessorFactory;
  final EncodersProcessorFactory _encodersProcessorFactory;

  final Map<CategoricalDataEncodingType, Iterable<String>> _encodingTypeToColumnName;
  final Map<String, CategoricalDataEncodingType> _columnNameToEncodingType;
  final Map<int, CategoricalDataEncodingType> _columnIndexToEncodingType;

  static const String _loggerPrefix = 'PreprocessorImpl';

  Future _initialization;
  List<List<dynamic>> _data; // the whole dataset including header
  Matrix _observations;
  Map<ZRange, CategoricalDataCodec> _rangeToCodec;
  Map<ZRange, List<Vector>> _rangeToEncoded;
  List<String> _header;
  RecordsProcessor _recordsProcessor;
  ZRange _labelColumnRange;

  @override
  Future<DataSet> get data async {
    await _initialization;
    return DataSet(_observations,
        outcomeColumnRange: _labelColumnRange, rangeToEncoded: _rangeToEncoded);
  }

  @override
  Future<Map<ZRange, CategoricalDataCodec>> get columnRangeToEncoder async {
    await _initialization;
    return _rangeToCodec;
  }

  Future<void> _init([Iterable<ZRange> rows, Iterable<ZRange> columns]) async {
    _data = await _dataReader.extractData();

    final rowsNum = _data.length;
    final columnsNum = _data.last.length;
    final indexRangesCombiner = _indexRangesCombinerFactory.create();
    final rowIndices = indexRangesCombiner.combine(
        rows ?? [ZRange.closedOpen(0, rowsNum - (_headerExists ? 1 : 0))]);
    final columnIndices = indexRangesCombiner
        .combine(columns ?? [ZRange.closedOpen(0, columnsNum)]);
    final originalHeader = _getOriginalHeader(_data);
    final labelIdx = _getLabelIdx(originalHeader, columnsNum);
    final records = _data.sublist(_headerExists ? 1 : 0);
    final encodersProcessor = _encodersProcessorFactory.create(originalHeader);
    final indexToEncodingType = encodersProcessor.getIndexToEncodingTypeMapping(
        _columnIndexToEncodingType, _encodingTypeToColumnName, _columnNameToEncodingType);
    final _headerExtractor = _headerExtractorFactory.create(columnIndices);

    _recordsProcessor = _recordsProcessorFactory.create(records,
        columnIndices, rowIndices, indexToEncodingType, _valueConverter,
        _codecFactory, _dtype);

    _observations = _recordsProcessor.convertAndEncodeRecords();
    _rangeToCodec = _recordsProcessor.rangeToCodec;
    _rangeToEncoded = _rangeToCodec.map((range, encoder) =>
        MapEntry(range, encoder.originalToEncoded.values));
    _labelColumnRange = _rangeToEncoded.isNotEmpty
        ? _rangeToEncoded.keys.firstWhere((range) => range.contains(labelIdx))
        : ZRange.singleton(labelIdx);
    _header = _headerExtractor.extract(_data);
  }

  List<String> _getOriginalHeader(List<List> data) => _headerExists
      ? data[0].map((dynamic el) => el.toString()).toList(growable: false)
      : <String>[];

  int _getLabelIdx(List<String> originalHeader, int columnsNum) {
    if (_labelIdxFromArgs != null) {
      if (_labelIdxFromArgs >= columnsNum || _labelIdxFromArgs < 0) {
        throw RangeError.range(_labelIdxFromArgs, 0, columnsNum - 1, null,
            _wrapErrorMessage('Invalid label column index'));
      }
      return _labelIdxFromArgs;
    }

    if (originalHeader.isNotEmpty) {
      final labelIdx = originalHeader.indexOf(_labelName);
      if (labelIdx == -1) {
        throw Exception(_wrapErrorMessage('There is no column named '
            '$_labelName'));
      }
      return labelIdx;
    }

    throw Exception(_wrapErrorMessage('Neither label index, nor label column'
        'are provided'));
  }

  String _wrapErrorMessage(String text) => '$_loggerPrefix: $text';
}
