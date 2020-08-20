import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/encoder_type.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/label_series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/one_hot_series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/series_encoder_factory_impl.dart';
import 'package:test/test.dart';

void main() {
  group('SeriesEncoderFactoryImpl', () {
    final factory = const SeriesEncoderFactoryImpl();
    final series = Series(
      'some_series',
      <String>['value_1', 'value_2', 'value_3'],
      isDiscrete: true,
    );

    test('should create LabelSeriesEncoder', () {
      final encoderType = EncoderType.label;
      final actual = factory.createByType(encoderType, series);
      final expected = isA<LabelSeriesEncoder>();

      expect(actual, expected);
    });

    test('should create OneHotSeriesEncoder', () {
      final encoderType = EncoderType.oneHot;
      final actual = factory.createByType(encoderType, series);
      final expected = isA<OneHotSeriesEncoder>();

      expect(actual, expected);
    });

    test('should throw exception if null is unknown encoder type is '
        'provided', () {
      final actual = () => factory.createByType(null, series);
      final expected = throwsUnsupportedError;

      expect(actual, expected);
    });
  });
}
