import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/to_float_number_converter/to_float_number_converter.dart';

class RecordsProcessorFactoryImpl implements RecordsProcessorFactory {
  const RecordsProcessorFactoryImpl();

  @override
  RecordsProcessor create(
          List<List<Object>> records,
          List<int> columnIndices,
          List<int> rowIndices,
          Map<int, CategoricalDataEncodingType> encoders,
          ToFloatNumberConverter valueConverter,
          DType dtype) =>
      RecordsProcessorImpl(records, columnIndices, rowIndices, encoders,
          valueConverter, dtype: dtype);
}
