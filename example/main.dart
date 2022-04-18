import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';

Future main() async {
  final dataFrame = await fromCsv('example/dataset.csv', columns: [0, 1, 2, 3]);

  final pipeline = Pipeline(dataFrame, [
    toOneHotLabels(
      columnNames: ['position'],
      headerPostfix: '_position',
    ),
    toIntegerLabels(
      columnNames: ['country'],
    ),
  ]);

  print(pipeline.process(dataFrame).toMatrix());
}
