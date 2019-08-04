import 'package:ml_preprocessing/src/encoder/categorical_data_encoder/encoding_type.dart';

abstract class EncodingMappingProcessor {
  Map<int, CategoricalDataEncodingType> getIndexToEncodingTypeMapping(
      Map<int, CategoricalDataEncodingType> columnIndexToEncodingType,
      Map<CategoricalDataEncodingType, Iterable<String>> encodingTypeToColumnName,
      Map<String, CategoricalDataEncodingType> columnNameToEncodingType,
  );
}
