import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_2d_almost_equal_to.dart';
import 'package:test/test.dart';

void main() {
  group('Standardizer', () {
    test('should extract deviation and mean values from fitting data and apply '
        'them to the same data in order to make the latter look like normally'
        'distributed data (with zero mean and unit variance)', () {
      final fittingData = DataFrame(<Iterable<num>>[
        [10, 21, 90, 20],
        [20, 66, 11, 30],
        [30, 55,  0, 70],
        [40, 33, 22, 20],
      ], headerExists: false);

      final standardizer = Standardizer(fittingData, dtype: DType.float32);
      final processed = standardizer.process(fittingData);

      expect(processed.toMatrix(DType.float32), iterable2dAlmostEqualTo([
        [-1.34164079, -1.28449611,  1.68894093, -0.72760688],
        [-0.4472136,   1.25626543, -0.56298031, -0.24253563],
        [ 0.4472136,   0.63519039, -0.87653896,  1.69774938],
        [ 1.34164079, -0.6069597,  -0.24942166, -0.72760688],
      ]));
    });

    test('should extract deviation and mean values from fitting data and apply '
        'them to the previously unseen data in order to make the latter look '
        'like normally distributed data (with zero mean and unit '
        'variance)', () {
      final fittingData = DataFrame(<Iterable<num>>[
        [10, 21, 90, 20],
        [20, 66, 11, 30],
        [30, 55,  0, 70],
        [40, 33, 22, 20],
      ], headerExists: false);

      final testData = DataFrame(<Iterable<num>>[
        [80,  20, 11, -100],
        [90, -40, 27,    0],
        [10,  44, 96,  120],
        [50, -99, 73,   10],
        [88, -20, 36,   66],
      ], headerExists: false);

      final standardizer = Standardizer(fittingData, dtype: DType.float32);
      final processed = standardizer.process(testData);

      expect(processed.toMatrix(DType.float32), iterable2dAlmostEqualTo([
        [ 4.91934955, -1.34095748, -0.56298031, -6.54846188],
        [ 5.81377674, -4.72863954, -0.106895,   -1.69774938],
        [-1.34164079,  0.01411534,  1.85997292,  4.12310563],
        [ 2.23606798, -8.05986023,  1.20435028, -1.21267813],
        [ 5.6348913,  -3.59941219,  0.14965299,  1.50372088],
      ]));
    });

    test('should throw an exception if one tries to create a standardizer '
        'using empty dataframe', () {
      final fittingData = DataFrame(<Iterable<num>>[[]], headerExists: false);

      expect(
        () => Standardizer(fittingData, dtype: DType.float32),
        throwsException,
      );
    });
  });
}
