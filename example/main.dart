import 'dart:async';

import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:xrange/zrange.dart';

Future main() async {
  // Let's create data frame from a csv file,
  //
  // `labelIdx: 3` means that the label (dependent variable in terms of
  // Machine Learning) column of the dataset is its third column
  //
  // `headerExists: true` means, that our csv-file has a header row
  //
  // `categories: {...}` means, that we want to encode values of
  // `position`-column with one-hot encoder and column `country` will be
  // encoded with Ordinal encoder
  //
  // `rows: [Tuple2<int, int>(0, 6)]` means, that we want to read range of the
  // csv's rows from 0 to 6th
  //
  // `columns: [Tuple2<int, int>(0, 3)]` means, that we want to read range of
  // the csv's columns from 0 to third columns
  final preprocessor = Preprocessor.csv('example/dataset.csv', labelIdx: 3,
    headerExists: true,
    categories: {
      'position': CategoricalDataEncodingType.oneHot,
      'country': CategoricalDataEncodingType.ordinal,
    },
    rows: [ZRange.closed(0, 6)],
    columns: [ZRange.closed(0, 3)],
  );

  // Let's read the processed dataset
  final dataSet = await preprocessor.data;

  // And print the result
  print(dataSet.toMatrix());

  // That's, actually, all you have to do to use the data further in different
  // applications
}