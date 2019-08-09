import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/data_frame/data_frame.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

class Pipeline {
  Pipeline(DataFrame data, Iterable<PipeableOperatorFn> operators) :
    _steps = operators.map((operator) => operator(data));

  final Iterable<Pipeable> _steps;

  DataFrame process(DataFrame data) =>
      _steps.fold(data, (processed, step) => step.process(processed));
}
