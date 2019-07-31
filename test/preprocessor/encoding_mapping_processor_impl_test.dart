import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoder.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/encoding_mapping_processor/mapping_processor_impl.dart';
import 'package:test/test.dart';

void main() {
  final header = ['country', 'gender', 'age', 'marital_status', 'salary'];

  group('EncodingMappingProcessorImpl', () {
    test('should return empty map if there are no encoding types provided '
        'and the columns header is not empty', () {
      final encoderProcessor = EncodingMappingProcessorImpl(header);
      final encoders = encoderProcessor.getIndexToEncodingTypeMapping({}, {}, {});
      expect(encoders, equals(<int, CategoricalDataEncoder>{}));
    });

    test('should create correct mapping from `name-to-encoder` map if header '
        'is not empty', () {
      final encoderProcessor = EncodingMappingProcessorImpl(header);

      final nameToEncoder = <String, CategoricalDataEncodingType>{
        'gender': CategoricalDataEncodingType.oneHot,
        'marital_status': CategoricalDataEncodingType.oneHot,
        'age': CategoricalDataEncodingType.label,
        'country': CategoricalDataEncodingType.label,
      };

      final encoders = encoderProcessor
          .getIndexToEncodingTypeMapping({}, {}, nameToEncoder);

      expect(encoders, equals({
        0: CategoricalDataEncodingType.label,
        1: CategoricalDataEncodingType.oneHot,
        2: CategoricalDataEncodingType.label,
        3: CategoricalDataEncodingType.oneHot,
      }));
    });

    test('should create correct mapping from `index-to-encoder` map if '
        'index-to-encoder, encoder-to-name and name-to-encoder are provided '
        '(`index-to-encoder` map has highest priority)', () {
      final encoderProcessor = EncodingMappingProcessorImpl(header);

      final indexToEncoder = <int, CategoricalDataEncodingType>{
        0: CategoricalDataEncodingType.label,
        1: CategoricalDataEncodingType.label,
        2: CategoricalDataEncodingType.oneHot,
        3: CategoricalDataEncodingType.oneHot,
      };

      final encoderToName = <CategoricalDataEncodingType, Iterable<String>>{
        CategoricalDataEncodingType.oneHot: ['country', 'gender', 'age'],
      };

      final nameToEncoder = <String, CategoricalDataEncodingType>{
        'country': CategoricalDataEncodingType.oneHot,
        'gender': CategoricalDataEncodingType.oneHot,
        'age': CategoricalDataEncodingType.label,
        'marital_status': CategoricalDataEncodingType.label,
      };

      final encoders = encoderProcessor.getIndexToEncodingTypeMapping(indexToEncoder,
          encoderToName, nameToEncoder);

      expect(encoders, equals({
        0: CategoricalDataEncodingType.label,
        1: CategoricalDataEncodingType.label,
        2: CategoricalDataEncodingType.oneHot,
        3: CategoricalDataEncodingType.oneHot,
      }));
    });

    test('should create correct mapping from `encoder-to-name` map if '
        'encoder-to-name and name-to-encoder are provided '
        '(`encoder-to-name` map has higher priority)', () {
      final encoderProcessor = EncodingMappingProcessorImpl(header);
      final indexToEncoder = <int, CategoricalDataEncodingType>{};
      final encoderToName = <CategoricalDataEncodingType, Iterable<String>>{
        CategoricalDataEncodingType.oneHot: ['country', 'gender',
          'marital_status'],
      };

      final nameToEncoder = <String, CategoricalDataEncodingType>{
        'country': CategoricalDataEncodingType.oneHot,
        'gender': CategoricalDataEncodingType.oneHot,
        'age': CategoricalDataEncodingType.label,
        'marital_status': CategoricalDataEncodingType.label,
      };

      final encoders = encoderProcessor.getIndexToEncodingTypeMapping(indexToEncoder,
          encoderToName, nameToEncoder);

      expect(encoders, equals({
        0: CategoricalDataEncodingType.oneHot,
        1: CategoricalDataEncodingType.oneHot,
        3: CategoricalDataEncodingType.oneHot,
      }));
    });

    test('should properly process encoder-to-name map', () {
      final encoderProcessor = EncodingMappingProcessorImpl(header);

      final encoderToName = <CategoricalDataEncodingType, Iterable<String>>{
        CategoricalDataEncodingType.oneHot: ['country', 'gender'],
        CategoricalDataEncodingType.label: ['age'],
      };

      final indexToEncoder = <int, CategoricalDataEncodingType>{};
      final nameToEncoder = <String, CategoricalDataEncodingType>{};

      final actual = encoderProcessor.getIndexToEncodingTypeMapping(indexToEncoder,
          encoderToName, nameToEncoder);

      expect(actual, equals({
        0: CategoricalDataEncodingType.oneHot,
        1: CategoricalDataEncodingType.oneHot,
        2: CategoricalDataEncodingType.label,
      }));
    });

    test('should throw an exception if one column is going to be processed by '
        'two different encoders', () {
      final encoderProcessor = EncodingMappingProcessorImpl(header);
      final indexToEncoder = <int, CategoricalDataEncodingType>{};

      final encoderToName = <CategoricalDataEncodingType, Iterable<String>>{
        CategoricalDataEncodingType.oneHot: ['country', 'gender'],
        CategoricalDataEncodingType.label: ['gender'],
      };

      final nameToEncoder = <String, CategoricalDataEncodingType>{};

      final actual = () => encoderProcessor.getIndexToEncodingTypeMapping(
          indexToEncoder, encoderToName, nameToEncoder);

      expect(actual, throwsException);
    });

    test('should throw an error if unexistent column to be processed', () {
      final encoderProcessor = EncodingMappingProcessorImpl(header);

      final nameToEncoder = <String, CategoricalDataEncodingType>{
        'country': CategoricalDataEncodingType.oneHot,
        'gender': CategoricalDataEncodingType.oneHot,
        'age': CategoricalDataEncodingType.label,
        'city': CategoricalDataEncodingType.label,
      };

      expect(
        () => encoderProcessor
            .getIndexToEncodingTypeMapping({}, {}, nameToEncoder),
        throwsException
      );
    });

    test('should return an empty map if no encoders provided', () {
      final encoderProcessor = EncodingMappingProcessorImpl(header);

      expect(encoderProcessor.getIndexToEncodingTypeMapping(null, null, null),
          equals({}));
    });
  });
}
