import 'package:ml_preprocessing/src/intercept_preprocessor/intercept_preprocessor.dart';
import 'package:ml_linalg/linalg.dart';

class InterceptPreprocessorImpl implements InterceptPreprocessor {
  const InterceptPreprocessorImpl(this.dtype, {double interceptScale = 1.0})
      : _interceptScale = interceptScale;

  final Type dtype;
  final double _interceptScale;

  @override
  Matrix addIntercept(Matrix points) {
    if (_interceptScale == 0.0) {
      return points;
    }
    final _points = List<List<double>>(points.rowsNum);
    for (int i = 0; i < points.rowsNum; i++) {
      _points[i] = points[i].toList()..insert(0, 1.0 * _interceptScale);
    }
    return Matrix.from(_points, dtype: dtype);
  }
}