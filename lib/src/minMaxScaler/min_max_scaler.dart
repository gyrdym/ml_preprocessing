import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

class MinMaxScaler implements Pipeable {
  MinMaxScaler(DataFrame fittingData, {
    DType dtype = DType.float32,
  }) :
        _dtype = dtype,
        _min = fittingData.toMatrix(dtype).reduceRows((row) => ),
        _max = fittingData.toMatrix(dtype).reduceRows() {
    if (!fittingData.toMatrix(dtype).hasData) {
      throw Exception('No data provided');
    }
  }

  final DType _dtype;
  final Vector _min;
  final Vector _max;

  @override
  DataFrame process(DataFrame input) {
    final inputAsMatrix = input.toMatrix(_dtype);

    final discreteColumnNames = input
        .series
        .where((series) => series.isDiscrete)
        .map((series) => series.name);

    return DataFrame.fromMatrix(
      processedMatrix,
      header: input.header,
      discreteColumnNames: discreteColumnNames,
    );
  }
}
