import 'package:quiver/iterables.dart';

class DataSelector {
  DataSelector(
      Iterable<int> columnIndices,
      Iterable<String> columnNames,
      Iterable<String> header
  ) : _columnIndices = columnIndices ?? enumerate(header)
      .where((indexed) => columnNames.contains(indexed.value))
      .map((indexed) => indexed.index);

  final Iterable<int> _columnIndices;

  Iterable<Iterable<dynamic>> select(List<List<dynamic>> data) =>
      data.map((row) => enumerate(row)
        .where((indexed) => _columnIndices.contains(indexed.index)));
}
