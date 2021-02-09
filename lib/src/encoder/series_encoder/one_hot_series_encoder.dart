import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';

class OneHotSeriesEncoder implements SeriesEncoder {
  OneHotSeriesEncoder(Series fittingData, {
    UnknownValueHandlingType unknownValueHandlingType =
        defaultUnknownValueHandlingType,
    String headerPrefix = '',
    String headerPostfix = '',
  }) :
        _unknownHandlingType = unknownValueHandlingType,
        _columnHeaderTpl = ((String label) => '${headerPrefix}${label}${headerPostfix}'),
        _labels = Set<dynamic>.from(fittingData.data);

  final UnknownValueHandlingType _unknownHandlingType;
  final ColumnHeaderTemplateFn _columnHeaderTpl;
  final Set _labels;

  @override
  Iterable<Series> encodeSeries(Series series) => _labels.map((dynamic label) {
    final shouldThrowErrorIfUnknown =
        _unknownHandlingType == UnknownValueHandlingType.error;

    final data = series
        .data
        .map((dynamic value) {
          if (shouldThrowErrorIfUnknown && !_labels.contains(value)) {
            throw Exception('Unknown categorical value encountered - `$value` '
                'for series `${series.name}`');
          }

          return value == label ? 1 : 0;
        });

    return Series(_columnHeaderTpl(label.toString()), data, isDiscrete: true);
  });
}
