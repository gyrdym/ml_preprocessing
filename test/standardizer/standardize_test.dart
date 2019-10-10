import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/standardizer/standardize.dart';
import 'package:ml_preprocessing/src/standardizer/standardizer.dart';
import 'package:test/test.dart';

void main() {
  group('standardize', () {
    final dtype = DType.float32;

    test('should return a Standardizer factory method', () {
      final fittingData = DataFrame(<Iterable<num>>[
        [1, 2, 3],
      ], headerExists: false);

      final standardizerFactory = standardize();
      final standardizer = standardizerFactory(fittingData, dtype: dtype);

      expect(standardizer, isA<Standardizer>());
    });
  });
}
