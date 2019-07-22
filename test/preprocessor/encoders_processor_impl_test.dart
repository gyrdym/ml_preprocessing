import 'package:ml_preprocessing/src/categorical_data_codec/codec.dart';
import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  final header = ['country', 'gender', 'age', 'marital_status', 'salary'];

  group('EncodersProcessorImpl', () {
    test('should return empty map if there are no specific encoders provided '
        'and the columns header is not empty', () {
      final encoderFactory = createCategoricalDataCodecFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final encoders = encoderProcessor.getIndexToEncodingTypeMapping({}, {}, {});
      expect(encoders, equals(<int, CategoricalDataCodec>{}));
    });

    test('should create encoders from `name-to-encoder` map and header is not '
        'empty', () {
      final encoderFactory = createCategoricalDataCodecFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final nameToEncoder = <String, CategoricalDataEncodingType>{
        'gender': CategoricalDataEncodingType.oneHot,
        'marital_status': CategoricalDataEncodingType.oneHot,
        'age': CategoricalDataEncodingType.ordinal,
        'country': CategoricalDataEncodingType.ordinal,
      };

      when(encoderFactory.fromType(CategoricalDataEncodingType.ordinal, any))
          .thenReturn(ordinalEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncodingType.oneHot, any))
          .thenReturn(oneHotEncoderMock);

      final encoders = encoderProcessor.getIndexToEncodingTypeMapping({}, {}, nameToEncoder);

      expect(encoders, equals({
        0: ordinalEncoderMock,
        1: oneHotEncoderMock,
        2: ordinalEncoderMock,
        3: oneHotEncoderMock,
      }));
    });

    test('should create encoders from `index-to-encoder` map if '
        'index-to-encoder, encoder-to-name and name-to-encoder are provided '
        '(`index-to-encoder` map has high priority)', () {
      final encoderFactory = createCategoricalDataCodecFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final indexToEncoder = <int, CategoricalDataEncodingType>{
        0: CategoricalDataEncodingType.ordinal,
        1: CategoricalDataEncodingType.ordinal,
        2: CategoricalDataEncodingType.oneHot,
        3: CategoricalDataEncodingType.oneHot,
      };

      final encoderToName = <CategoricalDataEncodingType, Iterable<String>>{
        CategoricalDataEncodingType.oneHot: ['country', 'gender', 'age'],
      };

      final nameToEncoder = <String, CategoricalDataEncodingType>{
        'country': CategoricalDataEncodingType.oneHot,
        'gender': CategoricalDataEncodingType.oneHot,
        'age': CategoricalDataEncodingType.ordinal,
        'marital_status': CategoricalDataEncodingType.ordinal,
      };

      when(encoderFactory.fromType(CategoricalDataEncodingType.ordinal, any))
          .thenReturn(ordinalEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncodingType.oneHot, any))
          .thenReturn(oneHotEncoderMock);

      final encoders = encoderProcessor.getIndexToEncodingTypeMapping(indexToEncoder,
          encoderToName, nameToEncoder);

      expect(encoders, equals({
        0: ordinalEncoderMock,
        1: ordinalEncoderMock,
        2: oneHotEncoderMock,
        3: oneHotEncoderMock,
      }));
    });

    test('should create encoders from `encoder-to-name` map if '
        'encoder-to-name and name-to-encoder are provided '
        '(`encoder-to-name` map has higher priority)', () {
      final encoderFactory = createCategoricalDataCodecFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();

      final indexToEncoder = <int, CategoricalDataEncodingType>{};

      final encoderToName = <CategoricalDataEncodingType, Iterable<String>>{
        CategoricalDataEncodingType.oneHot: ['country', 'gender',
          'marital_status'],
      };

      final nameToEncoder = <String, CategoricalDataEncodingType>{
        'country': CategoricalDataEncodingType.oneHot,
        'gender': CategoricalDataEncodingType.oneHot,
        'age': CategoricalDataEncodingType.ordinal,
        'marital_status': CategoricalDataEncodingType.ordinal,
      };

      when(encoderFactory.fromType(CategoricalDataEncodingType.oneHot, any))
          .thenReturn(oneHotEncoderMock);

      final encoders = encoderProcessor.getIndexToEncodingTypeMapping(indexToEncoder,
          encoderToName, nameToEncoder);

      verifyNever(encoderFactory.fromType(CategoricalDataEncodingType.ordinal,
          any));
      expect(encoders, equals({
        0: oneHotEncoderMock,
        1: oneHotEncoderMock,
        3: oneHotEncoderMock,
      }));
    });

    test('should properly process encoder-to-name map', () {
      final encoderFactory = createCategoricalDataCodecFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final encoderToName = <CategoricalDataEncodingType, Iterable<String>>{
        CategoricalDataEncodingType.oneHot: ['country', 'gender'],
        CategoricalDataEncodingType.ordinal: ['age'],
      };

      final indexToEncoder = <int, CategoricalDataEncodingType>{};
      final nameToEncoder = <String, CategoricalDataEncodingType>{};

      when(encoderFactory.fromType(CategoricalDataEncodingType.oneHot, any))
          .thenReturn(oneHotEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncodingType.ordinal, any))
          .thenReturn(ordinalEncoderMock);

      final actual = encoderProcessor.getIndexToEncodingTypeMapping(indexToEncoder,
          encoderToName, nameToEncoder);

      expect(actual, equals({
        0: oneHotEncoderMock,
        1: oneHotEncoderMock,
        2: ordinalEncoderMock,
      }));
    });

    test('should throw an exception if one column is going to be processed by '
        'two different encoders', () {
      final encoderFactory = createCategoricalDataCodecFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final indexToEncoder = <int, CategoricalDataEncodingType>{};

      final encoderToName = <CategoricalDataEncodingType, Iterable<String>>{
        CategoricalDataEncodingType.oneHot: ['country', 'gender'],
        CategoricalDataEncodingType.ordinal: ['gender'],
      };

      final nameToEncoder = <String, CategoricalDataEncodingType>{};

      when(encoderFactory.fromType(CategoricalDataEncodingType.oneHot, any))
          .thenReturn(oneHotEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncodingType.ordinal, any))
          .thenReturn(ordinalEncoderMock);

      final actual = () => encoderProcessor.getIndexToEncodingTypeMapping(indexToEncoder,
          encoderToName, nameToEncoder);

      expect(actual, throwsException);
    });

    test('should throw an error if unexistent column to be processed', () {
      final encoderFactory = createCategoricalDataCodecFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final nameToEncoder = <String, CategoricalDataEncodingType>{
        'country': CategoricalDataEncodingType.oneHot,
        'gender': CategoricalDataEncodingType.oneHot,
        'age': CategoricalDataEncodingType.ordinal,
        'city': CategoricalDataEncodingType.ordinal,
      };

      when(encoderFactory.fromType(CategoricalDataEncodingType.ordinal, any))
          .thenReturn(ordinalEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncodingType.oneHot, any))
          .thenReturn(oneHotEncoderMock);

      expect(
        () => encoderProcessor.getIndexToEncodingTypeMapping({}, {}, nameToEncoder),
        throwsException
      );
    });

    test('should return an empty map if no encoders provided', () {
      final encoderFactory = createCategoricalDataCodecFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);

      expect(encoderProcessor.getIndexToEncodingTypeMapping(null, null, null), equals({}));
    });
  });
}
