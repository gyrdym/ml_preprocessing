import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor.dart';
import 'package:ml_preprocessing/src/preprocessor/numerical_converter/numerical_converter.dart';
import 'package:xrange/zrange.dart';

class RecordsProcessorImpl implements RecordsProcessor {
  RecordsProcessorImpl(
      this._rawRecords,
      this._columnIndices,
      this._rowIndices,
      this._columnToEncoder,
      this._numericalConverter,
      this._codecFactory,
      {
        DType dtype = DType.float32,
      }) : _dtype = dtype {
    if (_columnIndices.length > _rawRecords.first.length) {
      throw Exception(columnIndicesWrongNumberMsg);
    }
    if (_rowIndices.length > _rawRecords.length) {
      throw Exception(rowIndicesWrongNumberMsg);
    }
  }

  static const String columnIndicesWrongNumberMsg =
      'Column indices number should not be greater than actual columns number '
      'in the dataset!';

  static const String rowIndicesWrongNumberMsg =
      'Row indices number should not be greater than actual rows number in the '
      'dataset!';

  final DType _dtype;
  final List<int> _rowIndices;
  final List<int> _columnIndices;
  final Map<int, CategoricalDataEncodingType> _columnToEncoder;
  final CategoricalDataCodecFactory _codecFactory;
  final NumericalConverter _numericalConverter;
  final List<List<dynamic>> _rawRecords;

  bool get _hasCategoricalData => _columnToEncoder.isNotEmpty;

  _EncodedDataInfo _encodedData;

  @override
  Matrix convertAndEncodeRecords() => _encode().records;

  @override
  Map<ZRange, CategoricalDataCodec> get rangeToCodec =>
      _encode().rangeToCodec;

  _EncodedDataInfo _encode() {
    if (_encodedData == null) {
      _encodedData = _encodeColumns(_collectColumnsData());

      // if categorical data exists in dataset, it means, that selection by
      // given [_rowIndices] hasn't taken place yet (we had to use the whole
      // dataset in order to collect all the categorical data values), so
      // we should select needed rows here
      if (_hasCategoricalData) {
        _encodedData = _EncodedDataInfo(
            Matrix.fromRows(_rowIndices.map(_encodedData.records.getRow)
                .toList(growable: false)),
            _encodedData.rangeToCodec,
        );
      }
    }
    return _encodedData;
  }

  _ColumnsData _collectColumnsData() {
    // key here is a zero-based number of column in the [records]
    final Map<int, List<String>> columnToCategoricalValues = {};
    // key here is a zero-based number of column in the [records]
    final Map<int, List<double>> columnToNumericalValues = {};

    // if categories exist - iterate through the whole data to collect all the
    // categorical values in order to fit categorical data encoders
    final rowIndices = _hasCategoricalData
        ? ZRange.closedOpen(0, _rawRecords.length).values() : _rowIndices;

    rowIndices.forEach((rowIdx) {
      final rowData = _processRow(_rawRecords[rowIdx]);
      rowData.columnToNumericalValues.forEach((idx, value) =>
          columnToNumericalValues.putIfAbsent(idx, () => []).add(value));
      rowData.columnToCategoricalValues.forEach((idx, value) =>
          columnToCategoricalValues.putIfAbsent(idx, () => []).add(value));
    });

    return _ColumnsData(columnToNumericalValues, columnToCategoricalValues);
  }

  _RowData _processRow(
      List<Object> row) {
    final Map<int, double> columnToNumericalValues = {};
    final Map<int, String> columnToCategoricalValues = {};
    _columnIndices.forEach((idx) {
      if (_columnToEncoder.containsKey(idx)) {
        columnToCategoricalValues[idx] = row[idx].toString();
      } else {
        columnToNumericalValues[idx] = _numericalConverter.convert(row[idx]);
      }
    });
    return _RowData(columnToNumericalValues, columnToCategoricalValues);
  }

  _EncodedDataInfo _encodeColumns(_ColumnsData columnsData) {
    final columns = <Vector>[];
    final rangeToCodec = <ZRange, CategoricalDataCodec>{};

    int encodedColIdx = 0;

    _columnIndices.forEach((sourceColIdx) {
      if (columnsData.columnToCategoricalValues.containsKey(sourceColIdx)) {
        final categoricalValues = columnsData
            .columnToCategoricalValues[sourceColIdx];
        final encoderType = _columnToEncoder[sourceColIdx];
        final codec = _codecFactory.fromType(encoderType, categoricalValues,
            _dtype);
        final encoded = codec.encode(categoricalValues);
        for (final column in encoded.columns) {
          columns.add(column);
        }
        final range = ZRange.closed(encodedColIdx,
            encodedColIdx + encoded.columnsNum - 1);
        rangeToCodec[range] = codec;
        encodedColIdx += encoded.columnsNum;
      } else {
        final numericalValues = columnsData
            .columnToNumericalValues[sourceColIdx];
        final column = Vector.fromList(numericalValues, dtype: _dtype);
        columns.add(column);
        encodedColIdx++;
      }
    });

    return _EncodedDataInfo(
        Matrix.fromColumns(columns, dtype: _dtype),
        rangeToCodec,
    );
  }
}

class _ColumnsData {
  _ColumnsData(this.columnToNumericalValues, this.columnToCategoricalValues);

  // key here is a zero-based number of column in the [records]
  final Map<int, List<double>> columnToNumericalValues;

  // key here is a zero-based number of column in the [records]
  final Map<int, List<String>> columnToCategoricalValues;
}

class _RowData {
  _RowData(this.columnToNumericalValues, this.columnToCategoricalValues);

  final Map<int, double> columnToNumericalValues;
  final Map<int, String> columnToCategoricalValues;
}

class _EncodedDataInfo {
  _EncodedDataInfo(this.records, this.rangeToCodec);

  final Matrix records;
  final Map<ZRange, CategoricalDataCodec> rangeToCodec;
}

