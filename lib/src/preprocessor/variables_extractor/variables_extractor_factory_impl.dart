import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/variables_extractor/variables_extractor.dart';
import 'package:ml_preprocessing/src/preprocessor/variables_extractor/variables_extractor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/variables_extractor/variables_extractor_impl.dart';

class VariablesExtractorFactoryImpl implements VariablesExtractorFactory {
  const VariablesExtractorFactoryImpl();

  @override
  VariablesExtractor create(
          List<List<Object>> records,
          List<int> columnIndices,
          List<int> rowIndices,
          Map<int, CategoricalDataEncoder> encoders,
          int labelIdx,
          ToFloatNumberConverter valueConverter,
          DType dtype) =>
      VariablesExtractorImpl(records, columnIndices, rowIndices, encoders,
          labelIdx, valueConverter, dtype);
}