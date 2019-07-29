import 'package:ml_preprocessing/src/dataframe/dataframe.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec.dart';
import 'package:xrange/zrange.dart';

abstract class RecordsProcessor {
  DataFrame convertAndEncodeRecords();
  Map<ZRange, CategoricalDataCodec> get columnRangeToCodec;
}
