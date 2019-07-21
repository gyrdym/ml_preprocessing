import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:xrange/zrange.dart';

abstract class RecordsProcessor {
  Matrix encodeRecords();
  Map<ZRange, CategoricalDataCodec> get rangeToCodec;
}