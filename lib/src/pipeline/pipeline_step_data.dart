import 'package:ml_preprocessing/src/data_frame/dataframe.dart';

class PipelineStepData {
  PipelineStepData(this.data, this.expandedColumnIds);

  final DataFrame data;
  final Iterable<Iterable<int>> expandedColumnIds;
}
