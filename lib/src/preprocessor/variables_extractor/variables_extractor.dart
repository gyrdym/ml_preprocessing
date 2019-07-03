import 'package:ml_linalg/matrix.dart';
import 'package:xrange/zrange.dart';

abstract class VariablesExtractor {
  Matrix get features;
  Matrix get labels;
  Set<ZRange> get encodedColumnRanges;
}
