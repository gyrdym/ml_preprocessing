import 'package:ml_preprocessing/ml_preprocessing.dart';

abstract class Pipeable {
  DataFrame process(DataFrame input);
}

typedef PipeableOperatorFn = Pipeable Function(DataFrame data);
