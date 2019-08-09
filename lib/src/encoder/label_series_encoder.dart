import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/encoder_helpers.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder.dart';

class LabelSeriesEncoder implements SeriesEncoder {
  LabelSeriesEncoder(Series fittingData, {
    String headerPrefix,
    String headerPostfix,
  }) : _columnHeaderTpl = ((String label) => '${headerPrefix}${label}${headerPostfix}');

  final ColumnHeaderTemplateFn _columnHeaderTpl;

  @override
  Iterable<Series> encodeSeries(Series series) {
    final labelToColumnId = getColumnIdByLabelMapping(series);
    return [
      Series(
        _columnHeaderTpl(series.name),
        series.data.map((label) => labelToColumnId[label]),
      ),
    ];
  }
}
