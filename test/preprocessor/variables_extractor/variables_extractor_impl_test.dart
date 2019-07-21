import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/preprocessor/records_processor/records_processor_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

import '../../mocks.dart' as mocks;

void main() {
  final data = [
    [ 10.0,  20.0,  30.0,  40.0,  50.0],
    [100.0, 200.0, 300.0, 400.0, 500.0],
    [110.0, 120.0, 130.0, 140.0, 150.0],
    [210.0, 220.0, 230.0, 240.0, 250.0],
  ];

  group('RecordsProcessorImpl', () {
    test('should extract observations according to passed colum indices', () {
      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 2, 4];
      final columnToEncodingType = <int, CategoricalDataEncodingType>{};
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final codecFactory = mocks.CategoricalDataCodecFactoryMock();

      final processor = RecordsProcessorImpl(data, columnIndices, rowIndices,
          columnToEncodingType, valueConverter, codecFactory);
      final observations = processor.encodeRecords();

      expect(
          observations,
          equals([
            [ 10.0,  30.0,  50.0],
            [100.0, 300.0, 500.0],
            [110.0, 130.0, 150.0],
            [210.0, 230.0, 250.0],
          ]));
    });

    test('should extract observations according to passed row indices', () {
      final rowIndices = <int>[0, 3];
      final columnsIndices = <int>[0, 1, 2, 3, 4];
      final encoders = <int, CategoricalDataEncodingType>{};
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final codecFactory = mocks.CategoricalDataCodecFactoryMock();

      final extractor = RecordsProcessorImpl(data, columnsIndices, rowIndices,
          encoders, valueConverter, codecFactory);
      final observations = extractor.encodeRecords();

      expect(
          observations,
          equals([
            [ 10.0,  20.0,  30.0,  40.0,  50.0],
            [210.0, 220.0, 230.0, 240.0, 250.0],
          ]));
    });

    test('should encode categorical columns, case 1', () {
      final codec = mocks.CodecMock();
      when(codec.encode(any)).thenReturn(Matrix.fromList([
        [1000.0, 2000.0],
        [-1000.0, -2000.0],
        [100.0, 200.0],
        [4000.0, 3000.0],
      ]));

      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2, 3, 4];
      final columnToEncodingType = <int, CategoricalDataEncodingType>{
        2: CategoricalDataEncodingType.oneHot,
      };
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final codecFactory = mocks.createCategoricalDataCodecFactoryMock({
        CategoricalDataEncodingType.oneHot: [codec],
      });
      final processor = RecordsProcessorImpl(data, columnIndices, rowIndices,
          columnToEncodingType, valueConverter, codecFactory);
      final observations = processor.encodeRecords();

      expect(
          observations,
          equals([
            [ 10.0,  20.0,  1000.0,  2000.0,  40.0,  50.0],
            [100.0, 200.0, -1000.0, -2000.0, 400.0, 500.0],
            [110.0, 120.0,  100.0,   200.0,  140.0, 150.0],
            [210.0, 220.0,  4000.0,  3000.0, 240.0, 250.0],
          ]));
    });

    test('should encode categorical columns, case 2', () {
      final codec = mocks.CodecMock();
      when(codec.encode(any)).thenReturn(Matrix.fromList([
        [1000],
        [5000],
        [6000],
        [7000],
      ]));

      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2, 3, 4];
      final columnToEncodingType = <int, CategoricalDataEncodingType>{
        4: CategoricalDataEncodingType.ordinal,
      };
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final codecFactory = mocks.createCategoricalDataCodecFactoryMock({
        CategoricalDataEncodingType.ordinal: [codec],
      });
      final extractor = RecordsProcessorImpl(data, columnIndices, rowIndices,
          columnToEncodingType, valueConverter, codecFactory);
      final observations = extractor.encodeRecords();

      expect(
          observations,
          equals([
            [ 10.0,  20.0,  30.0,  40.0, 1000.0],
            [100.0, 200.0, 300.0, 400.0, 5000.0],
            [110.0, 120.0, 130.0, 140.0, 6000.0],
            [210.0, 220.0, 230.0, 240.0, 7000.0],
          ]));
    });

    test('should accept column indices parameter with length, less than '
        'number of columns in source observations', () {
      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2];
      final columnToEncodingType = <int, CategoricalDataEncodingType>{};
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final codecFactory = mocks.CategoricalDataCodecFactoryMock();
      final extractor = RecordsProcessorImpl(data, columnIndices, rowIndices,
          columnToEncodingType, valueConverter, codecFactory);
      final observations = extractor.encodeRecords();

      expect(
          observations,
          equals([
            [10.0, 20.0, 30.0],
            [100.0, 200.0, 300.0],
            [110.0, 120.0, 130.0],
            [210.0, 220.0, 230.0],
          ]));
    });

    test('should throw an error if length of column indices argument is '
        'greater than number of columns in source observation', () {
      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2, 3, 4, 5];
      final columnToEncodingType = <int, CategoricalDataEncodingType>{};
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final codecFactory = mocks.CategoricalDataCodecFactoryMock();

      expect(
          () => RecordsProcessorImpl(data, columnIndices, rowIndices,
              columnToEncodingType, valueConverter, codecFactory),
          throwsException);
    });

    test('should accept row indices argument with length that is less than '
        'number of rows in source observations', () {
      final rowIndices = <int>[0, 1, 2];
      final columnsIndices = <int>[0, 1, 2, 3, 4];
      final columnToEncodingType = <int, CategoricalDataEncodingType>{};
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final codecFactory = mocks.CategoricalDataCodecFactoryMock();
      final extractor = RecordsProcessorImpl(data, columnsIndices, rowIndices,
          columnToEncodingType, valueConverter, codecFactory);
      final actual = extractor.encodeRecords();

      expect(
          actual,
          equals([
            [ 10.0,  20.0,  30.0,  40.0,  50.0],
            [100.0, 200.0, 300.0, 400.0, 500.0],
            [110.0, 120.0, 130.0, 140.0, 150.0],
          ]));
    });

    test('should throw an error if number of row indices is greater than the '
        'number of rows in dataset', () {
      final rowIndices = <int>[0, 1, 2, 3, 4, 5];
      final columnIndices = <int>[0, 1, 2, 3, 4];
      final encoders = <int, CategoricalDataEncodingType>{};
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final codecFactory = mocks.CategoricalDataCodecFactoryMock();

      expect(
          () => RecordsProcessorImpl(data, columnIndices, rowIndices,
              encoders, valueConverter, codecFactory),
          throwsException);
    });

    test('should extract ranges of categorical columns in numerical', () {
      final column0CodecMock = mocks.CodecMock();
      when(column0CodecMock.encode(any)).thenReturn(Matrix.fromList([
        [0, 0, 1],
        [1, 0, 0],
        [1, 0, 0],
        [0, 1, 0],
      ]));

      final column2CodecMock = mocks.CodecMock();
      when(column2CodecMock.encode(any)).thenReturn(Matrix.fromList([
        [0, 1, 0, 0],
        [0, 0, 1, 0],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
      ]));

      final column4CodecMock = mocks.CodecMock();
      when(column4CodecMock.encode(any)).thenReturn(Matrix.fromList([
        [1000],
        [5000],
        [6000],
        [7000],
      ]));

      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2, 3, 4];
      final columnToEncodingType = <int, CategoricalDataEncodingType>{
        0: CategoricalDataEncodingType.oneHot,
        2: CategoricalDataEncodingType.oneHot,
        4: CategoricalDataEncodingType.ordinal,
      };
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final codecFactory = mocks.createCategoricalDataCodecFactoryMock({
        CategoricalDataEncodingType.oneHot: [column0CodecMock,
          column2CodecMock],
        CategoricalDataEncodingType.ordinal: [column4CodecMock],
      });
      final processor = RecordsProcessorImpl(data, columnIndices, rowIndices,
          columnToEncodingType, valueConverter, codecFactory);
      final actual = processor.rangeToCodec;

      expect(actual, equals({
        ZRange.closed(0, 2): column0CodecMock,
        ZRange.closed(4, 7): column2CodecMock,
        ZRange.closed(9, 9): column4CodecMock,
      }));
    });
  });
}
