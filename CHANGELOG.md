# Changelog

## 7.0.2
- `README.md`:
    - Fixed link to `black_friday` dataset

## 7.0.1
- Added code formatting checking step to CI pipline
- Corrected `README` examples
- Added documentation to `Encoder` factory

## 7.0.0
- `ml_datframe` 1.0.0 supported
- `featureNames` parameter renamed to `columnNames`
- `featureIds` parameter renamed to `columnIndices`
- `encodeAsIntegerLabels` renamed to `toIntegerLabels`
- `encodeAsOneHotLabels` renamed to `toOneHotLabels`

## 6.0.1
- `pubspec.yaml`: `ml_dataframe` dependency updated

## 6.0.0
- Null-safety added (stable release)

## 6.0.0-nullsafety.0
- Null-safety added (beta release)

## 5.2.2
- `ml_dataframe`: version 0.4.0 supported

## 5.2.1
- `ml_dataframe`: version 0.3.0 supported
- `CI`: github actions set up

## 5.2.0
- `UnknownValueHandlingType` enum added to the lib's public API

## 5.1.2
- `ml_dataframe` 0.2.0 supported

## 5.1.1
- `ml_dataframe` dependency updated

## 5.1.0
- `Standardizer` entity added
- `dtype` parameter added as an argument for `Pipeline.process` method

## 5.0.4
- Default values for parameters `headerPrefix` and `headerPostfix` added where it applicable

## 5.0.3
- `README` corrected (ml_dataframe version corrected)

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
