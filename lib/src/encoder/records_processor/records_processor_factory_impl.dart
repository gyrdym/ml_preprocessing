import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/numerical_converter/numerical_converter.dart';
import 'package:ml_preprocessing/src/encoder/records_processor/records_processor.dart';
import 'package:ml_preprocessing/src/encoder/records_processor/records_processor_factory.dart';
import 'package:ml_preprocessing/src/encoder/records_processor/records_processor_impl.dart';

class RecordsProcessorFactoryImpl implements RecordsProcessorFactory {
  const RecordsProcessorFactoryImpl();

  @override
  RecordsProcessor create(
          DataFrame records,
          Map<int, CategoricalDataEncodingType> columnToEncodingType,
          NumericalConverter valueConverter,
          CategoricalDataCodecFactory codecFactory,
          [DType dtype = DType.float32]) =>
    RecordsProcessorImpl(records, columnToEncodingType, valueConverter,
        codecFactory, dtype: dtype);
}
