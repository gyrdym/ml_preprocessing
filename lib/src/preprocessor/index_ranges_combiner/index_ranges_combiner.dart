import 'package:xrange/zrange.dart';

abstract class IndexRangesCombiner {
  Iterable<int> combine(Iterable<ZRange> ranges);
}
