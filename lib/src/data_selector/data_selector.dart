import 'package:quiver/iterables.dart';

class DataSelector {
  DataSelector(
      Iterable<int> columnIndices,
      Iterable<String> columnNames,
      Iterable<String> header
  ) : _columnIndices = columnIndices ?? enumerate(header)
      .where((indexed) => columnNames?.isNotEmpty == true
        ? columnNames.contains(indexed.value)
        : true)
      .map((indexed) => indexed.index);

  final Iterable<int> _columnIndices;

  Iterable<Iterable<dynamic>> select(Iterable<Iterable<dynamic>> data) =>
    _columnIndices.isEmpty
        ? data
        : data.map((row) =>
            enumerate(row)
                .where((indexed) => _columnIndices.contains(indexed.index))
                .map((indexed) => indexed.value));
}
