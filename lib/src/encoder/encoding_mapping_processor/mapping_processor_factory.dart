import 'package:ml_preprocessing/src/encoder/encoding_mapping_processor/mapping_processor.dart';

abstract class EncodingMappingProcessorFactory {
  EncodingMappingProcessor create(List<String> header);
}
