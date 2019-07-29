import 'dart:async';

import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/data_reader/data_reader.dart';

Future main() async {
  final reader = DataReader.csv('example/dataset.csv');

  final data = await reader.read();

  final dataFrame = DataFrame(
    data,
    headerExists: true,
    columns: [0, 1, 2, 3],
  );

  final encoded = Encoder(
    columnNameToEncodingType: {
      'position': CategoricalDataEncodingType.oneHot,
      'country': CategoricalDataEncodingType.label,
    },
  ).encode(dataFrame);

  print(encoded.encodedData.toMatrix());
}