import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory_impl.dart';
import 'package:test/test.dart';

void main() {
  group('OneHotCodec', () {
    final values = ['group A', 'group B', 'group C', 'group D', 'group A',
      'group B', 'group D'];
    final encoder = CategoricalDataCodecFactoryImpl()
        .fromType(CategoricalDataEncodingType.oneHot, values);

    test('should extract all unique categorical values and create a map with '
        '`<label> - <encoded>` key pairs', () {
      expect(encoder.originalToEncoded,
        equals({
          'group A': Vector.fromList([1, 0, 0, 0]),
          'group B': Vector.fromList([0, 1, 0, 0]),
          'group C': Vector.fromList([0, 0, 1, 0]),
          'group D': Vector.fromList([0, 0, 0, 1]),
        }),
      );
    });

    test('should encode categorical data', () {
      expect(encoder.encode(['group A', 'group C', 'group D',
        'group D', 'group A', 'group C', 'group B']),
          equals([
            [1, 0, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1],
            [0, 0, 0, 1],
            [1, 0, 0, 0],
            [0, 0, 1, 0],
            [0, 1, 0, 0],
          ]),
      );
    });

    test('should decode categorical data', () {
      expect(encoder.decode(Matrix.fromList([
        [0, 1, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1],
        [0, 0, 0, 1],
        [0, 0, 0, 1],
      ])), equals(['group B', 'group B', 'group D', 'group D', 'group D']));
    });

    test('should return empty list as encoded value collection if empty list '
        'passed to `encode` method', () {
      expect(encoder.encode([]), equals([]));
    });

    test('should throw an exception if one tries to decode nonexistent '
        'category value', () {
      expect(() => encoder.decode(Matrix.fromList([
        [0, 2, 0, 0],
      ])), throwsException);
    });
  });
}
