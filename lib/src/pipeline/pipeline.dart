import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline_impl.dart';

/// A class that is used to organize data preprocessing stages in a pipeline
/// manner.
///
/// Building the pipeline is a `fitting` stage - it's a preliminary stage where
/// operators extract metadata from the source data passed to [Pipeline] for
/// future use, no preprocessing happens here.
///
/// Once the `process` method is called, the actual data preprocessing comes to
/// play.
///
/// It's normal, when one uses the same data for fitting and processing, like
/// in the example below.
///
/// Example:
///
/// ```dart
/// import 'package:ml_dataframe/ml_dataframe.dart';
/// import 'package:ml_preprocessing/ml_preprocessing.dart';
//'
/// Future main() async {
///   final dataFrame = await fromCsv('example/dataset.csv', columns: [0, 1, 2, 3]);
//
///   final pipeline = Pipeline(dataFrame, [
///     toOneHotLabels(
///       columnNames: ['position'],
///       headerPostfix: '_position',
///     ),
///     toIntegerLabels(
///       columnNames: ['country'],
///     ),
///   ]);
///
///   final processed = pipeline.process(dataFrame);
/// }
/// ```
abstract class Pipeline {
  /// Takes [fittingData] to fit preprocessors from [operators] list
  /// in order to use them further for new data of the same source as
  /// [fittingData] via [process] method.
  factory Pipeline(
      DataFrame fittingData, Iterable<PipeableOperatorFn> operators,
      {DType dType}) = PipelineImpl;

  /// Applies fitted preprocessors to [dataFrame] and returns transformed
  /// data
  DataFrame process(DataFrame dataFrame);
}
