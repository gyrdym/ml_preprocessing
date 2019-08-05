import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:quiver/collection.dart';
import 'package:quiver/iterables.dart';

BiMap<String, int> getColumnIdByLabelMapping(Series series) => BiMap()
    ..addAll(
        Map.fromIterable(
          enumerate(Set.from(series.data)),
          key: (indexed) => indexed.value,
          value: (indexed) => indexed.index,
        )
    );
