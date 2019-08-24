import 'package:ml_dataframe/ml_dataframe.dart';

abstract class Pipeable {
  DataFrame process(DataFrame input);
}

typedef PipeableOperatorFn = Pipeable Function(DataFrame data);
