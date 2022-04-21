import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/src/standardizer/standardizer.dart';

class StandardizerImpl implements Standardizer {
  StandardizerImpl(
    DataFrame fittingData, {
    DType dtype = DType.float32,
  })  : _dtype = dtype,
        _mean = fittingData.toMatrix(dtype).mean(),
        _deviation = Vector.fromList(
          // TODO: Consider SIMD-aware mapping
          fittingData
              .toMatrix(dtype)
              .deviation()
              .map((el) => el == 0 ? 1 : el)
              .toList(),
          dtype: dtype,
        ) {
    if (!fittingData.toMatrix(dtype).hasData) {
      throw Exception('No data provided');
    }
  }

  final DType _dtype;
  final Vector _mean;
  final Vector _deviation;

  /// Takes as an argument [input] with columns of various distribution types
  /// and returns a [DataFrame], columns of which are normally distributed
  @override
  DataFrame process(DataFrame input) {
    final inputAsMatrix = input.toMatrix(_dtype);

    if (inputAsMatrix.columnsNum != _deviation.length) {
      throw Exception('Passed dataframe differs from the one used during '
          'creation of the Standardizer: expected columns number - '
          '${_deviation.length}, given - ${inputAsMatrix.columnsNum}.');
    }

    final processedMatrix =
        inputAsMatrix.mapRows((row) => (row - _mean) / _deviation);
    final discreteColumnNames = input.series
        .where((series) => series.isDiscrete)
        .map((series) => series.name);

    return DataFrame.fromMatrix(
      processedMatrix,
      header: input.header,
      discreteColumnNames: discreteColumnNames,
    );
  }
}
