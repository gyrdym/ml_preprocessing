import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec_factory.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/numerical_converter/numerical_converter.dart';
import 'package:ml_preprocessing/src/encoder/records_processor/records_processor.dart';

abstract class RecordsProcessorFactory {
  RecordsProcessor create(
      DataFrame data,
      Map<int, CategoricalDataEncodingType> encoders,
      NumericalConverter valueConverter,
      CategoricalDataCodecFactory codecFactory,
      DType dtype);
}
