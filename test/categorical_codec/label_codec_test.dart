import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec_factory_impl.dart';
import 'package:test/test.dart';

void main() {
  group('OrdinalCodec', () {
    final values = ['group C', 'group D', 'group A', 'group B', 'group C',
      'group A', 'group D'];

    final encoder = CategoricalDataCodecFactoryImpl()
        .fromType(CategoricalDataEncodingType.label, values);

    test('should extract all unique categorical values and create a map with '
        '`<label> - <encoded>` key pairs', () {
      expect(encoder.encode(['group D', 'group A', 'group C', 'group D',
        'group B']),
        equals([
          [1],
          [2],
          [0],
          [1],
          [3],
        ]),
      );
    });

    test('should decode categorical data', () {
      expect(encoder.decode(Matrix.fromList([
        [2.0],
        [3.0],
        [3.0],
      ])), equals(['group A', 'group B', 'group B']));
    });

    test('should return empty list as encoded value collection if empty list '
        'passed to `encode` method', () {
      expect(encoder.encode([]), equals([]));
    });

    test('should throw an exception if one tries to decode nonexistent '
        'category value', () {
      expect(() => encoder.decode(Matrix.fromList([
        [25.0],
      ])), throwsException);
    });
  });
}
