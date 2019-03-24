import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:logging/logging.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory_impl.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/data_frame/csv_codec_factory/csv_codec_factory.dart';
import 'package:ml_preprocessing/src/data_frame/csv_codec_factory/csv_codec_factory_impl.dart';
import 'package:ml_preprocessing/src/data_frame/data_frame.dart';
import 'package:ml_preprocessing/src/data_frame/encoders_processor/encoders_processor_factory.dart';
import 'package:ml_preprocessing/src/data_frame/encoders_processor/encoders_processor_factory_impl.dart';
import 'package:ml_preprocessing/src/data_frame/header_extractor/header_extractor.dart';
import 'package:ml_preprocessing/src/data_frame/header_extractor/header_extractor_factory.dart';
import 'package:ml_preprocessing/src/data_frame/header_extractor/header_extractor_factory_impl.dart';
import 'package:ml_preprocessing/src/data_frame/read_mask_creator/read_mask_creator_factory.dart';
import 'package:ml_preprocessing/src/data_frame/read_mask_creator/read_mask_creator_factory_impl.dart';
import 'package:ml_preprocessing/src/data_frame/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/data_frame/to_float_number_converter/to_float_number_converter_impl.dart';
import 'package:ml_preprocessing/src/data_frame/validator/params_validator.dart';
import 'package:ml_preprocessing/src/data_frame/validator/params_validator_impl.dart';
import 'package:ml_preprocessing/src/data_frame/variables_extractor/variables_extractor.dart';
import 'package:ml_preprocessing/src/data_frame/variables_extractor/variables_extractor_factory.dart';
import 'package:ml_preprocessing/src/data_frame/variables_extractor/variables_extractor_factory_impl.dart';
import 'package:tuple/tuple.dart';

class CsvDataFrame implements DataFrame {
  CsvDataFrame.fromFile(String fileName, {
      // public parameters
      Type dtype,
      String fieldDelimiter = ',',
      String eol = '\n',
      int labelIdx,
      String labelName,
      bool headerExists = true,
      Map<int, List<Object>> categoriesByIndexes,
      Map<String, CategoricalDataEncoderType> categoryNameToEncoder,
      Map<int, CategoricalDataEncoderType> categoryIndexToEncoder,
      List<Tuple2<int, int>> rows,
      List<Tuple2<int, int>> columns,

      // private parameters, they are hidden by the factory
      CategoricalDataEncoderFactory encoderFactory =
        const CategoricalDataEncoderFactoryImpl(),

      DataFrameParamsValidator paramsValidator =
        const DataFrameParamsValidatorImpl(),

      ToFloatNumberConverter valueConverter =
        const ToFloatNumberConverterImpl(),

      DataFrameHeaderExtractorFactory headerExtractorFactory =
        const DataFrameHeaderExtractorFactoryImpl(),

      VariablesExtractorFactory featuresExtractorFactory =
        const VariablesExtractorFactoryImpl(),

      DataFrameReadMaskCreatorFactory readMaskCreatorFactory =
        const DataFrameReadMaskCreatorFactoryImpl(),

      EncodersProcessorFactory encodersProcessorFactory =
        const EncodersProcessorFactoryImpl(),

      CsvCodecFactory csvCodecFactory =
        const CsvCodecFactoryImpl(),

      Logger logger,
    })  :
      _dtype = dtype ?? Float32x4,
      _csvCodec =
        csvCodecFactory.create(eol: eol, fieldDelimiter: fieldDelimiter),
      _file = File(fileName),
      _labelIdx = labelIdx,
      _labelName = labelName,
      _headerExists = headerExists,
      _nameToEncoderType = categoryNameToEncoder ?? {},
      _indexToEncoderType = categoryIndexToEncoder ?? {},
      _encoderFactory = encoderFactory,
      _paramsValidator = paramsValidator,
      _valueConverter = valueConverter,
      _headerExtractorFactory = headerExtractorFactory,
      _variablesExtractorFactory = featuresExtractorFactory,
      _readMaskCreatorFactory = readMaskCreatorFactory,
      _encodersProcessorFactory = encodersProcessorFactory {
    final errorMsg = _paramsValidator.validate(
      labelIdx: labelIdx,
      labelName: labelName,
      rows: rows,
      columns: columns,
      headerExists: headerExists,
      namesToEncoders: categoryNameToEncoder,
      indexToEncoder: categoryIndexToEncoder,
    );
    if (errorMsg.isNotEmpty) {
      throw Exception(_wrapErrorMessage(errorMsg));
    }
    _initialization = _init(rows, columns);
  }

  final Type _dtype;
  final CsvCodec _csvCodec;
  final File _file;
  final int _labelIdx;
  final String _labelName;
  final bool _headerExists;
  final CategoricalDataEncoderFactory _encoderFactory;
  final DataFrameParamsValidator _paramsValidator;
  final ToFloatNumberConverter _valueConverter;
  final DataFrameReadMaskCreatorFactory _readMaskCreatorFactory;
  final DataFrameHeaderExtractorFactory _headerExtractorFactory;
  final VariablesExtractorFactory _variablesExtractorFactory;
  final EncodersProcessorFactory _encodersProcessorFactory;

  final Map<String, CategoricalDataEncoderType> _nameToEncoderType;
  final Map<int, CategoricalDataEncoderType> _indexToEncoderType;

  static const String _loggerPrefix = 'CsvDataFrame';

  Future _initialization;
  List<List<dynamic>> _data; // the whole dataset including header
  Matrix _features;
  Matrix _labels;
  List<String> _header;
  DataFrameHeaderExtractor _headerExtractor;
  VariablesExtractor _variablesExtractor;
  Map<int, CategoricalDataEncoder> _encoders;

  @override
  Future<List<String>> get header async {
    await _initialization;
    return _header ??= _headerExists ? _headerExtractor.extract(_data) : null;
  }

  @override
  Future<Matrix> get features async {
    await _initialization;
    return _features ??= _variablesExtractor.extractFeatures();
  }

  @override
  Future<Matrix> get labels async {
    await _initialization;
    return _labels ??= _variablesExtractor.extractLabels();
  }

  Future<Null> _init([Iterable<Tuple2<int, int>> rows,
    Iterable<Tuple2<int, int>> columns]) async {
    _data = await _extractData();

    final rowsNum = _data.length;
    final columnsNum = _data.last.length;
    final readMaskCreator = _readMaskCreatorFactory.create();

    final rowsMask = readMaskCreator.create(
        rows ?? [Tuple2(0, rowsNum - (_headerExists ? 2 : 1))]);
    final columnsMask = readMaskCreator
        .create(columns ?? [Tuple2(0, columnsNum - 1)]);

    final originalHeader = _getOriginalHeader(_data);
    final labelIdx = _getLabelIdx(originalHeader, columnsNum);
    final records = _data.sublist(_headerExists ? 1 : 0);
    final encodersProcessor = _encodersProcessorFactory.create(originalHeader,
        _encoderFactory, _dtype);

    _encoders = encodersProcessor.createEncoders(_indexToEncoderType,
        _nameToEncoderType);
    _headerExtractor = _headerExtractorFactory.create(columnsMask);
    _variablesExtractor = _variablesExtractorFactory.create(records, rowsMask,
        columnsMask, _encoders, labelIdx, _valueConverter, _dtype);
  }

  List<String> _getOriginalHeader(List<List> data) => _headerExists
      ? data[0].map((dynamic el) => el.toString()).toList(growable: false)
      : <String>[];

  Future<List<List<dynamic>>> _extractData() async {
    final fileStream = _file.openRead();
    return await (fileStream
        .transform(utf8.decoder)
        .transform(_csvCodec.decoder)
        .toList());
  }

  int _getLabelIdx(List<String> originalHeader, int columnsNum) {
    if (_labelIdx != null) {
      if (_labelIdx >= columnsNum || _labelIdx < 0) {
        throw RangeError.range(_labelIdx, 0, columnsNum - 1, null,
            _wrapErrorMessage('Invalid label column index'));
      }
      return _labelIdx;
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

  @override
  Iterable<String> decode(Matrix encoded, {String colName, int colIdx}) {
    if (colName == null && colIdx == null) {
      throw Exception(_wrapErrorMessage('Neither column name, nor column index '
          'are provided'));
    }
    if (colName != null) {
      if (!_headerExists) {
        throw Exception(_wrapErrorMessage('Column name `$colName` provided, '
            'but the data frame does not have a header'));
      }
      if (!_header.contains(colName)) {
        throw Exception(_wrapErrorMessage('Provided column name `$colName` is '
            'not in the header. Maybe provided column has been cutted out '
            'during data preparation?'));
      }
    }

    if (colIdx != null && (colIdx < 0 || colIdx >= _data.first.length)) {
      throw RangeError.index(colIdx, _data.first,
          _wrapErrorMessage('Wrong column index is provided'));
    }

    final idx = colIdx != null ? colIdx : _header.indexOf(colName);
    if (!_encoders.containsKey(idx)) {
      throw Exception(
          _wrapErrorMessage('Provided column is not a categorical column'));
    }
    return _encoders[idx].decode(encoded);
  }

  String _wrapErrorMessage(String text) => '$_loggerPrefix: $text';
}