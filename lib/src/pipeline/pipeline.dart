import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

class Pipeline {
  Pipeline(DataFrame fittingData, Iterable<PipeableOperatorFn> operators) :
    _steps = operators.map((operator) => operator(fittingData));

  final Iterable<Pipeable> _steps;

  DataFrame process(DataFrame data) =>
      _steps.fold(data, (processed, step) => step.process(processed));
}
