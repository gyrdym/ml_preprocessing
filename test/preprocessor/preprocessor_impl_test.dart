import 'package:ml_preprocessing/src/preprocessor/preprocessor_impl.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

import '../mocks.dart';
import '../test_helpers/floating_point_iterable_matchers.dart';
import '../test_helpers/test_preprocessor_impl.dart';

void main() {
  group('PreprocessorImpl (categories-less)', () {
    final dataFromReader = [
      ['column_1', 'column_2', 'column_3', 'column_4', 'column_5', 'outcome'],
      [100.0, 200.0, 300.0, 400.0, 215.0, 333.0],
      [ 10.0,  20.0,  30.0,  40.0,  25.0,  33.0],
      [500.0, 700.0, 101.0, 403.0, 117.0, 111.0],
    ];

    test('should parse data reader output data', () async {
      await testPreprocessor(
          dataFromReader: dataFromReader,
          labelIdx: 5,
          testOutputFn: (dataSet) {
            expect(
              dataSet.toMatrix(),
              matrixAlmostEqualTo([
                [100.0, 200.0, 300.0, 400.0, 215.0, 333.0],
                [ 10.0,  20.0,  30.0,  40.0,  25.0,  33.0],
                [500.0, 700.0, 101.0, 403.0, 117.0, 111.0],
              ]),
            );
            expect(dataSet.outcome, equals([[333.0], [33.0], [111.0]]));
          });
    });

    test('should parse data reader output data with specified label column '
        'position, case 1', () async {
      await testPreprocessor(
          dataFromReader: dataFromReader,
          labelIdx: 2,
          testOutputFn: (dataSet) {
            expect(
              dataSet.toMatrix(),
              matrixAlmostEqualTo([
                [100.0, 200.0, 300.0, 400.0, 215.0, 333.0],
                [ 10.0,  20.0,  30.0,  40.0,  25.0,  33.0],
                [500.0, 700.0, 101.0, 403.0, 117.0, 111.0],
              ]),
            );
            expect(dataSet.outcome, equals([[300.0], [30.0], [101.0]]));
          });
    });

    test('should parse data reader output data with specified label column '
        'position, case 2', () async {
      await testPreprocessor(
          dataFromReader: dataFromReader,
          labelIdx: 0,
          testOutputFn: (dataSet) {
            expect(
              dataSet.toMatrix(),
              matrixAlmostEqualTo([
                [100.0, 200.0, 300.0, 400.0, 215.0, 333.0],
                [ 10.0,  20.0,  30.0,  40.0,  25.0,  33.0],
                [500.0, 700.0, 101.0, 403.0, 117.0, 111.0],
              ]),
            );
            expect(dataSet.outcome, equals([[100.0], [10.0], [500.0]]));
          }
      );
    });

    test('should throw an error if label index is not in provided '
        'ranges', () async {
      expect(
        () => PreprocessorImpl(
          DataReaderMock(),
          labelIdx: 1,
          columns: [ZRange.closed(2, 3), ZRange.closed(5, 7)],
        ),
        throwsException,
      );
    });

    test('should throw an error if neither label index nor label name is not '
        'provided', () async {
      expect(
        () => PreprocessorImpl(
          DataReaderMock(),
          labelIdx: null,
          labelName: null,
          columns: [ZRange.closed(2, 3), ZRange.closed(5, 7)],
        ),
        throwsException,
      );
    });

    test('should not throw an error if label name does not present in the data '
        'header, but valid label index is provided', () async {
      testPreprocessor(
        dataFromReader: dataFromReader,
        labelIdx: 1,
        labelName: 'some_unknown_column',
        testOutputFn: (dataSet) {
          expect(dataSet.outcome, equals([[200.0], [20.0], [700.0]]));
        }
      );
    });

    test('should cut out selected columns', () async {
      await testPreprocessor(
          dataFromReader: dataFromReader,
          labelIdx: 3,
          columns: [
            ZRange.closed(0, 1),
            ZRange.closed(3, 4),
          ],
          testOutputFn: (dataSet) {
            expect(
              dataSet.toMatrix(),
              matrixAlmostEqualTo([
                [100.0, 200.0, 400.0, 215.0],
                [ 10.0,  20.0,  40.0,  25.0],
                [500.0, 700.0, 403.0, 117.0],
              ]),
            );
            expect(dataSet.outcome, equals([[215.0], [25.0], [117.0]]));
          });
    });

    test('should throw an error if there are intersecting column ranges while '
        'parsing csv file', () {
      final actual = () => PreprocessorImpl(
        DataReaderMock(),
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
      await testPreprocessor(
          dataFromReader: dataFromReader,
          labelIdx: 5,
          rows: [ZRange.closed(0, 2)],
          testOutputFn: (dataSet) {
            expect(
              dataSet.toMatrix(),
              matrixAlmostEqualTo([
                [100.0, 200.0, 300.0, 400.0, 215.0, 333.0],
                [ 10.0,  20.0,  30.0,  40.0,  25.0,  33.0],
                [500.0, 700.0, 101.0, 403.0, 117.0, 111.0],
              ]),
            );
            expect(dataSet.outcome, equals([[333.0], [33.0], [111.0]]));
          });
    });

    test('should cut out selected rows, several row ranges', () async {
      await testPreprocessor(
          dataFromReader: dataFromReader,
          labelIdx: 5,
          rows: [
            ZRange.singleton(0),
            ZRange.singleton(2),
          ],
          testOutputFn: (dataSet) {
            expect(
              dataSet.toMatrix(),
              matrixAlmostEqualTo([
                [100.0, 200.0, 300.0, 400.0, 215.0, 333.0],
                [500.0, 700.0, 101.0, 403.0, 117.0, 111.0],
              ]),
            );
            expect(dataSet.outcome, equals([[333.0], [111.0]]));
          });
    });

    test('should throw an error if params validation fails', () {
      final validatorMock =
          createPreprocessorArgumentsValidatorMock(validationShouldBeFailed: true);
      final actual = () => PreprocessorImpl(
            DataReaderMock(),
            argumentsValidator: validatorMock,
          );
      expect(actual, throwsException);
    });
  });
}
