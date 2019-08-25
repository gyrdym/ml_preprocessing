import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/src/encoder/series_encoder/one_hot_series_encoder.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';
import 'package:test/test.dart';

void main() {
  group('OneHotSeriesEncoder', () {
    test('should encode given series, creating a collection of new series', () {
      final series = Series('just_header',
          <dynamic>['q', '2ee', '0030', '123']);
      final encoder = OneHotSeriesEncoder(series);
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(4));

      expect(encoded[0].data, equals([1, 0, 0, 0]));
      expect(encoded[1].data, equals([0, 1, 0, 0]));
      expect(encoded[2].data, equals([0, 0, 1, 0]));
      expect(encoded[3].data, equals([0, 0, 0, 1]));

      expect(encoded[0].isDiscrete, isTrue);
      expect(encoded[1].isDiscrete, isTrue);
      expect(encoded[2].isDiscrete, isTrue);
      expect(encoded[3].isDiscrete, isTrue);
    });

    test('should use categorical value as a encoded series headers if neither '
        'header prefix nor header postfix are specified', () {
      final series = Series('just_header',
          <dynamic>['q', '2ee', '0030', '123']);
      final encoder = OneHotSeriesEncoder(series);
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(4));

      expect(encoded[0].name, 'q');
      expect(encoded[1].name, '2ee');
      expect(encoded[2].name, '0030');
      expect(encoded[3].name, '123');

      expect(encoded[0].isDiscrete, isTrue);
      expect(encoded[1].isDiscrete, isTrue);
      expect(encoded[2].isDiscrete, isTrue);
      expect(encoded[3].isDiscrete, isTrue);
    });

    test('should encode given series with repeating values', () {
      final series = Series('just_header',
          <dynamic>['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = OneHotSeriesEncoder(series);
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(4));

      expect(encoded[0].data, equals([1, 0, 1, 1, 0, 0, 0]));
      expect(encoded[1].data, equals([0, 1, 0, 0, 0, 0, 0]));
      expect(encoded[2].data, equals([0, 0, 0, 0, 1, 0, 1]));
      expect(encoded[3].data, equals([0, 0, 0, 0, 0, 1, 0]));

      expect(encoded[0].isDiscrete, isTrue);
      expect(encoded[1].isDiscrete, isTrue);
      expect(encoded[2].isDiscrete, isTrue);
      expect(encoded[3].isDiscrete, isTrue);
    });

    test('should consider given series name prefix', () {
      final series = Series('just_header',
          <dynamic>['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = OneHotSeriesEncoder(series, headerPrefix: 'pref_');
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(4));

      expect(encoded[0].name, 'pref_q');
      expect(encoded[1].name, 'pref_2ee');
      expect(encoded[2].name, 'pref_0030');
      expect(encoded[3].name, 'pref_123');

      expect(encoded[0].isDiscrete, isTrue);
      expect(encoded[1].isDiscrete, isTrue);
      expect(encoded[2].isDiscrete, isTrue);
      expect(encoded[3].isDiscrete, isTrue);
    });

    test('should consider given series name postfix', () {
      final series = Series('just_header',
          <dynamic>['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = OneHotSeriesEncoder(series, headerPostfix: '_postf');
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(4));

      expect(encoded[0].name, 'q_postf');
      expect(encoded[1].name, '2ee_postf');
      expect(encoded[2].name, '0030_postf');
      expect(encoded[3].name, '123_postf');

      expect(encoded[0].isDiscrete, isTrue);
      expect(encoded[1].isDiscrete, isTrue);
      expect(encoded[2].isDiscrete, isTrue);
      expect(encoded[3].isDiscrete, isTrue);
    });

    test('should consider both given series name postfix and series name '
        'prefix', () {
      final series = Series('just_header',
          <dynamic>['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = OneHotSeriesEncoder(series,
          headerPrefix: 'pref_',
          headerPostfix: '_postf'
      );
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(4));

      expect(encoded[0].name, 'pref_q_postf');
      expect(encoded[1].name, 'pref_2ee_postf');
      expect(encoded[2].name, 'pref_0030_postf');
      expect(encoded[3].name, 'pref_123_postf');

      expect(encoded[0].isDiscrete, isTrue);
      expect(encoded[1].isDiscrete, isTrue);
      expect(encoded[2].isDiscrete, isTrue);
      expect(encoded[3].isDiscrete, isTrue);
    });

    test('should use fitted data to encode new one', () {
      final fittingData = Series('just_header',
          <dynamic>['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = OneHotSeriesEncoder(fittingData,
          headerPrefix: 'pref_',
          headerPostfix: '_postf'
      );

      final newData = Series('just_header',
          <dynamic>['q', 'q', 'q', 'q', '2ee', '2ee', '0030', 'q', '0030']);
      final encoded = encoder.encodeSeries(newData).toList();

      expect(encoded, hasLength(4));

      expect(encoded[0].data, equals([1, 1, 1, 1, 0, 0, 0, 1, 0]));
      expect(encoded[1].data, equals([0, 0, 0, 0, 1, 1, 0, 0, 0]));
      expect(encoded[2].data, equals([0, 0, 0, 0, 0, 0, 1, 0, 1]));
      expect(encoded[3].data, equals([0, 0, 0, 0, 0, 0, 0, 0, 0]));

      expect(encoded[0].isDiscrete, isTrue);
      expect(encoded[1].isDiscrete, isTrue);
      expect(encoded[2].isDiscrete, isTrue);
      expect(encoded[3].isDiscrete, isTrue);
    });

    test('should throw error if unknown value handling startegy is to throw '
        'error and unknown value is encountered', () {
      final fittingData = Series('just_header',
          <dynamic>['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = OneHotSeriesEncoder(fittingData,
          unknownValueHandlingType: UnknownValueHandlingType.error);
      final unknownValue = 'unknown_value';
      final newData = Series('awesome_series',
          <dynamic>['q', 'q', 'q', unknownValue, '2ee', '2ee', '0030', 'q',
            '0030']);

      final actual = () => encoder
          .encodeSeries(newData)
          .map((series) => series.data.toList());

      expect(actual, throwsException);
    });

    test('should encode unknown value as 0 if unknown value handling startegy '
        'is to ignore and unknown value is encountered', () {
      final fittingData = Series('just_header',
          <dynamic>['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = OneHotSeriesEncoder(fittingData,
          unknownValueHandlingType: UnknownValueHandlingType.ignore);
      final unknownValue = 'unknown_value';
      final newData = Series('awesome_series',
          <dynamic>['q', 'q', 'q', unknownValue, '2ee', '2ee', '0030', 'q',
            '0030']);
      final encoded = encoder.encodeSeries(newData).toList();

      expect(encoded, hasLength(4));

      expect(encoded[0].data, equals([1, 1, 1, 0, 0, 0, 0, 1, 0]));
      expect(encoded[1].data, equals([0, 0, 0, 0, 1, 1, 0, 0, 0]));
      expect(encoded[2].data, equals([0, 0, 0, 0, 0, 0, 1, 0, 1]));
      expect(encoded[3].data, equals([0, 0, 0, 0, 0, 0, 0, 0, 0]));

      expect(encoded[0].isDiscrete, isTrue);
      expect(encoded[1].isDiscrete, isTrue);
      expect(encoded[2].isDiscrete, isTrue);
      expect(encoded[3].isDiscrete, isTrue);
    });
  });
}
