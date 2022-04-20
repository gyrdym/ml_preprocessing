import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:test/test.dart';

class Plus10Processor implements Pipeable {
  @override
  DataFrame process(DataFrame input) => DataFrame.fromSeries(
        input.series.map((series) => Series(
              series.name,
              series.data.map<dynamic>((dynamic value) => value + 10),
            )),
      );
}

class MultipleBy2Processor implements Pipeable {
  @override
  DataFrame process(DataFrame input) => DataFrame.fromSeries(
        input.series.map((series) => Series(
              series.name,
              series.data.map<dynamic>((dynamic value) => value * 2),
            )),
      );
}

void main() {
  group('Pipeline', () {
    final fittingData = DataFrame([<dynamic>[]], headerExists: false);

    final targetData = DataFrame([
      <dynamic>[20, 10, 30, 30],
      <dynamic>[30, 90, 20, 60],
      <dynamic>[40, 70, 50, 10],
    ], headerExists: false);

    test('should create a pipeline with predefined steps', () {
      final pipeline = Pipeline(fittingData, [
        (data, {dtype}) => Plus10Processor(),
        (data, {dtype}) => MultipleBy2Processor(),
      ]);

      final result = pipeline.process(targetData);

      expect(
          result.toMatrix(),
          equals([
            [60, 40, 80, 80],
            [80, 200, 60, 140],
            [100, 160, 120, 40],
          ]));
    });
  });
}
