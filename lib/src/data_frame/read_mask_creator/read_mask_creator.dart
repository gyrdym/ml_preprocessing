import 'package:xrange/zrange.dart';

abstract class DataFrameReadMaskCreator {
  Iterable<int> create(Iterable<ZRange> ranges);
}
