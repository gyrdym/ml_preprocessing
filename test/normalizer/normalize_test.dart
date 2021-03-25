import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/normalizer/normalize.dart';
import 'package:ml_preprocessing/src/normalizer/normalizer.dart';
import 'package:test/test.dart';

void main() {
  group('normalize', () {
    test('should return normalizer factory', () {
      final normalizerFactory = normalize();
      final normalizer = normalizerFactory(DataFrame([]));

      expect(normalizer, isA<Normalizer>());
    });
  });
}
