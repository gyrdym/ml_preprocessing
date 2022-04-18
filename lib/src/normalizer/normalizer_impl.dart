import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/norm.dart';
import 'package:ml_preprocessing/src/normalizer/normalizer.dart';

class NormalizerImpl implements Normalizer {
  NormalizerImpl([this._norm = Norm.euclidean, this._dtype = DType.float32]);

  final Norm _norm;
  final DType _dtype;

  @override
  DataFrame process(DataFrame input) {
    final transformed =
    input.toMatrix(_dtype).mapRows((row) => row.normalize(_norm));

    return DataFrame.fromMatrix(transformed, header: input.header);
  }
}
