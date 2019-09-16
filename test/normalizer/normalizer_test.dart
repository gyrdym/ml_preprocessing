import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_preprocessing/src/normalizer/normalizer.dart';
import 'package:ml_tech/unit_testing/matchers/iterable_2d_almost_equal_to.dart';
import 'package:test/test.dart';

void main() {
  group('Normalizer', () {
    test('should divide each row-vector by its norm and preserve the header of '
        'the input dataframe', () {
      final header = ['first', 'second', 'third'];
      final data = Matrix.fromList([
        [10,  20,  30 ],
        [40,  50,  60 ],
        [90,  80,  70 ],
        [190, 180, 170],
      ]);
      final input = DataFrame.fromMatrix(data, header: header);
      final normalizer = Normalizer();
      final transformed = normalizer.process(input);

      expect(transformed.header, equals(header));
      expect(transformed.toMatrix(), iterable2dAlmostEqualTo([
        [0.26, 0.53, 0.80],
        [0.45, 0.56, 0.68],
        [0.64, 0.57, 0.50],
        [0.60, 0.57, 0.54],
      ], 1e-2));
    });
  });
}
