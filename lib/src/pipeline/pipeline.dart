import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

/// A class, that is used to organize data preprocessing stages in pipeline
/// manner.
///
/// To use the pipeline, it's needed to fit all the preprocessors by
/// passing the [fittingData] into constructor. The preprocessors from
/// [operators] list will use the data to find unique values or for some other
/// operations to prepare themselves to new portions of data (it's what we
/// called `fitting`).
class Pipeline {
  Pipeline(
      DataFrame fittingData,
      Iterable<PipeableOperatorFn> operators,
      {
        DType dType = DType.float32,
      }
  ) :
        _steps = operators.map((operator) => operator(fittingData));

  final Iterable<Pipeable> _steps;

  DataFrame process(DataFrame dataFrame) =>
      _steps.fold(dataFrame, (processed, step) => step.process(processed));
}
