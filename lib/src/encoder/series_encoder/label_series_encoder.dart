import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';

class LabelSeriesEncoder implements SeriesEncoder {
  LabelSeriesEncoder(Series fittingData, {
    String headerPrefix,
    String headerPostfix,
  }) :
        _columnHeaderTpl = ((String label) => '${headerPrefix}${label}${headerPostfix}'),
        _labels = Set.from(fittingData.data).toList(growable: false);

  final ColumnHeaderTemplateFn _columnHeaderTpl;
  final List _labels;

  @override
  Iterable<Series> encodeSeries(Series series) {
    return [
      Series(
        _columnHeaderTpl(series.name),
        series.data.map((label) => _labels.indexOf(label)),
      ),
    ];
  }
}
