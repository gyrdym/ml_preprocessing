import 'package:ml_preprocessing/src/data_frame/series.dart';
import 'package:ml_preprocessing/src/encoder/one_hot_series_encoder.dart';
import 'package:test/test.dart';

void main() {
  group('OneHotSeriesEncoder', () {
    test('should encode given series, creating a collection of new series, '
        'where each header is a value of', () {
      final series = Series('just_header', ['q', '2ee', '0030', '123']);
      final encoder = OneHotSeriesEncoder(series);
      final encoded = encoder.encodeSeries(series).toList();

      expect(encoded, hasLength(4));

      expect(encoded[0].name, 'q');
      expect(encoded[0].data, equals([1, 0, 0, 0]));

      expect(encoded[1].name, '2ee');
      expect(encoded[1].data, equals([0, 1, 0, 0]));

      expect(encoded[2].name, '0030');
      expect(encoded[2].data, equals([0, 0, 1, 0]));

      expect(encoded[3].name, '123');
      expect(encoded[3].data, equals([0, 0, 0, 1]));
    });
  });
}
