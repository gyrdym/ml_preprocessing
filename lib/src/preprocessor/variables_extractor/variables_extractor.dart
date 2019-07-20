import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:xrange/zrange.dart';

abstract class RecordsProcessor {
  Matrix extractRecords();
  Map<ZRange, CategoricalDataCodec> get rangeToEncoder;
}
