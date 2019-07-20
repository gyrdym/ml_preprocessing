import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/variables_extractor/variables_extractor.dart';

abstract class RecordsProcessorFactory {
  RecordsProcessor create(
      List<List<Object>> records,
      List<int> columnIndices,
      List<int> rowIndices,
      Map<int, CategoricalDataEncodingType> encoders,
      ToFloatNumberConverter valueConverter,
      DType dtype);
}
