import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:quiver/iterables.dart';

Iterable<Series> convertRowsToSeries(
    Iterable<Iterable<dynamic>> rows,
    Iterable<String> columnHeaders,
) {
  final initialValue = List.filled(rows.first.length, []);
  final columns = rows.fold<Iterable<Iterable<dynamic>>>(
    initialValue,
    (columns, row) => zip([columns, row.map((el) => [el])])
        .map((pair) => [...pair.first, ...pair.last]),
  );
  return zip([columnHeaders, columns])
      .map((seriesData) => Series(seriesData.first, seriesData.last));
}

Iterable<Iterable<dynamic>> convertSeriesToRows(Iterable<Series> series) sync* {
  final iterators = series.map((series) => series.data.iterator);
  final areIteratorsActive = () =>
      iterators
          .fold(true, (isActive, iterator) => isActive && iterator.moveNext());

  while (areIteratorsActive()) {
    yield iterators.map((iterator) => iterator.current);
  }
}