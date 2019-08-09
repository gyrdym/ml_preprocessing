import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';

class OneHotSeriesEncoder implements SeriesEncoder {
  OneHotSeriesEncoder(Series fittingData, {
    String headerPrefix = '',
    String headerPostfix = '',
  }) :
        _columnHeaderTpl = ((String label) => '${headerPrefix}${label}${headerPostfix}'),
        _labels = Set.from(fittingData.data);

  final ColumnHeaderTemplateFn _columnHeaderTpl;
  final Set _labels;

  @override
  Iterable<Series> encodeSeries(Series series) => _labels.map((label) {
    final data = series.data.map((value) => value == label ? 1 : 0);
    return Series(_columnHeaderTpl(label), data);
  });
}
