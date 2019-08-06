import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:quiver/iterables.dart';

Iterable<Series> convertRawDataToSeries(
    Iterable<Iterable<dynamic>> data,
    Iterable<String> columnHeaders,
) {
  final initialValue = List.filled(data.first.length, []);
  final columns = data.fold<Iterable<Iterable<dynamic>>>(
    initialValue,
    (columns, row) => zip([columns, row.map((el) => [el])])
        .map((pair) => [...pair.first, ...pair.last]),
  );
  return zip([columnHeaders, columns])
      .map((seriesData) => Series(seriesData.first, seriesData.last));
}