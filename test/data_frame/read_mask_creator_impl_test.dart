import 'package:ml_preprocessing/src/data_frame/index_ranges_combiner/index_ranges_combiner_impl.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

void main() {
  final creator = IndexRangesCombinerImpl();

  group('MLDataReadMaskCreatorImpl', () {
    test('should generate indices to read, case 1', () {
      final mask = creator.combine([ZRange.closed(0, 7)]);
      expect(mask, equals([0, 1, 2, 3, 4, 5, 6, 7]));
    });

    test('should generate indices to read, case 2', () {
      final mask = creator.combine([ZRange.closed(0, 6)]);
      expect(mask, equals([0, 1, 2, 3, 4, 5, 6]));
    });

    test('should generate indices to read, case 3', () {
      final mask = creator.combine([ZRange.closed(0, 0)]);
      expect(mask, equals([0]));
    });

    test('should generate indices to read, case 4', () {
      expect(() => creator.combine([]), throwsException);
    });

    test('should generate indices to read, case 5', () {
      final mask = creator
          .combine([ZRange.closed(0, 0), ZRange.closed(0, 0)]);
      expect(mask, equals([0, 0]));
    });

    test('should generate indices to read, case 5', () {
      final mask = creator
          .combine([ZRange.closed(0, 0), ZRange.closed(3, 4)]);
      expect(mask, equals([0, 3, 4]));
    });
  });
}
