import 'dart:async';

import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/label_encode.dart';
import 'package:ml_preprocessing/src/encoder/one_hot_encode.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline.dart';

Future main() async {
  final dataFrame = await fromCsv('example/dataset.csv',
      columns: [0, 1, 2, 3]);

  final pipeline = Pipeline(dataFrame, [
    encodeAsOneHotLabels(
      columnNames: ['position'],
      headerPostfix: '_position',
    ),
    encodeAsIntegerLabels(
      columnNames: ['country'],
    ),
  ]);

  print(pipeline.process(dataFrame).toMatrix());
}
