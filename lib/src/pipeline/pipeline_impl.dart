import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline.dart';

class PipelineImpl implements Pipeline {
  PipelineImpl(
    DataFrame fittingData,
    Iterable<PipeableOperatorFn> operators, {
    DType dType = DType.float32,
  }) : _steps = operators.map((operator) => operator(fittingData));

  final Iterable<Pipeable> _steps;

  @override
  DataFrame process(DataFrame dataFrame) =>
      _steps.fold(dataFrame, (processed, step) => step.process(processed));
}
