import 'package:ml_linalg/linalg.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

void main() {
  group('DataSet', () {
    final observations = Matrix.fromList(([
      [10, 20, 33, 0, 0, 0, 1, 10, 0, 0, 1],
      [22, 10, 39, 1, 0, 0, 0, 20, 0, 1, 0],
      [90, 26, 14, 0, 1, 0, 0, 65, 0, 0, 1],
    ]));

    final outcomeRange = ZRange.closed(8, 10);

    final rangeToEncoded = {
      ZRange.closed(3, 6): [
        Vector.fromList([0, 0, 0, 1]),
        Vector.fromList([0, 0, 1, 0]),
        Vector.fromList([0, 1, 0, 0]),
        Vector.fromList([1, 0, 0, 0]),
      ],
      outcomeRange: [
        Vector.fromList([0, 0, 1]),
        Vector.fromList([0, 1, 0]),
        Vector.fromList([1, 0, 0]),
      ]
    };

    final dataSet = DataSet(observations, outcomeColumnRange: outcomeRange,
        rangeToEncoded: rangeToEncoded);

    test('should store nominal feature ranges with their encoded values', () {
      expect(dataSet.rangeToEncoded, equals(rangeToEncoded));
    });

    test('should store outcome variable column range', () {
      expect(dataSet.outcomeColumnRange, equals(outcomeRange));
    });

    test('should generate ranges for all feature columns (for both numerical '
        'and nominal types of features)', () {
      final expectedFeatureRanges = [
        ZRange.singleton(0), ZRange.singleton(1), ZRange.singleton(2),
        ZRange.closed(3, 6), ZRange.singleton(7),
      ];
      expect(dataSet.featureRanges, equals(expectedFeatureRanges));
    });
  });
}
