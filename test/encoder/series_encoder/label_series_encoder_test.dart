import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/unknown_value_handling_type.dart';
import 'package:test/test.dart';

void main() {
  group('LabelSeriesEncoder', () {
    test('should encode given series, creating a collection of new series', () {
      final series = Series('just_header', ['q', '2ee', '0030', '123']);
      final encoder = LabelSeriesEncoder(series);
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(1));
      expect(encoded[0].data, equals([0, 1, 2, 3]));
      expect(encoded[0].isDiscrete, isTrue);
    });

    test('should use source series header as a header of encoded one if '
        'neither header prefix nor header postfix are specified', () {
      final series = Series('just_header', ['q', '2ee', '0030', '123']);
      final encoder = LabelSeriesEncoder(series);
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(1));
      expect(encoded[0].name, 'just_header');
      expect(encoded[0].isDiscrete, isTrue);
    });

    test('should encode given series with repeating values', () {
      final series = Series('just_header',
          ['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = LabelSeriesEncoder(series);
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(1));
      expect(encoded[0].data, equals([0, 1, 0, 0, 2, 3, 2]));
      expect(encoded[0].isDiscrete, isTrue);
    });

    test('should consider given series name prefix', () {
      final series = Series('just_header',
          ['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = LabelSeriesEncoder(series, headerPrefix: 'pref_');
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(1));
      expect(encoded[0].name, 'pref_just_header');
      expect(encoded[0].isDiscrete, isTrue);
    });

    test('should consider given series name postfix', () {
      final series = Series('just_header',
          ['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = LabelSeriesEncoder(series, headerPostfix: '_postf');
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(1));
      expect(encoded[0].name, 'just_header_postf');
      expect(encoded[0].isDiscrete, isTrue);
    });

    test('should consider both given series name postfix and series name '
        'prefix', () {
      final series = Series('just_header',
          ['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = LabelSeriesEncoder(series,
          headerPrefix: 'pref_',
          headerPostfix: '_postf'
      );
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(1));
      expect(encoded[0].name, 'pref_just_header_postf');
      expect(encoded[0].isDiscrete, isTrue);
    });

    test('should use fitted data to encode new one', () {
      final fittingData = Series('just_header',
          ['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = LabelSeriesEncoder(fittingData,
          headerPrefix: 'pref_',
          headerPostfix: '_postf'
      );

      final newData = Series('just_header',
          ['q', 'q', 'q', 'q', '2ee', '2ee', '0030', 'q', '0030']);
      final encoded = encoder.encodeSeries(newData).toList();

      expect(encoded, hasLength(1));
      expect(encoded[0].data, equals([0, 0, 0, 0, 1, 1, 2, 0, 2]));
      expect(encoded[0].isDiscrete, isTrue);
    });

    test('should throw error if unknown value handling startegy is to throw '
        'error and unknown value is encountered', () {
      final fittingData = Series('just_header',
          ['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = LabelSeriesEncoder(fittingData,
          unknownValueHandlingType: UnknownValueHandlingType.error);
      final unknownValue = 'unknown_value';
      final newData = Series('awesome_series',
          ['q', 'q', 'q', unknownValue, '2ee', '2ee', '0030', 'q', '0030']);

      final actual = () => encoder
          .encodeSeries(newData)
          .map((series) => series.data.toList());

      expect(actual, throwsException);
    });

    test('should encode unknown value as last index of all labels if unknown '
        'value handling startegy is to ignore and unknown value is '
        'encountered', () {
      final fittingData = Series('just_header',
          ['q', '2ee', 'q', 'q', '0030', '123', '0030']);
      final encoder = LabelSeriesEncoder(fittingData,
          unknownValueHandlingType: UnknownValueHandlingType.ignore);
      final unknownValue = 'unknown_value';
      final newData = Series('awesome_series',
          ['q', 'q', 'q', unknownValue, '2ee', '2ee', '0030', 'q', '0030']);
      final encoded = encoder.encodeSeries(newData).toList();

      expect(encoded, hasLength(1));
      expect(encoded[0].data, equals([0, 0, 0, 4, 1, 1, 2, 0, 2]));
      expect(encoded[0].isDiscrete, isTrue);
    });
  });
}
