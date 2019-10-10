import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

/// A class, that is used to organize data preprocessing stages in a pipeline
/// manner.
class Pipeline {
  /// Takes [fittingData] to fit preprocessors from [operators] list
  /// in order to use them farther for new data of the same source as
  /// [fittingData] via [process] method.
  Pipeline(
      DataFrame fittingData,
      Iterable<PipeableOperatorFn> operators,
      {
        DType dType = DType.float32,
      }
  ) :
        _steps = operators.map((operator) => operator(fittingData));

  final Iterable<Pipeable> _steps;

  /// Applies fitted preprocessors to [dataFrame] and returns transformed
  /// data
  DataFrame process(DataFrame dataFrame) =>
      _steps.fold(dataFrame, (processed, step) => step.process(processed));
}
