import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';

abstract class Pipeable {
  DataFrame process(DataFrame input);
}

typedef PipeableOperatorFn = Pipeable Function(DataFrame data, {DType? dtype});
