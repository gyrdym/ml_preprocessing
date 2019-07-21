import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory_impl.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/csv_codec_factory/csv_codec_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/csv_codec_factory/csv_codec_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/header_extractor/header_extractor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/header_extractor/header_extractor_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/index_ranges_combiner/index_ranges_combiner_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/index_ranges_combiner/index_ranges_combiner_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/preprocessor.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator_impl.dart';
import 'package:xrange/zrange.dart';

class CsvPreprocessor implements Preprocessor {
  CsvPreprocessor.fromFile(String fileName, {
      // public parameters
      Type dtype,
      String fieldDelimiter = ',',
      String eol = '\n',
      int labelIdx,
      String labelName,
      bool headerExists = true,
      Map<CategoricalDataEncodingType, Iterable<String>> encoders,
      Map<String, CategoricalDataEncodingType> categories,
      Map<int, CategoricalDataEncodingType> categoryIndices,
      List<ZRange> rows,
      List<ZRange> columns,

      // private parameters, they are hidden by the factory
      CategoricalDataCodecFactory encoderFactory =
        const CategoricalDataCodecFactoryImpl(),

      DataFrameParamsValidator paramsValidator =
        const DataFrameParamsValidatorImpl(),

      ToFloatNumberConverter valueConverter =
        const ToFloatNumberConverterImpl(),

      DataFrameHeaderExtractorFactory headerExtractorFactory =
        const DataFrameHeaderExtractorFactoryImpl(),

      RecordsProcessorFactory featuresExtractorFactory =
        const RecordsProcessorFactoryImpl(),

      IndexRangesCombinerFactory indexRangesCombinerFactory =
        const IndexRangesCombinerFactoryImpl(),

      EncodersProcessorFactory encodersProcessorFactory =
        const EncodersProcessorFactoryImpl(),

      CsvCodecFactory csvCodecFactory =
        const CsvCodecFactoryImpl(),
    })  :
      _dtype = dtype ?? DType.float32,
      _csvCodec =
        csvCodecFactory.create(eol: eol, fieldDelimiter: fieldDelimiter),
      _file = File(fileName),
      _labelIdxFromArgs = labelIdx,
      _labelName = labelName,
      _headerExists = headerExists,
      _encoderTypeToName = encoders,
      _nameToEncoderType = categories ?? {},
      _indexToEncoderType = categoryIndices ?? {},
      _codecFactory = encoderFactory,
      _paramsValidator = paramsValidator,
      _valueConverter = valueConverter,
      _headerExtractorFactory = headerExtractorFactory,
      _recordsProcessorFactory = featuresExtractorFactory,
      _indexRangesCombinerFactory = indexRangesCombinerFactory,
      _encodersProcessorFactory = encodersProcessorFactory {
    final errorMsg = _paramsValidator.validate(
      labelIdx: labelIdx,
      labelName: labelName,
      rows: rows,
      columns: columns,
      headerExists: headerExists,
      namesToEncoders: categories,
      indexToEncoder: categoryIndices,
    );
    if (errorMsg.isNotEmpty) {
      throw Exception(_wrapErrorMessage(errorMsg));
    }
    _initialization = _init(rows, columns);
  }

  final DType _dtype;
  final CsvCodec _csvCodec;
  final File _file;
  final int _labelIdxFromArgs;
  final String _labelName;
  final bool _headerExists;
  final CategoricalDataCodecFactory _codecFactory;
  final DataFrameParamsValidator _paramsValidator;
  final ToFloatNumberConverter _valueConverter;
  final IndexRangesCombinerFactory _indexRangesCombinerFactory;
  final DataFrameHeaderExtractorFactory _headerExtractorFactory;
  final RecordsProcessorFactory _recordsProcessorFactory;
  final EncodersProcessorFactory _encodersProcessorFactory;

  final Map<CategoricalDataEncodingType, Iterable<String>> _encoderTypeToName;
  final Map<String, CategoricalDataEncodingType> _nameToEncoderType;
  final Map<int, CategoricalDataEncodingType> _indexToEncoderType;

  static const String _loggerPrefix = 'CsvDataFrame';

  Future _initialization;
  List<List<dynamic>> _data; // the whole dataset including header
  Matrix _observations;
  Map<ZRange, CategoricalDataCodec> _rangeToEncoder;
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
    return _rangeToEncoder;
  }

  Future<void> _init([Iterable<ZRange> rows, Iterable<ZRange> columns]) async {
    _data = await _extractDataFromFile();

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
    final encodersProcessor = _encodersProcessorFactory.create(originalHeader,
        _codecFactory, _dtype);
    final indexToEncoderType = encodersProcessor.createEncoders(
        _indexToEncoderType, _encoderTypeToName, _nameToEncoderType);
    final _headerExtractor = _headerExtractorFactory.create(columnIndices);

    _recordsProcessor = _recordsProcessorFactory.create(records,
        columnIndices, rowIndices, indexToEncoderType, _valueConverter,
        _codecFactory, _dtype);

    _observations = _recordsProcessor.encodeRecords();
    _rangeToEncoder = _recordsProcessor.rangeToCodec;
    _labelColumnRange = _rangeToEncoded.keys
        .firstWhere((range) => range.contains(labelIdx));
    _rangeToEncoded = _rangeToEncoder.map((range, encoder) =>
        MapEntry(range, encoder.originalToEncoded.values));
    _header = _headerExtractor.extract(_data);
  }

  List<String> _getOriginalHeader(List<List> data) => _headerExists
      ? data[0].map((dynamic el) => el.toString()).toList(growable: false)
      : <String>[];

  Future<List<List<dynamic>>> _extractDataFromFile() =>
      _file.openRead()
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(_csvCodec.decoder)
        .toList();

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
            '`$_labelName`'));
      }
      return labelIdx;
    }

    throw Exception(_wrapErrorMessage('Neither label index, nor label column'
        'are provided'));
  }

  String _wrapErrorMessage(String text) => '$_loggerPrefix: $text';
}
