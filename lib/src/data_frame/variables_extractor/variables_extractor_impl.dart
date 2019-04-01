import 'dart:typed_data';

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
      [Type dtype = Float32x4]) : _dtype = dtype {
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

  final Type _dtype;
  final List<int> _rowIndices;
  final List<int> _columnIndices;
  final Map<int, CategoricalDataEncoder> _encoders;
  final int _labelIdx;
  final ToFloatNumberConverter _toFloatConverter;
  final List<List<Object>> _observations;

  bool get _hasCategoricalData => _encoders.isNotEmpty;

  Tuple2<Matrix, Matrix> _data;

  @override
  Matrix extractFeatures() => _extract().item1;

  @override
  Matrix extractLabels() => _extract().item2;

  Tuple2<Matrix, Matrix> _extract() {
    if (_data == null) {
      final columnsData = _collectColumnsData();
      _data = _processColumns(columnsData.item1, columnsData.item2);
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

    for (final rowIdx in rowIndices) {
      final rowData = _processRow(_observations[rowIdx]);
      rowData.item1.forEach((idx, value) =>
          numericalColumns.putIfAbsent(idx, () => []).add(value));
      rowData.item2.forEach((idx, value) =>
          categoricalColumns.putIfAbsent(idx, () => []).add(value));
    }

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

  Tuple2<Matrix, Matrix> _processColumns(
    Map<int, List<double>> numericalColumns,
    Map<int, List<String>> categoricalColumns,
  ) {
    final featureColumns = <Vector>[];
    final labelColumns = <Vector>[];
    final updateColumns = (int i, Vector vectorColumn) {
      i == _labelIdx
          ? labelColumns.add(vectorColumn)
          : featureColumns.add(vectorColumn);
    };
    _columnIndices.forEach((columnIdx) {
      if (numericalColumns.containsKey(columnIdx)) {
        updateColumns(columnIdx, Vector.from(numericalColumns[columnIdx],
            dtype: _dtype));
      } else if (categoricalColumns.containsKey(columnIdx)) {
        final encoded = _encoders[columnIdx]
            .encode(categoricalColumns[columnIdx]);
        for (int col = 0; col < encoded.columnsNum; col++) {
          updateColumns(columnIdx, encoded.getColumn(col));
        }
      }
    });
    return Tuple2(
        featureColumns.isNotEmpty
            ? _filterMatrix(Matrix.columns(featureColumns, dtype: _dtype))
            : null,
        labelColumns.isNotEmpty
            ? _filterMatrix(Matrix.columns(labelColumns, dtype: _dtype))
            : null
    );
  }

  Matrix _filterMatrix(Matrix data) {
    if (!_hasCategoricalData) return data;
    return Matrix.rows(_rowIndices.map(data.getRow).toList(growable: true));
  }
}
