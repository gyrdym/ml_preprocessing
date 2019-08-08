import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';

typedef ColumnHeaderTemplateFn = String Function(String label);

abstract class Encoder {
  factory Encoder.oneHot({
    Iterable<int> columns,
    Iterable<String> columnNames,
    String headerPrefix,
    String headerPostfix,
  }) => EncoderImpl(
    OneHotSeriesEncoder(
        headerPrefix: headerPrefix,
        headerPostfix: headerPostfix,
    ),
    columnNames: columnNames,
    columns: columns,
  );

  factory Encoder.label({
    Iterable<int> columns,
    Iterable<String> columnNames,
    String headerPrefix,
    String headerPostfix,
  }) => EncoderImpl(
    LabelSeriesEncoder(
      headerPrefix: headerPrefix,
      headerPostfix: headerPostfix,
    ),
    columnNames: columnNames,
    columns: columns,
  );

  DataFrame encode(DataFrame data);
}
