import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/data_frame/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/data_frame/variables_extractor/variables_extractor.dart';

abstract class VariablesExtractorFactory {
  VariablesExtractor create(
      List<List<Object>> records,
      List<int> columnIndices,
      List<int> rowIndices,
      Map<int, CategoricalDataEncoder> encoders,
      int labelIdx,
      ToFloatNumberConverter valueConverter,
      Type dtype);
}
