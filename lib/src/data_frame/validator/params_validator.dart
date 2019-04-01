import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:xrange/zrange.dart';

abstract class DataFrameParamsValidator {
  String validate({
    int labelIdx,
    String labelName,
    Iterable<ZRange> rows,
    Iterable<ZRange> columns,
    bool headerExists,
    Map<String, CategoricalDataEncoderType> namesToEncoders,
    Map<int, CategoricalDataEncoderType> indexToEncoder,
  });
}
