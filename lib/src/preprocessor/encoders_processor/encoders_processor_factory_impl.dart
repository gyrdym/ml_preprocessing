import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor.dart';
import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor_factory.dart';
import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor_impl.dart';

class EncodersProcessorFactoryImpl implements EncodersProcessorFactory {
  const EncodersProcessorFactoryImpl();

  @override
  EncodersProcessor create(List<String> header) =>
      EncodersProcessorImpl(header);
}
