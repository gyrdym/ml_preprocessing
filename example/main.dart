import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/encode_as_integer_labels.dart';
import 'package:ml_preprocessing/src/encoder/encode_as_one_hot_labels.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline.dart';

Future main() async {
  final dataFrame = await fromCsv('example/dataset.csv',
      columns: [0, 1, 2, 3]);

  final pipeline = Pipeline(dataFrame, [
    encodeAsOneHotLabels(
      featureNames: ['position'],
      headerPostfix: '_position',
    ),
    encodeAsIntegerLabels(
      featureNames: ['country'],
    ),
  ]);

  print(pipeline.process(dataFrame).toMatrix());
}
