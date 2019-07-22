import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor.dart';

abstract class EncodersProcessorFactory {
  EncodersProcessor create(List<String> header);
}
