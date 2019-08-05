import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/data_frame/dataframe.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline_step_data.dart';

class Pipeline {
  Pipeline(this._steps);

  final Iterable<Pipeable> _steps;

  DataFrame apply(DataFrame data) =>
      _steps.fold(
          PipelineStepData(data, null),
          (processed, step) => step.process(processed)
      ).data;
}
