import 'package:logging/logging.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/ml_data/encoders_processor/encoders_processor.dart';

abstract class MLDataEncodersProcessorFactory {
  MLDataEncodersProcessor create(List<List<Object>> data, List<String> header,
      CategoricalDataEncoderFactory encoderFactory, CategoricalDataEncoderType fallbackEncoderType, Logger logger);
}
