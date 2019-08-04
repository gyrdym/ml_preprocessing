import 'package:quiver/iterables.dart';

Map<String, int> getLabelToColumnIdMapping(Iterable<dynamic> data) {
  final orderedUniqueLabels = data;
  return Map.fromIterable(
    enumerate(orderedUniqueLabels),
    key: (indexed) => indexed.value,
    value: (indexed) => indexed.index,
  );
}
