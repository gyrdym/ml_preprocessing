[![Build Status](https://travis-ci.com/gyrdym/ml_algo.svg?branch=master)](https://travis-ci.com/gyrdym/ml_preprocessing)
[![Coverage Status](https://coveralls.io/repos/github/gyrdym/ml_preprocessing/badge.svg)](https://coveralls.io/github/gyrdym/ml_preprocessing)
[![pub package](https://img.shields.io/pub/v/ml_preprocessing.svg)](https://pub.dartlang.org/packages/ml_preprocessing)
[![Gitter Chat](https://badges.gitter.im/gyrdym/gyrdym.svg)](https://gitter.im/gyrdym/)

# ml_preprocessing
Data preprocessing algorithms

## What is data preprocessing?
*Data preprocessing* is a set of techniques for data preparation before one can use the data in Machine Learning algorithms.

## Why is it needed?
Let's say, you have a dataset:

````
    ----------------------------------------------------------------------------------------
    | Gender | Country | Height (cm) | Weight (kg) | Diabetes (1 - Positive, 0 - Negative) |
    ----------------------------------------------------------------------------------------
    | Female | France  |     165     |     55      |                    1                  |
    ----------------------------------------------------------------------------------------
    | Female | Spain   |     155     |     50      |                    0                  |
    ----------------------------------------------------------------------------------------
    | Male   | Spain   |     175     |     75      |                    0                  |
    ----------------------------------------------------------------------------------------
    | Male   | Russia  |     173     |     77      |                   N/A                 |
    ----------------------------------------------------------------------------------------
````

Everything seems good for now. Say, you're about to train a classifier to predict if a person has diabetes. 
But there is an obstacle - how can it possible to use the data in mathematical equations with string-value columns 
(`Gender`, `Country`)? And things are getting even worse because of an empty (N/A) value in `Diabetes` column. There 
should be a way to convert this data to a valid numerical representation. Here data preprocessing techniques come to play. 
You should decide, how to convert string data (aka *categorical data*) to numbers and how to treat empty values. Of 
course, you can come up with your own unique algorithms to do all of these operations, but, actually, there are a 
bunch of well-known well-performed techniques for doing all the conversions.      

The aim of the library - to give data scientists, who are interested in Dart programming language, these preprocessing 
techniques.

## Prerequisites

The library depends on [DataFrame class](https://github.com/gyrdym/ml_dataframe/blob/master/lib/src/data_frame/data_frame.dart) 
from the [repo](https://github.com/gyrdym/ml_dataframe). It's necessary to use it as a dependency in your project,
because you need to pack data into [DataFrame](https://github.com/gyrdym/ml_dataframe/blob/master/lib/src/data_frame/data_frame.dart)
before doing preprocessing. An example with a part of pubspec.yaml:

````
dependencies:
  ...
  ml_dataframe: ^0.0.11
  ...
````

## Usage examples

### Getting started

Let's download some data from [Kaggle](https://www.kaggle.com) - let it be amazing [black friday](https://www.kaggle.com/mehdidag/black-friday) 
dataset. It's pretty interesting data with huge amount of observations (approx. 538000 rows) and a good number of 
categorical features.

First, import all necessary libraries:

````dart
import 'package:ml_dataframe/ml_dataframe.dart';
import 'package:ml_preprocessing/ml_preprocessing.dart';
````

Then, we should read the csv and create a data frame:

````dart
final dataFrame = await fromCsv('example/black_friday/black_friday.csv', 
  columns: [2, 3, 5, 6, 7, 11]);
````

### Categorical data

After we get a dataframe, we may encode all the needed features. Let's analyze the dataset and decide, what features 
should be encoded. In our case these are:

````dart
final featureNames = ['Gender', 'Age', 'City_Category', 'Stay_In_Current_City_Years', 'Marital_Status'];
````

### One-hot encoding

Let's fit the one-hot encoder. 

Why should we fit it? Categorical data encoder fitting - a process, when all the unique category values are being 
searched for in order to create an encoded labels list. After the fitting is complete, one may use the fitted encoder for 
the new data of the same source. 

In order to fit the encoder it's needed to create the entity and pass the fitting data as an argument to the 
constructor, along with the features to be encoded:

 
````dart
final encoder = Encoder.oneHot(
  dataFrame,
  featureNames: featureNames,
);

````

Let's encode the features:

````dart
final encoded = encoder.process(dataFrame);
````

We used the same dataframe here - it's absolutely normal, since when we created the encoder, we just fit it with the 
dataframe, and now is the time to apply the dataframe to the fitted encoder.

It's time to take a look at our processed data! Let's read it:

````dart
final data = encoded.toMatrix();

print(data);
```` 

In the output we will see just numerical data, that's exactly we wanted to reach.

### Label encoding

Another one well-known encoding method. The technique is the same - first, we should fit the encoder and after that we
may use this "trained" encoder in some applications:

````dart
final encoder = Encoder.label(
  dataFrame,
  featureNames: featureNames,
);

final encoded = encoder.process(dataFrame);
````

### Numerical data normalizing

Sometimes we need to have our numerical features normalized, that means we need to treat every dataframe row as a 
vector and divide this vector element-wise by its norm (Euclidean, Manhattan, etc.). To do so the library exposes
`Normalizer` entity:

````dart
final normalizer = Normalizer(); // by default Euclidean norm will be used
final transformed = normalizer.process(dataFrame);
```` 

Please, notice, if your data has raw categorical values, the normalization will fail as it requires only numerical 
values. In this case you should encode data (e.g. using one-hot encoding) before normalization.

### Pipeline

There is a convenient way to organize a bunch of data preprocessing operations - `Pipeline`:

````dart
final pipeline = Pipeline(dataFrame, [
  encodeAsOneHotLabels(featureNames: ['Gender', 'Age', 'City_Category']),
  encodeAsIntegerLabels(featureNames: ['Stay_In_Current_City_Years', 'Marital_Status']),
  normalize(),
]);
````

Once you create (or rather fit) a pipeline, you may use it farther in your application:

````dart
final processed = pipeline.process(dataFrame);
````

`encodeAsOneHotLabels`, `encodeAsIntegerLabels` and `normalize` are pipeable operator functions. Pipeable operator 
function is a factory, that takes fitting data and creates a fitted pipeable entity (e.g., `Normalizer` instance)  