import 'dart:typed_data';

import 'package:ml_linalg/linalg.dart';
import 'package:ml_preprocessing/float32x4_intercept_preprocessor.dart';

class Float32x4InterceptPreprocessorInternal implements Float32x4InterceptPreprocessor {
  final double _interceptScale;

  Float32x4InterceptPreprocessorInternal({double interceptScale = 1.0}) : _interceptScale = interceptScale;

  MLMatrix<Float32x4> addIntercept(MLMatrix<Float32x4> points) {
    if (_interceptScale == 0.0) {
      return points;
    }

    final _points = List<List<double>>(points.rowsNum);
    for (int i = 0; i < points.rowsNum; i++) {
      _points[i] = points[i].toList()..insert(0, 1.0 * _interceptScale);
    }
    return Float32x4Matrix.from(_points);
  }
}
