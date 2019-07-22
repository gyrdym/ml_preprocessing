import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:xrange/zrange.dart';

abstract class PreprocessorArgumentsValidator {
  String validate({
    int labelIdx,
    String labelName,
    Iterable<ZRange> rows,
    Iterable<ZRange> columns,
    bool headerExists,
    Map<String, CategoricalDataEncodingType> namesToEncoders,
    Map<int, CategoricalDataEncodingType> indexToEncoder,
  });
}
