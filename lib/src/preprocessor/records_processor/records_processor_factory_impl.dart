import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/numerical_converter/numerical_converter.dart';

class RecordsProcessorFactoryImpl implements RecordsProcessorFactory {
  const RecordsProcessorFactoryImpl();

  @override
  RecordsProcessor create(
          List<List<Object>> records,
          List<int> columnIndices,
          List<int> rowIndices,
          Map<int, CategoricalDataEncodingType> columnToEncodingType,
          NumericalConverter valueConverter,
          CategoricalDataCodecFactory codecFactory,
          [DType dtype = DType.float32]) =>
    RecordsProcessorImpl(records, columnIndices, rowIndices,
        columnToEncodingType, valueConverter, codecFactory, dtype: dtype);
}
