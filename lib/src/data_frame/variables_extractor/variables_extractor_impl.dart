import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/data_frame/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/data_frame/variables_extractor/variables_extractor.dart';
import 'package:tuple/tuple.dart';
import 'package:xrange/zrange.dart';

class VariablesExtractorImpl implements VariablesExtractor {
  VariablesExtractorImpl(
      this._observations,
      this._columnIndices,
      this._rowIndices,
      this._encoders,
      this._labelIdx,
      this._toFloatConverter,
      [DType dtype = DType.float32]) : _dtype = dtype {
    if (_columnIndices.length > _observations.first.length) {
      throw Exception(columnIndicesWrongNumberMsg);
    }
    if (_rowIndices.length > _observations.length) {
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
  final Map<int, CategoricalDataEncoder> _encoders;
  final int _labelIdx;
  final ToFloatNumberConverter _toFloatConverter;
  final List<List<Object>> _observations;

  bool get _hasCategoricalData => _encoders.isNotEmpty;

  Tuple3<Matrix, Matrix, Set<ZRange>> _data;

  @override
  Matrix get features => _extract().item1;

  @override
  Matrix get labels => _extract().item2;

  @override
  Set<ZRange> get categoricalIndices => _extract().item3;

  Tuple3<Matrix, Matrix, Set<ZRange>> _extract() {
    if (_data == null) {
      final columnsData = _collectColumnsData();
      _data = _processColumns(columnsData.item1, columnsData.item2);

      // if categorical data exists in dataset, it means, that selection by
      // given [_rowIndices] hasn't taken place yet (we had to use the whole
      // dataset in order to collect all the categorical data values), so
      // we should select needed rows here
      if (_hasCategoricalData) {
        _data = Tuple3(
            Matrix.fromRows(_rowIndices.map(_data.item1.getRow)
                .toList(growable: false)),
            Matrix.fromRows(_rowIndices.map(_data.item2.getRow)
                .toList(growable: false)),
            _data.item3,
        );
      }
    }
    return _data;
  }

  Tuple2<Map<int, List<double>>, Map<int, List<String>>> _collectColumnsData() {
    // key here is a zero-based number of column in the [records]
    final Map<int, List<String>> categoricalColumns = {};
    // key here is a zero-based number of column in the [records]
    final Map<int, List<double>> numericalColumns = {};

    // if categories exist - iterate through the whole data to collect all the
    // categorical values in order to fit categorical data encoders
    final rowIndices = _hasCategoricalData
        ? ZRange.closedOpen(0, _observations.length).values() : _rowIndices;

    rowIndices.forEach((rowIdx) {
      final rowData = _processRow(_observations[rowIdx]);
      rowData.item1.forEach((idx, value) =>
          numericalColumns.putIfAbsent(idx, () => []).add(value));
      rowData.item2.forEach((idx, value) =>
          categoricalColumns.putIfAbsent(idx, () => []).add(value));
    });

    return Tuple2(numericalColumns, categoricalColumns);
  }

  Tuple2<Map<int, double>, Map<int, String>> _processRow(
      List<Object> row) {
    final Map<int, double> numericalValues = {};
    final Map<int, String> categoricalValues = {};
    _columnIndices.forEach((idx) {
      if (_encoders.containsKey(idx)) {
        categoricalValues[idx] = row[idx].toString();
      } else {
        numericalValues[idx] = _toFloatConverter.convert(row[idx]);
      }
    });
    return Tuple2(numericalValues, categoricalValues);
  }

  Tuple3<Matrix, Matrix, Set<ZRange>> _processColumns(
    Map<int, List<double>> numericalColumns,
    Map<int, List<String>> categoricalColumns,
  ) {
    final featureColumns = <Vector>[];
    final labelColumns = <Vector>[];
    final categoricalIndices = <ZRange>{};
    final updateColumns = (int i, Vector vectorColumn) {
      i == _labelIdx
          ? labelColumns.add(vectorColumn)
          : featureColumns.add(vectorColumn);
    };
    int idx = 0;
    _columnIndices.forEach((columnIdx) {
      if (numericalColumns.containsKey(columnIdx)) {
        updateColumns(columnIdx, Vector.fromList(numericalColumns[columnIdx],
            dtype: _dtype));
        idx++;
      } else if (categoricalColumns.containsKey(columnIdx)) {
        final encoded = _encoders[columnIdx]
            .encode(categoricalColumns[columnIdx]);
        for (final column in encoded.columns) {
          updateColumns(columnIdx, column);
        }
        categoricalIndices.add(ZRange.closed(idx, idx + encoded.columnsNum - 1));
        idx += encoded.columnsNum;
      }
    });

    return Tuple3(
        Matrix.fromColumns(featureColumns, dtype: _dtype),
        Matrix.fromColumns(labelColumns, dtype: _dtype),
        categoricalIndices,
    );
  }
}
