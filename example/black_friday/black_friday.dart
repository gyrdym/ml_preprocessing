import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:xrange/zrange.dart';

Future processDataSetWithCategoricalData() async {
  final dataFrame = await fromCsv('example/black_friday/black_friday.csv',
    columns: [2, 3, 5, 6, 7, 11],
  );

  final encoded = Encoder.oneHot(
    dataFrame,
    columnNames: ['Gender', 'Age', 'City_Category',
      'Stay_In_Current_City_Years', 'Marital_Status'],
  ).encode(dataFrame);

  final observations = encoded.toMatrix();
  final genderEncoded = observations.submatrix(columns: ZRange.closed(0, 1));
  final ageEncoded = observations.submatrix(columns: ZRange.closed(2, 8));
  final cityCategoryEncoded = observations
      .submatrix(columns: ZRange.closed(9, 11));
  final stayInCityEncoded = observations
      .submatrix(columns: ZRange.closed(12, 16));
  final maritalStatusEncoded = observations
      .submatrix(columns: ZRange.closed(17, 18));

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
