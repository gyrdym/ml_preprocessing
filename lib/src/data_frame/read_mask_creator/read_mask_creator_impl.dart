import 'package:ml_preprocessing/src/data_frame/read_mask_creator/read_mask_creator.dart';
import 'package:xrange/zrange.dart';

class DataFrameReadMaskCreatorImpl implements DataFrameReadMaskCreator {
  DataFrameReadMaskCreatorImpl();

  static const String emptyRangesMsg =
      'Columns/rows read ranges list cannot be empty!';

  @override
  Iterable<int> create(Iterable<ZRange> ranges) {
    if (ranges.isEmpty) {
      throw Exception(emptyRangesMsg);
    }
    final numOfIndices = ranges.fold<int>(0,
            (value, range) => value + range.length);
    final indices = List<int>(numOfIndices);
    var offset = 0;
    ranges.forEach((range) {
      final end = offset + range.length;
      indices.setRange(offset, offset + range.length, range.values());
      offset = end;
    });
    return indices;
  }
}
