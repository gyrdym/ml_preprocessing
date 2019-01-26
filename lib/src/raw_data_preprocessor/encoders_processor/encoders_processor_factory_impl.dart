import 'package:logging/logging.dart';
import 'package:ml_preprocessing/src/categorical_data_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/categorical_data_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/raw_data_preprocessor/encoders_processor/encoders_processor.dart';
import 'package:ml_preprocessing/src/raw_data_preprocessor/encoders_processor/encoders_processor_factory.dart';
import 'package:ml_preprocessing/src/raw_data_preprocessor/encoders_processor/encoders_processor_impl.dart';

class MLDataEncodersProcessorFactoryImpl implements MLDataEncodersProcessorFactory {
  const MLDataEncodersProcessorFactoryImpl();

  @override
  MLDataEncodersProcessor create(List<List<Object>> records, List<String> header,
      CategoricalDataEncoderFactory encoderFactory, CategoricalDataEncoderType fallbackEncoderType, Logger logger) =>
      MLDataEncodersProcessorImpl(records, header, encoderFactory, fallbackEncoderType, logger);
}
