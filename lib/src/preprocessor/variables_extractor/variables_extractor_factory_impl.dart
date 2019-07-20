import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';
import 'package:ml_preprocessing/src/preprocessor/variables_extractor/variables_extractor.dart';
import 'package:ml_preprocessing/src/preprocessor/variables_extractor/variables_extractor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/variables_extractor/variables_extractor_impl.dart';

class RecordsProcessorFactoryImpl implements RecordsProcessorFactory {
  const RecordsProcessorFactoryImpl();

  @override
  RecordsProcessor create(
          List<List<Object>> records,
          List<int> columnIndices,
          List<int> rowIndices,
          Map<int, CategoricalDataEncoderType> encoders,
          ToFloatNumberConverter valueConverter,
          DType dtype) =>
      RecordsProcessorImpl(records, columnIndices, rowIndices, encoders,
          valueConverter, dtype: dtype);
}
