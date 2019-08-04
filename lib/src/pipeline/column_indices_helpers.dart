import 'package:quiver/iterables.dart';

int getOriginalIndexByExpanded(
    int index,
    Iterable<Iterable<int>> expandedColumnIds,
    ) {
  if (expandedColumnIds?.isNotEmpty == false) {
    return index;
  }
  return enumerate(expandedColumnIds)
      .firstWhere((indexed) => indexed.value.contains(index))
      .index;
}

Iterable<Iterable<int>> shiftExpandedColumnIndices(
    Iterable<Iterable<int>> sourceMapping,
    int origIndex,
    int expandedIndex,
    int shift,
) {
  return enumerate(sourceMapping).map((indexed) {
    final index = indexed.index;
    final expandedIndices = indexed.value;
    if (index == origIndex) {
      return count(expandedIndex).take(shift);
    }
    if (index > origIndex) {
      return expandedIndices.map((idx) => idx + shift);
    }
    return expandedIndices;
  });
}