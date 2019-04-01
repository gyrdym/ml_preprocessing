import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/data_frame/csv_data_frame.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

import '../mocks.dart';
import '../test_helpers/floating_point_iterable_matchers.dart';
import '../test_helpers/test_csv_data.dart';

void main() {
  group('CsvDataFrame (categories-less)', () {
    test('should properly parse csv file', () async {
      await testCsvData(
          fileName: 'test/test_data/pima_indians_diabetes_database.csv',
          labelIdx: 8,
          expectedColsNum: 8,
          expectedRowsNum: 768,
          testContentFn: (features, labels, header) {
            expect(
                features.getRow(0),
                vectorAlmostEqualTo(
                    [6.0, 148.0, 72.0, 35.0, 0.0, 33.6, 0.627, 50.0]));
            expect(
                features.getRow(34),
                vectorAlmostEqualTo(
                    [10.0, 122.0, 78.0, 31.0, 0.0, 27.6, 0.512, 45.0]));
            expect([labels[0], labels[34], labels[63]], equals([
              [1],
              [0],
              [0],
            ]));
          });
    });

    test('should parse csv file with specified label column position',
        () async {
      await testCsvData(
          fileName: 'test/test_data/pima_indians_diabetes_database.csv',
          labelIdx: 1,
          expectedColsNum: 8,
          expectedRowsNum: 768,
          testContentFn: (features, labels, header) {
            expect(
                features.getRow(0),
                vectorAlmostEqualTo(
                    [6.0, 72.0, 35.0, 0.0, 33.6, 0.627, 50.0, 1.0]));
            expect(
                features.getRow(34),
                vectorAlmostEqualTo(
                    [10.0, 78.0, 31.0, 0.0, 27.6, 0.512, 45.0, 0.0]));
            expect([labels[0], labels[34], labels[63]],
                equals([
                  [148.0],
                  [122.0],
                  [141.0],
                ]));
          });
    });

    test('should parse csv file with specified label column position, '
        'position is 0', () async {
      await testCsvData(
          fileName: 'test/test_data/pima_indians_diabetes_database.csv',
          labelIdx: 0,
          expectedColsNum: 8,
          expectedRowsNum: 768,
          testContentFn: (features, labels, header) {
            expect(
                features.getRow(0),
                vectorAlmostEqualTo(
                    [148.0, 72.0, 35.0, 0.0, 33.6, 0.627, 50.0, 1.0]));
            expect(
                features.getRow(34),
                vectorAlmostEqualTo(
                    [122.0, 78.0, 31.0, 0.0, 27.6, 0.512, 45.0, 0.0]));
            expect(
                [labels[0], labels[34], labels[63]], equals([
                  [6.0],
                  [10.0],
                  [2.0]
            ]));
          });
    });

    test('should extract header test_data if the latter is specified',
        () async {
      await testCsvData(
          fileName:
              'test/test_data/pima_indians_diabetes_database.csv',
          labelIdx: 0,
          expectedColsNum: 8,
          expectedRowsNum: 768,
          testContentFn: (features, labels, header) {
            expect(
                header,
                equals([
                  'number of times pregnant',
                  'plasma glucose concentration a 2 hours in an oral glucose tolerance test',
                  'diastolic blood pressure (mm Hg)',
                  'triceps skin fold thickness (mm)',
                  '2-Hour serum insulin (mu U/ml)',
                  'body mass index (weight in kg/(height in m)^2)',
                  'diabetes pedigree function',
                  'age (years)',
                  'class variable (0 or 1)',
                ]));
          });
    });

    test('should throw an error if label index is not in provided ranges',
        () async {
      expect(
        () => CsvDataFrame.fromFile(
              'test/test_data/elo_blatter.csv',
              labelIdx: 1,
              columns: [ZRange.closed(2, 3), ZRange.closed(5, 7)],
            ),
        throwsException,
      );
    });

    test('should throw an error if neither label index nor label name is not '
        'provided', () async {
      expect(() => CsvDataFrame.fromFile(
          'test/test_data/elo_blatter.csv',
          labelIdx: null,
          labelName: null,
          columns: [ZRange.closed(2, 3), ZRange.closed(5, 7)],
        ),
        throwsException,
      );
    });

    test('should throw an error if label name does not present in the data '
        'frame header', () async {
      final data = CsvDataFrame.fromFile(
        'test/test_data/elo_blatter.csv',
        labelIdx: null,
        labelName: 'some_unknown_column',
        columns: [ZRange.closed(2, 3), ZRange.closed(5, 7)],
      );
      expect(() async => await data.header, throwsException);
    });

    test('should not throw an error if label name does not present in the data '
        'frame header, but valid label index is provided', () async {
      final data = CsvDataFrame.fromFile(
        'test/test_data/elo_blatter.csv',
        labelIdx: 1,
        labelName: 'some_unknown_column',
        columns: [ZRange.closed(0, 3), ZRange.closed(5, 7)],
        rows: [ZRange.closed(0, 0)],
        categories: {
          'country': CategoricalDataEncoderType.oneHot,
          'confederation': CategoricalDataEncoderType.oneHot,
          'gdp_source': CategoricalDataEncoderType.oneHot,
          'popu_source': CategoricalDataEncoderType.oneHot,
        },
      );
      final actual = await data.labels;
      expect(actual, equals([[993.0]]));
    });

    test('should cut out selected columns', () async {
      await testCsvData(
          fileName:
              'test/test_data/pima_indians_diabetes_database.csv',
          labelIdx: 8,
          expectedColsNum: 8,
          expectedRowsNum: 768,
          columns: [
            ZRange.closed(0, 1),
            ZRange.closed(2, 2),
            ZRange.closed(3, 4),
            ZRange.closed(6, 8)
          ],
          testContentFn: (features, labels, header) {
            expect(
                features.getRow(0),
                vectorAlmostEqualTo(
                    [6.0, 148.0, 72.0, 35.0, 0.0, 0.627, 50.0]));
            expect(
                features.getRow(34),
                vectorAlmostEqualTo(
                    [10.0, 122.0, 78.0, 31.0, 0.0, 0.512, 45.0]));
            expect([labels[0], labels[34], labels[63]], equals([
              [1],
              [0],
              [0],
            ]));
          });
    });

    test('should throw an error if there are intersecting column ranges while '
        'parsing csv file', () {
      final actual = () => CsvDataFrame.fromFile(
            'test/test_data/pima_indians_diabetes_database.csv',
            labelIdx: 8,
            columns: [
              ZRange.closed(0, 1), // first and
              ZRange.closed(1, 2), // second ranges are intersecting
              ZRange.closed(3, 4),
              ZRange.closed(6, 8)
            ],
          );
      expect(actual, throwsException);
    });

    test('should cut out selected rows, all rows in one range', () async {
      await testCsvData(
          fileName:
              'test/test_data/pima_indians_diabetes_database.csv',
          labelIdx: 8,
          rows: [ZRange.closed(0, 767)],
          expectedColsNum: 8,
          expectedRowsNum: 768,
          testContentFn: (features, labels, header) {
            expect(
                features.getRow(0),
                vectorAlmostEqualTo(
                    [6.0, 148.0, 72.0, 35.0, 0.0, 33.6, 0.627, 50.0]));
            expect(
                features.getRow(767),
                vectorAlmostEqualTo(
                    [1.0, 93.0, 70.0, 31.0, 0.0, 30.4, 0.315, 23.0]));
            expect(() => features.getRow(768), throwsRangeError);
            expect([labels[0], labels[34], labels[767]], equals([
              [1],
              [0],
              [0],
            ]));
            expect(() => labels[768], throwsRangeError);
          });
    });

    test('should cut out selected rows, several row ranges', () async {
      await testCsvData(
          fileName:
              'test/test_data/pima_indians_diabetes_database.csv',
          labelIdx: 8,
          rows: [
            ZRange.closed(0, 2),
            ZRange.closed(3, 4),
            ZRange.closed(10, 15),
          ],
          expectedColsNum: 8,
          expectedRowsNum: 11,
          testContentFn: (features, labels, header) {
            expect(
                features,
                matrixAlmostEqualTo([
                  [6.0, 148.0, 72.0, 35.0, 0.0, 33.6, 0.627, 50.0],
                  [1.0, 85.0, 66.0, 29.0, 0.0, 26.6, 0.351, 31.0],
                  [8.0, 183.0, 64.0, 0.0, 0.0, 23.3, 0.672, 32.0],
                  [1.0, 89.0, 66.0, 23.0, 94.0, 28.1, 0.167, 21.0],
                  [0.0, 137.0, 40.0, 35.0, 168.0, 43.1, 2.288, 33.0],
                  [4.0, 110.0, 92.0, 0.0, 0.0, 37.6, 0.191, 30.0],
                  [10.0, 168.0, 74.0, 0.0, 0.0, 38.0, 0.537, 34.0],
                  [10.0, 139.0, 80.0, 0.0, 0.0, 27.1, 1.441, 57.0],
                  [1.0, 189.0, 60.0, 23.0, 846.0, 30.1, 0.398, 59.0],
                  [5.0, 166.0, 72.0, 19.0, 175.0, 25.8, 0.587, 51.0],
                  [7.0, 100.0, 0.0, 0.0, 0.0, 30.0, 0.484, 32.0],
                ]));
            expect(() => features.getRow(11), throwsRangeError);
            expect(() => features.getRow(768), throwsRangeError);

            expect(labels.rowsNum, 11);
            expect(labels.columnsNum, 1);
            expect(labels.getColumn(0),
                equals([1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1]));
            expect(() => labels[11], throwsRangeError);
            expect(() => labels[768], throwsRangeError);
          });
    });

    test('should throw an error if params validation fails', () {
      final validatorMock =
          createDataFrameParamsValidatorMock(validationShouldBeFailed: true);
      final actual = () => CsvDataFrame.fromFile(
            'test/test_data/pima_indians_diabetes_database.csv',
            paramsValidator: validatorMock,
          );
      expect(actual, throwsException);
    });
  });
}
