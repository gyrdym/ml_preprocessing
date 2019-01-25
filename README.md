[![Build Status](https://travis-ci.com/gyrdym/ml_algo.svg?branch=master)](https://travis-ci.com/gyrdym/ml_preprocessing)
[![pub package](https://img.shields.io/pub/v/ml_preprocessing.svg)](https://pub.dartlang.org/packages/ml_preprocessing)
[![Gitter Chat](https://badges.gitter.im/gyrdym/gyrdym.svg)](https://gitter.im/gyrdym/)

# ml_preprocessing
Implementation of popular data preprocessing algorithms for Machine learning

The library contains:
- A data container [`Float32x4CsvMlData`](https://github.com/gyrdym/ml_preprocessing/blob/master/lib/float32x4_csv_ml_data.dart).
This entity makes work with csv data easier: you just need to point, where your dataset resides and then get features 
and labels in convenient data science friendly format. As you see, the data container converts data into sequence of 
numbers of [Float32x4](https://api.dartlang.org/stable/2.1.0/dart-typed_data/Float32x4-class.html) 
type, which makes machine learning process [faster](https://www.dartlang.org/articles/dart-vm/simd);

- Intercept preprocessor [`Float32x4nterceptPreprocessor`](https://github.com/gyrdym/ml_preprocessing/blob/master/lib/float32x4_intercept_preprocessor.dart)
This preprocessor adds an intercept to a given matrix. Intercept is a kind of 'bias' for hyperline equation.