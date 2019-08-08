import 'package:ml_preprocessing/src/encoder/one_hot_series_encoder.dart';
import 'package:test/test.dart';

void main() {
  group('OneHotEncoder', () {
    final values = ['group A', 'group B', 'group C', 'group D', 'group A',
      'group B', 'group D'];
    final encoder = OneHotEncoder();

    test('should encode categorical data', () {
      expect(encoder.encodeSeries(['group A', 'group C', 'group D',
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
