import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/error_messages.dart';
import 'package:ml_preprocessing/src/preprocessor/validator/params_validator.dart';
import 'package:xrange/zrange.dart';

class DataFrameParamsValidatorImpl implements PreprocessorArgumentsValidator {
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
      return PreprocessorArgumentsValidationErrorMessages
          .noHeaderExistsParameterProvidedMsg();
    }
    return PreprocessorArgumentsValidationErrorMessages.noErrorMsg;
  }

  String _validateNamesToEncoders(
      Map<String, CategoricalDataEncodingType> namesToEncoders,
      bool headerExists) {
    if (namesToEncoders?.isEmpty == true) {
      return PreprocessorArgumentsValidationErrorMessages.emptyEncodersMsg();
    }
    if (!headerExists && namesToEncoders?.isNotEmpty == true) {
      return PreprocessorArgumentsValidationErrorMessages
          .noHeaderProvidedForColumnEncodersMsg(namesToEncoders);
    }
    return PreprocessorArgumentsValidationErrorMessages.noErrorMsg;
  }

  String _validateLabelPosition(int labelIdx, String labelName,
      bool headerExists) {
    if (labelIdx == null && labelName == null) {
      return PreprocessorArgumentsValidationErrorMessages.noLabelPositionMsg();
    }
    if (labelName != null && headerExists == false) {
      return PreprocessorArgumentsValidationErrorMessages
          .labelNameWithoutHeader();
    }
    return PreprocessorArgumentsValidationErrorMessages.noErrorMsg;
  }

  String _validateRanges(Iterable<ZRange> ranges, [int labelIdx]) {
    if (ranges == null || ranges.isEmpty == true) {
      return PreprocessorArgumentsValidationErrorMessages.noErrorMsg;
    }
    ZRange prevRange;
    bool isLabelInRanges = false;

    for (final range in ranges) {
      if (prevRange?.connectedTo(range) == true) {
        return PreprocessorArgumentsValidationErrorMessages
            .intersectingRangesMsg(prevRange, range);
      }
      if (labelIdx != null && range.contains(labelIdx)) {
        isLabelInRanges = true;
      }
      prevRange = range;
    }

    if (labelIdx != null && !isLabelInRanges) {
      return PreprocessorArgumentsValidationErrorMessages
          .labelIsNotInRangesMsg(labelIdx, ranges);
    }
    return PreprocessorArgumentsValidationErrorMessages.noErrorMsg;
  }
}
