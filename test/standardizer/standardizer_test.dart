import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  const dtype = DType.float32;

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

      final standardizer = Standardizer(fittingData, dtype: dtype);
      final processed = standardizer.process(fittingData);

      expect(processed.toMatrix(dtype), iterable2dAlmostEqualTo([
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

      final standardizer = Standardizer(fittingData, dtype: dtype);
      final processed = standardizer.process(testData);

      expect(processed.toMatrix(dtype), iterable2dAlmostEqualTo([
        [ 4.91934955, -1.34095748, -0.56298031, -6.54846188],
        [ 5.81377674, -4.72863954, -0.106895,   -1.69774938],
        [-1.34164079,  0.01411534,  1.85997292,  4.12310563],
        [ 2.23606798, -8.05986023,  1.20435028, -1.21267813],
        [ 5.6348913,  -3.59941219,  0.14965299,  1.50372088],
      ]));
    });

    test('should extract deviation and mean values from fitting data and apply '
        'them to the previously unseen data twice or more', () {
      final fittingData = DataFrame(<Iterable<num>>[
        [10, 21, 90, 20],
        [20, 66, 11, 30],
        [30, 55,  0, 70],
        [40, 33, 22, 20],
      ], headerExists: false);

      final testData1 = DataFrame(<Iterable<num>>[
        [80,  20, 11, -100],
        [90, -40, 27,    0],
        [10,  44, 96,  120],
        [50, -99, 73,   10],
        [88, -20, 36,   66],
      ], headerExists: false);

      final testData2 = DataFrame(<Iterable<num>>[
        [1,  200, 33, 1000],
        [2, -440, 29,    0],
        [3,  414,  9,    0],
      ], headerExists: false);

      final standardizer = Standardizer(fittingData, dtype: dtype);

      final processed1 = standardizer.process(testData1);
      final processed2 = standardizer.process(testData2);

      expect(processed1.toMatrix(dtype), iterable2dAlmostEqualTo([
        [ 4.91934955, -1.34095748, -0.56298031, -6.54846188],
        [ 5.81377674, -4.72863954, -0.106895,   -1.69774938],
        [-1.34164079,  0.01411534,  1.85997292,  4.12310563],
        [ 2.23606798, -8.05986023,  1.20435028, -1.21267813],
        [ 5.6348913,  -3.59941219,  0.14965299,  1.50372088],
      ]));

      expect(processed2.toMatrix(dtype), iterable2dAlmostEqualTo([
        [ -2.14662526,  8.82208869,    0.064137,    46.80937563],
        [ -2.05718254, -27.31318658,  -0.04988433,  -1.69774938],
        [ -1.96773982,  20.90482136,  -0.61999097,  -1.69774938],
      ]));
    });

    test('should process a dataframe with only one column', () {
      final fittingData = DataFrame(<Iterable<num>>[
        [10],
        [20],
        [30],
        [40],
      ], headerExists: false);

      final testData = DataFrame(<Iterable<num>>[
        [80],
        [90],
        [10],
        [50],
        [88],
      ], headerExists: false);

      final standardizer = Standardizer(fittingData, dtype: dtype);
      final processed = standardizer.process(testData);

      expect(processed.toMatrix(dtype), iterable2dAlmostEqualTo([
        [ 4.91934955],
        [ 5.81377674],
        [-1.34164079],
        [ 2.23606798],
        [ 5.6348913 ],
      ]));
    });

    test('should process a dataframe with only one row', () {
      final fittingData = DataFrame(<Iterable<num>>[
        [10, 21, 90, 20],
      ], headerExists: false);

      final testData = DataFrame(<Iterable<num>>[
        [80,  20, 11, -100],
        [90, -40, 27,    0],
        [10,  44, 96,  120],
        [50, -99, 73,   10],
        [88, -20, 36,   66],
      ], headerExists: false);

      final standardizer = Standardizer(fittingData, dtype: dtype);
      final processed = standardizer.process(testData);

      expect(processed.toMatrix(dtype), equals([
        [70, -1,   -79, -120],
        [80, -61,  -63, -20 ],
        [ 0,  23,   6,   100],
        [40, -120, -17, -10 ],
        [78, -41,  -54,  46 ],
      ]));
    });

    test('should make deviation of uniform columns equal to 1', () {
      final uniformColumn = Matrix.fromList([
        [10],
        [10],
        [10],
        [10],
      ]);

      final otherColumns = Matrix.fromList([
        [21, 90, 20],
        [66, 11, 30],
        [55,  0, 70],
        [33, 22, 20],
      ]);

      final fittingData = DataFrame.fromMatrix(
        Matrix.fromColumns([
          ...uniformColumn.columns,
          ...otherColumns.columns,
        ], dtype: dtype),
      );

      final testData = DataFrame(<Iterable<num>>[
        [80,  20, 11, -100],
        [90, -40, 27,    0],
        [10,  44, 96,  120],
        [50, -99, 73,   10],
        [88, -20, 36,   66],
      ], headerExists: false);

      final standardizer = Standardizer(fittingData, dtype: dtype);
      final processed = standardizer.process(testData);

      expect(processed.toMatrix(dtype), iterable2dAlmostEqualTo([
        [ 70, -1.34095748, -0.56298031, -6.54846188],
        [ 80, -4.72863954, -0.106895,   -1.69774938],
        [  0,  0.01411534,  1.85997292,  4.12310563],
        [ 40, -8.05986023,  1.20435028, -1.21267813],
        [ 78, -3.59941219,  0.14965299,  1.50372088],
      ]));
    });

    test('should throw an exception if one tries to apply standardizer to a '
        'dataframe of inappropriate dimension (columns number in the test '
        'dataframe should be equal to a number of columns in the fitting '
        'dataframe)', () {
      final fittingData = DataFrame(<Iterable<num>>[
        [10, 21, 90, 20],
        [20, 66, 11, 30],
        [30, 55,  0, 70],
        [40, 33, 22, 20],
      ], headerExists: false);

      final testData = DataFrame(<Iterable<num>>[
        [80,  20, 11],
        [90, -40, 27],
        [10,  44, 96],
        [50, -99, 73],
        [88, -20, 36],
      ], headerExists: false);

      final standardizer = Standardizer(fittingData, dtype: dtype);

      expect(() => standardizer.process(testData), throwsException);
    });

    test('should throw an exception if one tries to create a standardizer '
        'using empty dataframe', () {
      final fittingData = DataFrame(<Iterable<num>>[[]], headerExists: false);

      expect(
        () => Standardizer(fittingData, dtype: dtype),
        throwsException,
      );
    });
  });
}
