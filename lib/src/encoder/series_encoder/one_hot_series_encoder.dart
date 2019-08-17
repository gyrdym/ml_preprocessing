import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';

class OneHotSeriesEncoder implements SeriesEncoder {
  OneHotSeriesEncoder(Series fittingData, {
    UnknownValueHandlingType unknownValueHandlingType =
        UnknownValueHandlingType.error,
    String headerPrefix = '',
    String headerPostfix = '',
  }) :
        _unknownHandlingType = unknownValueHandlingType,
        _columnHeaderTpl = ((String label) => '${headerPrefix}${label}${headerPostfix}'),
        _labels = Set.from(fittingData.data);

  final UnknownValueHandlingType _unknownHandlingType;
  final ColumnHeaderTemplateFn _columnHeaderTpl;
  final Set _labels;

  @override
  Iterable<Series> encodeSeries(Series series) => _labels.map((label) {
    final shouldThrowErrorIfUnknown =
        _unknownHandlingType == UnknownValueHandlingType.error;
    final data = series.data.map((value) {
      if (shouldThrowErrorIfUnknown && !_labels.contains(value)) {
        throw Exception('Unknown categorical value encountered - $value');
      }
      return value == label ? 1 : 0;
    });
    return Series(_columnHeaderTpl(label), data);
  });
}
