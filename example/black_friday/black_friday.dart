import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:xrange/zrange.dart';

Future processDataSetWithCategoricalData() async {
  final dataFrame = DataFrame.fromCsv('example/black_friday/black_friday.csv',
    labelName: 'Purchase\r',
    columns: [ZRange.closed(2, 3), ZRange.closed(5, 7), ZRange.closed(11, 11)],
    rows: [ZRange.closed(0, 20)],
    categories: {
      'Gender': CategoricalDataEncoderType.oneHot,
      'Age': CategoricalDataEncoderType.oneHot,
      'City_Category': CategoricalDataEncoderType.oneHot,
      'Stay_In_Current_City_Years': CategoricalDataEncoderType.oneHot,
      'Marital_Status': CategoricalDataEncoderType.oneHot,
    },
  );

  final features = await dataFrame.features;
  final genderEncoded = features.submatrix(columns: ZRange.closed(0, 1));
  final ageEncoded = features.submatrix(columns: ZRange.closed(2, 8));
  final cityCategoryEncoded = features.submatrix(columns: ZRange.closed(9, 11));
  final stayInCityEncoded = features.submatrix(columns: ZRange.closed(12, 16));
  final maritalStatusEncoded = features
      .submatrix(columns: ZRange.closed(17, 18));

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

  print('Marital status');
  print(maritalStatusEncoded);
}

Future main() async {
  await processDataSetWithCategoricalData();
}
