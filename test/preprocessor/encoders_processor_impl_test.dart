import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/preprocessor/encoders_processor/encoders_processor_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  final header = ['country', 'gender', 'age', 'marital_status', 'salary'];

  group('EncodersProcessorImpl', () {
    test('should return empty map if there are no specific encoders provided '
        'and the columns header is not empty', () {
      final encoderFactory = createCategoricalDataEncoderFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final encoders = encoderProcessor.createEncoders({}, {}, {});
      expect(encoders, equals(<int, CategoricalDataEncoder>{}));
    });

    test('should create encoders from `name-to-encoder` map and header is not '
        'empty', () {
      final encoderFactory = createCategoricalDataEncoderFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final nameToEncoder = <String, CategoricalDataEncoderType>{
        'gender': CategoricalDataEncoderType.oneHot,
        'marital_status': CategoricalDataEncoderType.oneHot,
        'age': CategoricalDataEncoderType.ordinal,
        'country': CategoricalDataEncoderType.ordinal,
      };

      when(encoderFactory.fromType(CategoricalDataEncoderType.ordinal, any))
          .thenReturn(ordinalEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncoderType.oneHot, any))
          .thenReturn(oneHotEncoderMock);

      final encoders = encoderProcessor.createEncoders({}, {}, nameToEncoder);

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
      final encoderFactory = createCategoricalDataEncoderFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final indexToEncoder = <int, CategoricalDataEncoderType>{
        0: CategoricalDataEncoderType.ordinal,
        1: CategoricalDataEncoderType.ordinal,
        2: CategoricalDataEncoderType.oneHot,
        3: CategoricalDataEncoderType.oneHot,
      };

      final encoderToName = <CategoricalDataEncoderType, Iterable<String>>{
        CategoricalDataEncoderType.oneHot: ['country', 'gender', 'age'],
      };

      final nameToEncoder = <String, CategoricalDataEncoderType>{
        'country': CategoricalDataEncoderType.oneHot,
        'gender': CategoricalDataEncoderType.oneHot,
        'age': CategoricalDataEncoderType.ordinal,
        'marital_status': CategoricalDataEncoderType.ordinal,
      };

      when(encoderFactory.fromType(CategoricalDataEncoderType.ordinal, any))
          .thenReturn(ordinalEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncoderType.oneHot, any))
          .thenReturn(oneHotEncoderMock);

      final encoders = encoderProcessor.createEncoders(indexToEncoder,
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
      final encoderFactory = createCategoricalDataEncoderFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();

      final indexToEncoder = <int, CategoricalDataEncoderType>{};

      final encoderToName = <CategoricalDataEncoderType, Iterable<String>>{
        CategoricalDataEncoderType.oneHot: ['country', 'gender',
          'marital_status'],
      };

      final nameToEncoder = <String, CategoricalDataEncoderType>{
        'country': CategoricalDataEncoderType.oneHot,
        'gender': CategoricalDataEncoderType.oneHot,
        'age': CategoricalDataEncoderType.ordinal,
        'marital_status': CategoricalDataEncoderType.ordinal,
      };

      when(encoderFactory.fromType(CategoricalDataEncoderType.oneHot, any))
          .thenReturn(oneHotEncoderMock);

      final encoders = encoderProcessor.createEncoders(indexToEncoder,
          encoderToName, nameToEncoder);

      verifyNever(encoderFactory.fromType(CategoricalDataEncoderType.ordinal,
          any));
      expect(encoders, equals({
        0: oneHotEncoderMock,
        1: oneHotEncoderMock,
        3: oneHotEncoderMock,
      }));
    });

    test('should properly process encoder-to-name map', () {
      final encoderFactory = createCategoricalDataEncoderFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final encoderToName = <CategoricalDataEncoderType, Iterable<String>>{
        CategoricalDataEncoderType.oneHot: ['country', 'gender'],
        CategoricalDataEncoderType.ordinal: ['age'],
      };

      final indexToEncoder = <int, CategoricalDataEncoderType>{};
      final nameToEncoder = <String, CategoricalDataEncoderType>{};

      when(encoderFactory.fromType(CategoricalDataEncoderType.oneHot, any))
          .thenReturn(oneHotEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncoderType.ordinal, any))
          .thenReturn(ordinalEncoderMock);

      final actual = encoderProcessor.createEncoders(indexToEncoder,
          encoderToName, nameToEncoder);

      expect(actual, equals({
        0: oneHotEncoderMock,
        1: oneHotEncoderMock,
        2: ordinalEncoderMock,
      }));
    });

    test('should throw an exception if one column is going to be processed by '
        'two different encoders', () {
      final encoderFactory = createCategoricalDataEncoderFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final indexToEncoder = <int, CategoricalDataEncoderType>{};

      final encoderToName = <CategoricalDataEncoderType, Iterable<String>>{
        CategoricalDataEncoderType.oneHot: ['country', 'gender'],
        CategoricalDataEncoderType.ordinal: ['gender'],
      };

      final nameToEncoder = <String, CategoricalDataEncoderType>{};

      when(encoderFactory.fromType(CategoricalDataEncoderType.oneHot, any))
          .thenReturn(oneHotEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncoderType.ordinal, any))
          .thenReturn(ordinalEncoderMock);

      final actual = () => encoderProcessor.createEncoders(indexToEncoder,
          encoderToName, nameToEncoder);

      expect(actual, throwsException);
    });

    test('should throw an error if unexistent column to be processed', () {
      final encoderFactory = createCategoricalDataEncoderFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);
      final oneHotEncoderMock = OneHotEncoderMock();
      final ordinalEncoderMock = OrdinalEncoderMock();

      final nameToEncoder = <String, CategoricalDataEncoderType>{
        'country': CategoricalDataEncoderType.oneHot,
        'gender': CategoricalDataEncoderType.oneHot,
        'age': CategoricalDataEncoderType.ordinal,
        'city': CategoricalDataEncoderType.ordinal,
      };

      when(encoderFactory.fromType(CategoricalDataEncoderType.ordinal, any))
          .thenReturn(ordinalEncoderMock);
      when(encoderFactory.fromType(CategoricalDataEncoderType.oneHot, any))
          .thenReturn(oneHotEncoderMock);

      expect(
        () => encoderProcessor.createEncoders({}, {}, nameToEncoder),
        throwsException
      );
    });

    test('should return an empty map if no encoders provided', () {
      final encoderFactory = createCategoricalDataEncoderFactoryMock();
      final encoderProcessor = EncodersProcessorImpl(header, encoderFactory);

      expect(encoderProcessor.createEncoders(null, null, null), equals({}));
    });
  });
}
