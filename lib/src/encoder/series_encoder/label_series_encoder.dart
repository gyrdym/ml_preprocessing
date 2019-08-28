import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';

class LabelSeriesEncoder implements SeriesEncoder {
  LabelSeriesEncoder(Series fittingData, {
    UnknownValueHandlingType unknownValueHandlingType =
        UnknownValueHandlingType.error,
    String headerPrefix = '',
    String headerPostfix = '',
  }) :
        _unknownHandlingType = unknownValueHandlingType,
        _columnHeaderTpl = ((String label) => '${headerPrefix}${label}${headerPostfix}'),
        _labels = Set<dynamic>.from(fittingData.data).toList(growable: false);

  final UnknownValueHandlingType _unknownHandlingType;
  final ColumnHeaderTemplateFn _columnHeaderTpl;
  final List _labels;

  @override
  Iterable<Series> encodeSeries(Series series) {
    final shouldThrowErrorIfUnknown =
        _unknownHandlingType == UnknownValueHandlingType.error;
    return [
      Series(
        _columnHeaderTpl(series.name),
        series.data.map<dynamic>((dynamic label) {
          if (!_labels.contains(label)) {
            if (shouldThrowErrorIfUnknown) {
              throw Exception('Unknown categorical value encountered - $label');
            }
            return _labels.length;
          }
          return _labels.indexOf(label);
        }),
        isDiscrete: true,
      ),
    ];
  }
}
