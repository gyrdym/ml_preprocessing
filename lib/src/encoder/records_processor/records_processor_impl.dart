import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/numerical_converter/numerical_converter.dart';
import 'package:ml_preprocessing/src/encoder/records_processor/records_processor.dart';
import 'package:quiver/iterables.dart';
import 'package:xrange/zrange.dart';

class RecordsProcessorImpl implements RecordsProcessor {
  RecordsProcessorImpl(
      this._sourceData,
      this._columnToEncoder,
      this._numericalConverter,
      this._codecFactory,
      {
        DType dtype = DType.float32,
      }) : _dtype = dtype;

  static const String columnIndicesWrongNumberMsg =
      'Column indices number should not be greater than actual columns number '
      'in the dataset!';

  static const String rowIndicesWrongNumberMsg =
      'Row indices number should not be greater than actual rows number in the '
      'dataset!';

  final DType _dtype;
  final Map<int, CategoricalDataEncodingType> _columnToEncoder;
  final CategoricalDataCodecFactory _codecFactory;
  final NumericalConverter _numericalConverter;
  final DataFrame _sourceData;

  EncodingDescriptor _encodedData;

  @override
  DataFrame convertAndEncodeRecords() => _encode().encodedData;

  @override
  Map<ZRange, CategoricalDataCodec> get columnRangeToCodec =>
      _encode().rangeToCodec;

  EncodingDescriptor _encode() =>
      _encodedData ??= _encodeColumns(_collectColumnsData());

  _ColumnsData _collectColumnsData() {
    // key here is a zero-based number of column in the [records]
    final Map<int, List<String>> columnToCategoricalValues = {};
    // key here is a zero-based number of column in the [records]
    final Map<int, List<double>> columnToNumericalValues = {};

    enumerate(_sourceData.rows).forEach((indexedRow) {
      final rowData = _processRow(indexedRow.value);
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
    enumerate(_sourceData.column).forEach((indexedColumn) {
      if (_columnToEncoder.containsKey(indexedColumn.index)) {
        columnToCategoricalValues[indexedColumn.index] =
            row[indexedColumn.index].toString();
      } else {
        columnToNumericalValues[indexedColumn.index] =
            _numericalConverter.convert(row[indexedColumn.index]);
      }
    });
    return _RowData(columnToNumericalValues, columnToCategoricalValues);
  }

  EncodingDescriptor _encodeColumns(_ColumnsData columnsData) {
    final columns = <Vector>[];
    final rangeToCodec = <ZRange, CategoricalDataCodec>{};

    int encodedColIdx = 0;

    enumerate(_sourceData.column).forEach((indexedColumn) {
      if (columnsData.columnToCategoricalValues
          .containsKey(indexedColumn.index)) {
        final categoricalValues = columnsData
            .columnToCategoricalValues[indexedColumn.index];
        final encoderType = _columnToEncoder[indexedColumn.index];
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
            .columnToNumericalValues[indexedColumn.index];
        final column = Vector.fromList(numericalValues, dtype: _dtype);
        columns.add(column);
        encodedColIdx++;
      }
    });

    return EncodingDescriptor(
        DataFrame.fromMatrix(Matrix.fromColumns(columns, dtype: _dtype)),
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
