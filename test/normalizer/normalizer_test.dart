import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_preprocessing/src/normalizer/normalizer.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  group('Normalizer', () {
    test('should divide each row-vector by its euclidean norm and preserve '
        'the header of the input dataframe', () {
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
        [0.267, 0.534, 0.801],
        [0.455, 0.569, 0.683],
        [0.646, 0.574, 0.502],
        [0.608, 0.576, 0.544],
      ], 1e-3));
    });

    test('should divide each row-vector by its manhattan norm and preserve '
        'the header of the input dataframe', () {
      final header = ['first', 'second', 'third'];
      final data = Matrix.fromList([
        [10,  20,  30 ],
        [40,  50,  60 ],
        [90,  80,  70 ],
        [190, 180, 170],
      ]);
      final input = DataFrame.fromMatrix(data, header: header);
      final normalizer = Normalizer(Norm.manhattan);
      final transformed = normalizer.process(input);

      expect(transformed.header, equals(header));
      expect(transformed.toMatrix(), iterable2dAlmostEqualTo([
        [0.166, 0.333, 0.500],
        [0.266, 0.333, 0.400],
        [0.375, 0.333, 0.291],
        [0.351, 0.333, 0.314],
      ], 1e-3));
    });
  });
}
