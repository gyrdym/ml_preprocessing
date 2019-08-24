import 'dart:async';

import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/pipeable/label_encode.dart';
import 'package:ml_preprocessing/src/encoder/pipeable/one_hot_encode.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline.dart';

Future main() async {
  final dataFrame = await fromCsv('example/dataset.csv',
      columns: [0, 1, 2, 3]);

  final pipeline = Pipeline(dataFrame, [
    oneHotEncode(
      columnNames: ['position'],
      headerPostfix: '_position',
    ),
    labelsEncode(
      columnNames: ['country'],
    ),
  ]);

  print(pipeline.process(dataFrame).toMatrix());
}
