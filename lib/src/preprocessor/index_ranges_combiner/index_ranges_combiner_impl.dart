import 'package:ml_preprocessing/src/preprocessor/index_ranges_combiner/index_ranges_combiner.dart';
import 'package:xrange/zrange.dart';

class IndexRangesCombinerImpl implements IndexRangesCombiner {
  IndexRangesCombinerImpl();

  static const String emptyRangesMsg =
      'Columns/rows ranges list cannot be empty!';

  @override
  Iterable<int> combine(Iterable<ZRange> ranges) {
    if (ranges.isEmpty) {
      throw Exception(emptyRangesMsg);
    }
    final numOfIndices = ranges.fold<int>(0,
            (value, range) => value + range.length);
    final indices = List<int>(numOfIndices);
    var offset = 0;
    ranges.forEach((range) {
      final end = offset + range.length;
      indices.setRange(offset, end, range.values());
      offset = end;
    });
    return indices;
  }
}
