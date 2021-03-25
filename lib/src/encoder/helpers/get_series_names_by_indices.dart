import 'package:quiver/iterables.dart';

Iterable<String> getSeriesNamesByIndices(
    Iterable<String> seriesNames,
    Iterable<int> indices) {
  final uniqueIndices = Set<int>.from(indices);

  return enumerate(seriesNames)
      .where((indexedName) => uniqueIndices.contains(indexedName.index))
      .map((indexedValue) => indexedValue.value);
}
