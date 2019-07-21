import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_impl.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  group('VariablesExtractorFactoryImpl', () {
    test('should create a proper variable extractor instance', () {
      final factory = const RecordsProcessorFactoryImpl();
      final extractor = factory.create([[1, 2, 3]], [], [], {}, 0,
          ToFloatNumberConverterMock(), DType.float32);
      expect(extractor.runtimeType, RecordsProcessorImpl);
    });
  });
}
