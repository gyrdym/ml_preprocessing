import 'package:ml_preprocessing/src/categorical_encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/data_frame/validator/error_messages.dart';
import 'package:ml_preprocessing/src/data_frame/validator/params_validator_impl.dart';
import 'package:test/test.dart';
import 'package:xrange/zrange.dart';

void main() {
  group('DataFrameParamsValidatorImpl (`rows` param)', () {
    test('should return no error message if no row ranges are provided', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: null,
        columns: [ZRange.closed(0, 1)],
        headerExists: true,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .noErrorMsg));
    });

    test('should return no error message if empty row ranges list is '
        'provided', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: [],
        columns: [ZRange.closed(0, 1)],
        headerExists: true,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .noErrorMsg));
    });

    test('should return proper error message if provided row ranges are '
        'intersecting', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final rowRange1 = ZRange.closed(0, 2);
      final rowRange2 = ZRange.closed(0, 1);
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: [rowRange1, rowRange2],
        columns: [ZRange.closed(0, 1)],
        headerExists: true,
      );
      expect(
          actual,
          equals(DataFrameParametersValidationErrorMessages
              .intersectingRangesMsg(rowRange1, rowRange2)));
    });

    test('should return proper error message if provided row ranges are '
        'intersecting, corner case', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final rowRange1 = ZRange.closed(0, 2);
      final rowRange2 = ZRange.closed(2, 3);
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: [rowRange1, rowRange2],
        columns: [ZRange.closed(0, 1)],
        headerExists: true,
      );
      expect(
          actual,
          equals(DataFrameParametersValidationErrorMessages
              .intersectingRangesMsg(rowRange1, rowRange2)));
    });

    test('should return no error message if valid row ranges list is '
        'provided', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final rowRange1 = ZRange.closed(0, 2);
      final rowRange2 = ZRange.closed(5, 6);
      final rowRange3 = ZRange.closed(7, 10);
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: [rowRange1, rowRange2, rowRange3],
        columns: [ZRange.closed(0, 1)],
        headerExists: true,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .noErrorMsg));
    });
  });

  group('DataFrameParamsValidatorImpl (`columns` param)', () {
    test('should return no error message if no row ranges are provided', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: [ZRange.closed(0, 1)],
        columns: null,
        headerExists: true,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .noErrorMsg));
    });

    test('should return no error message if empty row ranges list is provided',
        () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: [ZRange.closed(0, 1)],
        columns: [],
        headerExists: true,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .noErrorMsg));
    });

    test('should return proper error message if provided row ranges are '
        'intersecting', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final colRange1 = ZRange.closed(0, 2);
      final colRange2 = ZRange.closed(0, 1);
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: [ZRange.closed(0, 1)],
        columns: [colRange1, colRange2],
        headerExists: true,
      );
      expect(
          actual,
          equals(DataFrameParametersValidationErrorMessages
              .intersectingRangesMsg(colRange1, colRange2)));
    });

    test('should return proper error message if provided row ranges are '
        'intersecting, corner case', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final colRange1 = ZRange.closed(0, 2);
      final colRange2 = ZRange.closed(2, 3);
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: [ZRange.closed(0, 1)],
        columns: [colRange1, colRange2],
        headerExists: true,
      );
      expect(
          actual,
          equals(DataFrameParametersValidationErrorMessages
              .intersectingRangesMsg(colRange1, colRange2)));
    });

    test('should return no error message if valid row ranges list is provided',
        () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final colRange1 = ZRange.closed(0, 2);
      final colRange2 = ZRange.closed(5, 6);
      final colRange3 = ZRange.closed(7, 10);
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 0,
        rows: [ZRange.closed(0, 1)],
        columns: [colRange1, colRange2, colRange3],
        headerExists: true,
      );
      expect(actual,
          equals(DataFrameParametersValidationErrorMessages.noErrorMsg));
    });
  });

  group('DataFrameParamsValidatorImpl (label position parameters)', () {
    test('should return no error message if label index is provided', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 10,
        headerExists: true,
      );
      expect(actual,
          equals(DataFrameParametersValidationErrorMessages.noErrorMsg));
    });

    test('should return proper error message if no label index is provided',
        () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: null,
        headerExists: true,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .noLabelPositionMsg()));
    });

    test('should return proper error message if provided column ranges list '
        'does not contain label index', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final labelIdx = 10;
      final ranges = [
        ZRange.closed(0, 5),
        ZRange.closed(6, 8)
      ];
      final actual = dataFrameParamsValidator.validate(
        labelIdx: labelIdx,
        columns: ranges,
        headerExists: true,
      );
      expect(
          actual,
          equals(DataFrameParametersValidationErrorMessages
              .labelIsNotInRangesMsg(labelIdx, ranges)));
    });

    test('should return proper error message if neither `labelIdx` nor '
        '`labelName` are provided', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final ranges = [
        ZRange.closed(0, 5),
        ZRange.closed(6, 8)
      ];
      final actual = dataFrameParamsValidator.validate(
        labelIdx: null,
        labelName: null,
        columns: ranges,
        headerExists: true,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .noLabelPositionMsg()));
    });

    test('should return proper error message if `labelName` is provided, '
        'but `headerExists` is false (no header case)', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final ranges = [
        ZRange.closed(0, 5),
        ZRange.closed(6, 8)
      ];
      final actual = dataFrameParamsValidator.validate(
        labelIdx: null,
        labelName: 'some name',
        columns: ranges,
        headerExists: false,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .labelNameWithoutHeader()));
    });

    test('should return proper error message if `labelName` is provided, '
        'but `headerExists` is false (no header case), despite of not null '
        '`labelIdx`', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final ranges = [
        ZRange.closed(0, 5),
        ZRange.closed(6, 8)
      ];
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 3,
        labelName: 'some name',
        columns: ranges,
        headerExists: false,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .labelNameWithoutHeader()));
    });
  });

  group('DataFrameParamsValidatorImpl (`headerExists` param)', () {
    test('should return no error message if `headerExists` param is provided',
        () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 10,
        headerExists: true,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .noErrorMsg));
    });

    test('should return proper error message if no `headerExists` param '
        'is provided', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: null,
        headerExists: null,
      );
      expect(
          actual,
          equals(DataFrameParametersValidationErrorMessages
              .noHeaderExistsParameterProvidedMsg()));
    });
  });

  group('DataFrameParamsValidatorImpl (`namesToEncoders` param)', () {
    test('should return no-error message if `namesToEncoders` param is not '
        'provided', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 10,
        namesToEncoders: null,
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .noErrorMsg));
    });

    test('should return proper error message if `namesToEncoders` is '
        'empty', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 10,
        namesToEncoders: {},
      );
      expect(actual, equals(DataFrameParametersValidationErrorMessages
          .emptyEncodersMsg()));
    });

    test('should return proper error message if no `headerExists` param is '
        'provided, but `namesToEncoders` param exists', () {
      final dataFrameParamsValidator = const DataFrameParamsValidatorImpl();
      final encoders = {'cat1': CategoricalDataEncoderType.ordinal};
      final actual = dataFrameParamsValidator.validate(
        labelIdx: 10,
        headerExists: false,
        namesToEncoders: encoders,
      );
      expect(
          actual,
          equals(DataFrameParametersValidationErrorMessages
              .noHeaderProvidedForColumnEncodersMsg(encoders)));
    });
  });
}
