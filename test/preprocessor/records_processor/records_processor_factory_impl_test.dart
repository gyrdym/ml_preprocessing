import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_factory_impl.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_impl.dart';
import 'package:test/test.dart';

import '../../mocks.dart';

void main() {
  group('RecordsProcessorFactoryImpl', () {
    final factory = const RecordsProcessorFactoryImpl();

    test('should create a proper variable extractor instance', () {
      final records = [[1, 2, 3]];
      final columnIndices = <int>[];
      final rowIndices = <int>[];
      final columnToEncodingType = <int, CategoricalDataEncodingType>{};
      final extractor = factory.create(
          records,
          columnIndices,
          rowIndices,
          columnToEncodingType,
          ToFloatNumberConverterMock(),
          CategoricalDataCodecFactoryMock(),
          DType.float32);

      expect(extractor, isA<RecordsProcessorImpl>());
    });
  });
}
