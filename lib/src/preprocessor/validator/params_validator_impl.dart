import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/error_messages.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:xrange/zrange.dart';

class DataFrameParamsValidatorImpl implements DataFrameParamsValidator {
  const DataFrameParamsValidatorImpl();

  @override
  String validate({
    int labelIdx,
    String labelName,
    Iterable<ZRange> rows,
    Iterable<ZRange> columns,
    bool headerExists = true,
    Map<String, CategoricalDataEncodingType> namesToEncoders,
    Map<int, CategoricalDataEncodingType> indexToEncoder,
  }) {
    final validators = [
      () => _validateHeaderExistsParam(headerExists),
      () => _validateNamesToEncoders(namesToEncoders, headerExists),
      () => _validateLabelPosition(labelIdx, labelName, headerExists),
      () => _validateRanges(rows),
      () => _validateRanges(columns, labelIdx),
    ];
    for (int i = 0; i < validators.length; i++) {
      final errorMsg = validators[i]();
      if (errorMsg != '') {
        return errorMsg;
      }
    }
    return '';
  }

  String _validateHeaderExistsParam(bool headerExists) {
    if (headerExists == null) {
      return DataFrameParametersValidationErrorMessages
          .noHeaderExistsParameterProvidedMsg();
    }
    return DataFrameParametersValidationErrorMessages.noErrorMsg;
  }

  String _validateNamesToEncoders(
      Map<String, CategoricalDataEncodingType> namesToEncoders,
      bool headerExists) {
    if (namesToEncoders?.isEmpty == true) {
      return DataFrameParametersValidationErrorMessages.emptyEncodersMsg();
    }
    if (!headerExists && namesToEncoders?.isNotEmpty == true) {
      return DataFrameParametersValidationErrorMessages
          .noHeaderProvidedForColumnEncodersMsg(namesToEncoders);
    }
    return DataFrameParametersValidationErrorMessages.noErrorMsg;
  }

  String _validateLabelPosition(int labelIdx, String labelName,
      bool headerExists) {
    if (labelIdx == null && labelName == null) {
      return DataFrameParametersValidationErrorMessages.noLabelPositionMsg();
    }
    if (labelName != null && headerExists == false) {
      return DataFrameParametersValidationErrorMessages
          .labelNameWithoutHeader();
    }
    return DataFrameParametersValidationErrorMessages.noErrorMsg;
  }

  String _validateRanges(Iterable<ZRange> ranges, [int labelIdx]) {
    if (ranges == null || ranges.isEmpty == true) {
      return DataFrameParametersValidationErrorMessages.noErrorMsg;
    }
    ZRange prevRange;
    bool isLabelInRanges = false;

    for (final range in ranges) {
      if (prevRange?.connectedTo(range) == true) {
        return DataFrameParametersValidationErrorMessages
            .intersectingRangesMsg(prevRange, range);
      }
      if (labelIdx != null && range.contains(labelIdx)) {
        isLabelInRanges = true;
      }
      prevRange = range;
    }

    if (labelIdx != null && !isLabelInRanges) {
      return DataFrameParametersValidationErrorMessages
          .labelIsNotInRangesMsg(labelIdx, ranges);
    }
    return DataFrameParametersValidationErrorMessages.noErrorMsg;
  }
}
