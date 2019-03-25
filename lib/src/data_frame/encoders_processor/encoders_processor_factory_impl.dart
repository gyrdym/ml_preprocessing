import 'package:ml_preprocessing/src/categorical_encoder/encoder_factory.dart';
import 'package:ml_preprocessing/src/data_frame/encoders_processor/encoders_processor.dart';
import 'package:ml_preprocessing/src/data_frame/encoders_processor/encoders_processor_factory.dart';
import 'package:ml_preprocessing/src/data_frame/encoders_processor/encoders_processor_impl.dart';

class EncodersProcessorFactoryImpl implements EncodersProcessorFactory {
  const EncodersProcessorFactoryImpl();

  @override
  EncodersProcessor create(
      List<String> header,
      CategoricalDataEncoderFactory encoderFactory,
      [Type dtype]
  ) => EncodersProcessorImpl(header, encoderFactory, dtype);
}
