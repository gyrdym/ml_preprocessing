import 'package:ml_preprocessing/src/preprocessor/encoding_mapping_processor/mapping_processor.dart';

abstract class EncodingMappingProcessorFactory {
  EncodingMappingProcessor create(List<String> header);
}
