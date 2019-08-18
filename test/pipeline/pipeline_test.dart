import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/pipeline/pipeable.dart';
import 'package:test/test.dart';

class Plus10Processor implements Pipeable {
  @override
  DataFrame process(DataFrame input) => DataFrame.fromSeries(
    input.series.map((series) => Series(
        series.name,
        series.data.map((value) => value + 10),
    )),
  );
}

class MultipleBy2Processor implements Pipeable {
  @override
  DataFrame process(DataFrame input) => DataFrame.fromSeries(
    input.series.map((series) => Series(
        series.name,
        series.data.map((value) => value * 2),
    )),
  );
}

void main() {
  group('Pipeline', () {
    final fittingData = DataFrame([[]], headerExists: false);

    final targetData = DataFrame([
      [20, 10, 30, 30],
      [30, 90, 20, 60],
      [40, 70, 50, 10],
    ], headerExists: false);

    test('should create a pipeline with predefined steps', () {
      final pipeline = Pipeline(fittingData, [
        (data) => Plus10Processor(),
        (data) => MultipleBy2Processor(),
      ]);

      final result = pipeline.process(targetData);

      expect(result.toMatrix(), equals([
        [60, 40, 80, 80],
        [80, 200, 60, 140],
        [100, 160, 120, 40],
      ]));
    });
  });
}
