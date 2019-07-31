import 'package:ml_linalg/matrix.dart';
import 'package:ml_linalg/vector.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoder_factory_impl.dart';
import 'package:test/test.dart';

void main() {
  group('OneHotCodec', () {
    final values = ['group A', 'group B', 'group C', 'group D', 'group A',
      'group B', 'group D'];
    final encoder = CategoricalDataEncoderFactoryImpl()
        .fromType(CategoricalDataEncodingType.oneHot, values);

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

    test('should return empty list as encoded values if empty list passed to '
        '`encode` method', () {
      expect(encoder.encode([]), equals([]));
    });
  });
}
