import 'package:ml_linalg/range.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:tuple/tuple.dart';

Future processDataSetWithCategoricalData() async {
  final dataFrame = DataFrame.fromCsv('example/black_friday/black_friday.csv',
    labelName: 'Purchase\r',
    columns: [const Tuple2(2, 3), const Tuple2(5, 7), const Tuple2(11, 11)],
    rows: [const Tuple2(0, 20)],
    categoryNameToEncoder: {
      'Gender': CategoricalDataEncoderType.oneHot,
      'Age': CategoricalDataEncoderType.oneHot,
      'City_Category': CategoricalDataEncoderType.oneHot,
      'Stay_In_Current_City_Years': CategoricalDataEncoderType.oneHot,
      'Marital_Status': CategoricalDataEncoderType.oneHot,
    },
  );

  final features = await dataFrame.features;
  final genderEncoded = features.submatrix(columns: Range(0, 2));
  final ageEncoded = features.submatrix(columns: Range(2, 9));
  final cityCategoryEncoded = features.submatrix(columns: Range(9, 12));
  final stayInCityEncoded = features.submatrix(columns: Range(12, 17));
  final maritalStatusEncoded = features.submatrix(columns: Range(17, 19));

  print('Features:');

  print(features);

  print('feature matrix dimensions: ${features.rowsNum} x '
      '${features.columnsNum};');

  print('==============================');

  print('Gender:');
  print(genderEncoded);

  print('==============================');

  print('Age');
  print(ageEncoded);

  print('==============================');

  print('City category');
  print(cityCategoryEncoded);

  print('==============================');

  print('Stay in current city (years)');
  print(stayInCityEncoded);

  print('==============================');

  print('Martial status');
  print(maritalStatusEncoded);
}

Future main() async {
  await processDataSetWithCategoricalData();
}
