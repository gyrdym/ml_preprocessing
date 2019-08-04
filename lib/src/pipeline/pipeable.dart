import 'package:ml_preprocessing/src/pipeline/pipeline_step_data.dart';

abstract class Pipeable {
  PipelineStepData process(PipelineStepData input);
}
