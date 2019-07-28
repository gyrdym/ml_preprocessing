import 'package:ml_preprocessing/src/encoder/encoding_mapping_processor/mapping_processor.dart';
import 'package:ml_preprocessing/src/encoder/encoding_mapping_processor/mapping_processor_factory.dart';
import 'package:ml_preprocessing/src/encoder/encoding_mapping_processor/mapping_processor_impl.dart';

class EncodingMappingProcessorFactoryImpl implements
    EncodingMappingProcessorFactory {
  const EncodingMappingProcessorFactoryImpl();

  @override
  EncodingMappingProcessor create(List<String> header) =>
      EncodingMappingProcessorImpl(header);
}
