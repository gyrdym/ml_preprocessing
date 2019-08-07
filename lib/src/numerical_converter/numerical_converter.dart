import 'package:ml_preprocessing/ml_preprocessing.dart';

abstract class NumericalConverter {
  DataFrame convertDataFrame(DataFrame data);
  Iterable<Iterable<double>> convertRawData(Iterable<Iterable<dynamic>> data);
}
