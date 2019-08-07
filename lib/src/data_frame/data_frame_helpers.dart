import 'package:ml_preprocessing/src/data_frame/series.dart';

Iterable<Series> convertRowsToSeries(
    Iterable<String> columnHeaders,
    Iterable<Iterable<dynamic>> rows,
) sync* {
  final headersIterator = columnHeaders.iterator;
  final rowIterators = rows
      .map((row) => row.iterator)
      .toList(growable: false);

  while (headersIterator.moveNext()) {
    final column = rowIterators
        .where((iterator) => iterator.moveNext())
        .map((iterator) => iterator.current);
    yield Series(headersIterator.current, column);
  }
}

Iterable<Iterable<dynamic>> convertSeriesToRows(Iterable<Series> series) sync* {
  final iterators = series
      .map((series) => series.data.iterator)
      .toList(growable: false);

  while (iterators.fold(true, (isActive, iterator) => iterator.moveNext())) {
    yield iterators.map((iterator) => iterator.current);
  }
}