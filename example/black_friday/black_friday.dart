import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';

Future processDataSetWithCategoricalData() async {
  final dataFrame = await fromCsv(
    'example/black_friday/black_friday.csv',
    columnNames: [
      'Gender',
      'Age',
      'City_Category',
      'Stay_In_Current_City_Years',
      'Marital_Status'
    ],
  );

  final encoded = Encoder.oneHot(
    dataFrame,
    columnNames: [
      'Gender',
      'Age',
      'City_Category',
      'Stay_In_Current_City_Years',
      'Marital_Status'
    ],
  ).process(dataFrame);

  final observations = encoded.toMatrix();
  final genderEncoded = observations.sample(columnIndices: [0, 1]);
  final ageEncoded = observations.sample(columnIndices: [2, 3, 4, 5, 6, 7, 8]);
  final cityCategoryEncoded = observations.sample(columnIndices: [9, 10, 11]);
  final stayInCityEncoded =
      observations.sample(columnIndices: [12, 13, 14, 15, 16]);
  final maritalStatusEncoded = observations.sample(columnIndices: [17, 18]);

  print('Features:');

  print(observations);

  print('feature matrix dimensions: ${observations.rowsNum} x '
      '${observations.columnsNum};');

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
