import 'package:ml_linalg/matrix.dart';

@deprecated
abstract class InterceptPreprocessor {
  Matrix addIntercept(Matrix points);
}
