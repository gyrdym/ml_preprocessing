import 'package:ml_preprocessing/src/categorical_data_codec/encoding_type.dart';

abstract class EncodersProcessor {
  Map<int, CategoricalDataEncodingType> getIndexToEncodingTypeMapping(
      Map<int, CategoricalDataEncodingType> columnIndexToEncodingType,
      Map<CategoricalDataEncodingType, Iterable<String>> encodingTypeToColumnName,
      Map<String, CategoricalDataEncodingType> columnNameToEncodingType,
  );
}
