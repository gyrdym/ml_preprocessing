import 'package:ml_linalg/dtype.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/codec_factory_impl.dart';
import 'package:ml_preprocessing/src/encoder/categorical_data_codec/encoding_type.dart';
import 'package:ml_preprocessing/src/encoder/encoder_impl.dart';
import 'package:ml_preprocessing/src/encoder/numerical_converter/numerical_converter_impl.dart';
import 'package:ml_preprocessing/src/encoder/records_processor/records_processor_factory_impl.dart';
import 'package:xrange/zrange.dart';

import 'categorical_data_codec/codec.dart';
import 'encoding_mapping_processor/mapping_processor_factory_impl.dart';

abstract class Encoder {
  /**
   * [columnNameToEncodingType] A map, that links categorical column name to
   * the encoder type, which will be used to encode this column's values. It
   * only makes sense if [headerExists] is true
   *
   * [columnIndexToEncodingType] A map, that links categorical column's index
   * to the encoder type, which will be used to encode this column's values.
   *
   * [encodingTypeToColumnNames] A map, that links categorical data encoder
   * type to the sequence of columns, which are supposed to be encoded with
   * this encoder. If one column is going to be processed at least with two
   * different encoders, an exception will be thrown
   */
  factory Encoder({
    Map<String, CategoricalDataEncodingType> columnNameToEncodingType,
    Map<int, CategoricalDataEncodingType> columnIndexToEncodingType,
    Map<CategoricalDataEncodingType, Iterable<String>> encodingTypeToColumnNames,
    DType dtype,
  }) => EncoderImpl(
    columnNameToEncodingType,
    columnIndexToEncodingType,
    encodingTypeToColumnNames,
    CategoricalDataCodecFactoryImpl(),
    NumericalConverterImpl(),
    RecordsProcessorFactoryImpl(),
    EncodingMappingProcessorFactoryImpl(),
    dtype,
  );

  EncodingDescriptor encode(DataFrame data);
}


class EncodingDescriptor {
  EncodingDescriptor(this.encodedData, this.rangeToCodec);

  final DataFrame encodedData;
  final Map<ZRange, CategoricalDataCodec> rangeToCodec;
}
