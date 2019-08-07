import 'package:ml_preprocessing/src/data_frame/data_frame.dart';

class PipelineStepData {
  PipelineStepData(this.data, this.expandedColumnIds);

  final DataFrame data;
  final Iterable<Iterable<int>> expandedColumnIds;
}
