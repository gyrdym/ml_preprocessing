# Changelog

## 5.0.2
- `xrange` dependency removed
- `ml_dataframe` 0.0.11 supported

## 5.0.1
- `xrange` package version locked

## 5.0.0
- `Encoder` interface changed: there is no more `encode` method, use `process` from `Pipeable` instead
- `Normalizer` entity added
- `normalize` operator added

## 4.0.0
- `DataFrame` class split up into separate smaller entities
- `DataFrame` class core moved to separate repository
- `Pipeline` entity created
- Categorical data encoders implemented `Pipeable` interface

## 3.4.0
- `DataFrame`: `encodedColumnRanges` added

## 3.3.0
- `ml_linalg` 10.0.0 supported

## 3.2.0
- `ml_linalg` 9.0.0 supported

## 3.1.0
- `Categorical data processing`: `encoders` parameter added to `DataFrame.fromCsv` constructor

## 3.0.0
- `xrange` library supported: it's possible to provide `ZRange` object now instead of `tuple2` to specify a range of 
indices 

## 2.0.0
- `DataFrame` introduced

## 1.1.0
- `Float32x4InterceptPreprocessor` added
- `readme` updated

## 1.0.0
- Package published