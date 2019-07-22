import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:xrange/zrange.dart';

Future processDataSetWithCategoricalData() async {
  final dataFrame = Preprocessor.csv('example/black_friday/black_friday.csv',
    labelName: 'Purchase\r',
    columns: [ZRange.closed(2, 3), ZRange.closed(5, 7), ZRange.closed(11, 11)],
    rows: [ZRange.closed(0, 20)],
    columnNameToEncodingType: {
      'Gender': CategoricalDataEncodingType.oneHot,
      'Age': CategoricalDataEncodingType.oneHot,
      'City_Category': CategoricalDataEncodingType.oneHot,
      'Stay_In_Current_City_Years': CategoricalDataEncodingType.oneHot,
      'Marital_Status': CategoricalDataEncodingType.oneHot,
    },
  );

  final observations = (await dataFrame.data).toMatrix();
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
