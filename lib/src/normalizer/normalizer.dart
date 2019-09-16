import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';

class Normalizer implements Pipeable {
  Normalizer([this._norm = Norm.euclidean]);

  final Norm _norm;

  @override
  DataFrame process(DataFrame input) {
    final transformed = input
        .toMatrix()
        .mapRows((row) => row.normalize(_norm));

    return DataFrame.fromMatrix(transformed, header: input.header);
  }
}
