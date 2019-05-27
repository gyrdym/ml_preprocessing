import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/categorical_encoder/encoder.dart';
import 'package:ml_preprocessing/src/data_frame/variables_extractor/variables_extractor_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../mocks.dart' as mocks;

void main() {
  final data = [
    [10.0, 20.0, 30.0, 40.0, 50.0],
    [100.0, 200.0, 300.0, 400.0, 500.0],
    [110.0, 120.0, 130.0, 140.0, 150.0],
    [210.0, 220.0, 230.0, 240.0, 250.0],
  ];

  group('VariablesExtractorImpl', () {
    test('should extract variables according to passed colum indices', () {
      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 2, 4];
      final encoders = <int, CategoricalDataEncoder>{};
      final labelIdx = 4;
      final valueConverter = mocks.ToFloatNumberConverterMock();

      final extractor = VariablesExtractorImpl(data, columnIndices, rowIndices,
          encoders, labelIdx, valueConverter);
      final features = extractor.features;
      final labels = extractor.labels;

      expect(
          features,
          equals([
            [10.0, 30.0],
            [100.0, 300.0],
            [110.0, 130.0],
            [210.0, 230.0],
          ]));

      expect(
          labels,
          equals([
            [50.0],
            [500.0],
            [150.0],
            [250.0],
          ]),
      );
    });

    test('should extract variables according to passed row indices', () {
      final rowIndices = <int>[0, 3];
      final columnsIndices = <int>[0, 1, 2, 3, 4];
      final encoders = <int, CategoricalDataEncoder>{};
      final labelIdx = 4;
      final valueConverter = mocks.ToFloatNumberConverterMock();

      final extractor = VariablesExtractorImpl(data, columnsIndices, rowIndices,
          encoders, labelIdx, valueConverter);
      final features = extractor.features;
      final labels = extractor.labels;

      expect(
          features,
          equals([
            [10.0, 20.0, 30.0, 40.0],
            [210.0, 220.0, 230.0, 240.0],
          ]));

      expect(labels, equals([
        [50],
        [250],
      ]));
    });

    test('should consider index of a label column while extracting variables',
        () {
      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2, 3, 4];
      final encoders = <int, CategoricalDataEncoder>{};
      final labelIdx = 1;
      final valueConverter = mocks.ToFloatNumberConverterMock();

      final extractor = VariablesExtractorImpl(data, columnIndices, rowIndices,
          encoders, labelIdx, valueConverter);
      final features = extractor.features;
      final labels = extractor.labels;

      expect(
          features,
          equals([
            [10.0, 30.0, 40.0, 50.0],
            [100.0, 300.0, 400.0, 500.0],
            [110.0, 130.0, 140.0, 150.0],
            [210.0, 230.0, 240.0, 250.0],
          ]));

      expect(labels, equals([
        [20],
        [200],
        [120],
        [220],
      ]));
    });

    test('should encode categorical features', () {
      final encoderMock = mocks.OneHotEncoderMock();
      when(encoderMock.encode(any)).thenReturn(Matrix.fromList([
        [1000.0, 2000.0],
        [-1000.0, -2000.0],
        [100.0, 200.0],
        [4000.0, 3000.0],
      ]));

      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2, 3, 4];
      final encoders = <int, CategoricalDataEncoder>{
        2: encoderMock,
      };
      final labelIdx = 4;
      final valueConverter = mocks.ToFloatNumberConverterMock();

      final extractor = VariablesExtractorImpl(data, columnIndices, rowIndices,
          encoders, labelIdx, valueConverter);
      final features = extractor.features;

      expect(
          features,
          equals([
            [10.0, 20.0, 1000.0, 2000.0, 40.0],
            [100.0, 200.0, -1000.0, -2000.0, 400.0],
            [110.0, 120.0, 100.0, 200.0, 140.0],
            [210.0, 220.0, 4000.0, 3000.0, 240.0],
          ]));
    });

    test('should encode categorical labels', () {
      final encoderMock = mocks.OneHotEncoderMock();
      when(encoderMock.encode(any)).thenReturn(Matrix.fromList([
        [1000],
        [5000],
        [6000],
        [7000],
      ]));

      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2, 3, 4];
      final labelIdx = 4;
      final encoders = <int, CategoricalDataEncoder>{
        labelIdx: encoderMock,
      };
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final extractor = VariablesExtractorImpl(data, columnIndices, rowIndices,
          encoders, labelIdx, valueConverter);
      final features = extractor.features;
      final labels = extractor.labels;

      expect(
          features,
          equals([
            [10.0, 20.0, 30.0, 40.0],
            [100.0, 200.0, 300.0, 400.0],
            [110.0, 120.0, 130.0, 140.0],
            [210.0, 220.0, 230.0, 240.0],
          ]));

      expect(labels, equals([
        [1000],
        [5000],
        [6000],
        [7000],
      ]));
    });

    test('should not throw an error if number of column indices is less than '
        'number of elements in an observation', () {
      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2];
      final encoders = <int, CategoricalDataEncoder>{};
      final labelIdx = 4;
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final extractor = VariablesExtractorImpl(data, columnIndices, rowIndices,
          encoders, labelIdx, valueConverter);
      final features = extractor.features;
      final labels = extractor.labels;

      expect(
          features,
          equals([
            [10.0, 20.0, 30.0],
            [100.0, 200.0, 300.0],
            [110.0, 120.0, 130.0],
            [210.0, 220.0, 230.0],
          ]));

      expect(labels, isNull);
    }, skip: true);

    test('should throw an error if number of column indices is greater than '
        'number of elements in an observation', () {
      final rowIndices = <int>[0, 1, 2, 3];
      final columnIndices = <int>[0, 1, 2, 3, 4, 5];
      final encoders = <int, CategoricalDataEncoder>{};
      final labelIdx = 4;
      final valueConverter = mocks.ToFloatNumberConverterMock();

      expect(
          () => VariablesExtractorImpl(data, columnIndices, rowIndices,
              encoders, labelIdx, valueConverter),
          throwsException);
    });

    test('should not throw an error if number of row indices is less than '
        'number of rows in dataset', () {
      final rowIndices = <int>[0, 1, 2];
      final columnsIndices = <int>[0, 1, 2, 3, 4];
      final encoders = <int, CategoricalDataEncoder>{};
      final labelIdx = 4;
      final valueConverter = mocks.ToFloatNumberConverterMock();
      final extractor = VariablesExtractorImpl(data, columnsIndices, rowIndices,
          encoders, labelIdx, valueConverter);
      final actual = extractor.features;

      expect(
          actual,
          equals([
            [10.0, 20.0, 30.0, 40.0],
            [100.0, 200.0, 300.0, 400.0],
            [110.0, 120.0, 130.0, 140.0],
          ]));
    });

    test('should throw an error if number of row indices is greater than '
        'number of rows in dataset', () {
      final rowIndices = <int>[0, 1, 2, 3, 4, 5];
      final columnIndices = <int>[0, 1, 2, 3, 4];
      final encoders = <int, CategoricalDataEncoder>{};
      final labelIdx = 4;
      final valueConverter = mocks.ToFloatNumberConverterMock();

      expect(
          () => VariablesExtractorImpl(data, columnIndices, rowIndices,
              encoders, labelIdx, valueConverter),
          throwsException);
    });
  });
}
