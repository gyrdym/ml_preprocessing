import 'package:ml_linalg/dtype.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:ml_preprocessing/src/dataframe/dataframe.dart';
import 'package:quiver/iterables.dart';

class DataFrameImpl implements DataFrame {
  DataFrameImpl(this._data, {
    bool headerExists = true,
    DType dtype,
  }) :
        header = headerExists
            ? _data.first.map((name) => name.toString().trim())
            : [],
        _typedData = null,
        _dtype = dtype ?? DType.float32;

  DataFrameImpl.fromMatrix(this._typedData, {
    this.header,
    DType dtype,
  }) :
        _data = null,
        _dtype = dtype ?? DType.float32;

  final DType _dtype;
  final Iterable<Iterable<dynamic>> _data;
  final Matrix _typedData;

  @override
  final Iterable<String> header;

  @override
  final Iterable<IndexedValue<Iterable<dynamic>>> rows;

  @override
  Matrix toMatrix() => _typedData;
}
