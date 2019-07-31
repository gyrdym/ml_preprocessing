import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoder.dart';

class CategoricalDataEncoderImpl implements CategoricalDataEncoder {
  CategoricalDataEncoderImpl(Iterable<dynamic> labels, EncodeLabelFn encodeLabel)
      : _originalToEncoded = ((){
          final uniqueLabels = Set<String>.from(labels).toList(growable: false);
          final entries = labels.map((label) =>
              MapEntry(
                  label.toString(),
                  encodeLabel(label.toString(), uniqueLabels)
              ),
          );
          return Map.fromEntries(entries);
        })();

  final Map<String, Iterable<num>> _originalToEncoded;

  @override
  Iterable<Iterable<num>> encode(Iterable<String> values) =>
      values.map((value) => _originalToEncoded[value]);
}
