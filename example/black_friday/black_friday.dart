import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/data_reader/data_reader.dart';
import 'package:ml_preprocessing/src/encoder/one_hot_encoder.dart';
import 'package:ml_preprocessing/src/numerical_converter/numerical_converter.dart';
import 'package:ml_preprocessing/src/pipeline/pipeline.dart';
import 'package:xrange/zrange.dart';

Future processDataSetWithCategoricalData() async {
  final csvReader = DataReader.csv('example/black_friday/black_friday.csv');
  final data = await csvReader.read();

  final dataFrame = DataFrame(
    data,
    columns: [2, 3, 5, 6, 7, 11],
  );

  final processed = Pipeline([
    toNumber(),
    oneHotEncode(
      columnNames: ['Gender', 'Age', 'City_Category',
        'Stay_In_Current_City_Years', 'Marital_Status'],
    ),
  ]).apply(dataFrame);

  final observations = processed.toMatrix();
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
