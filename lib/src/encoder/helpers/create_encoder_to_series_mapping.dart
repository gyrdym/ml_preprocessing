import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/helpers/get_series_names_by_indices.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder.dart';

Map<String, SeriesEncoder> createEncoderToSeriesMapping(
    DataFrame data,
    Iterable<String> predefinedSeriesNames,
    Iterable<int> seriesIndices,
    SeriesEncoder seriesEncoderFactory(Series series),
) {
  final seriesNames = predefinedSeriesNames ??
      getSeriesNamesByIndices(data.header, seriesIndices);
  final entries = seriesNames.map((name) {
    final series = data.seriesByName[name];
    final encoder = seriesEncoderFactory(series);
    return MapEntry(name, encoder);
  });
  return Map.fromEntries(entries);
}