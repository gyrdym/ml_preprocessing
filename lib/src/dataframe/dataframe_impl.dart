import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe.dart';

class DataFrameImpl implements DataFrame {
  DataFrameImpl.fromMatrix(this._data, this.header, {
      DType dtype,
    }) : _dtype = dtype ?? DType.float32;

  final DType _dtype;
  final Matrix _data;

  @override
  final Iterable<String> header;

  @override
  Matrix toMatrix() => _data;

  @override
  Map<Vector, String> getEncodingTableByColumnId(int id) {
    // TODO: implement getEncodingTableByColumnId
    return null;
  }

  @override
  Map<Vector, String> getEncodingTableByColumnName(String name) {
    // TODO: implement getEncodingTableByColumnName
    return null;
  }
}
