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

In this library, all the data preprocessing operations are narrowed to just one entity - `DataFrame`.

## DataFrame
[`DataFrame`](https://github.com/gyrdym/ml_preprocessing/blob/master/lib/src/data_frame/data_frame.dart) is a
factory, that creates instances of different adapters for data. For example, one can create a csv reader, that makes 
work with csv data easier: it's just needed to point, where a dataset resides and then get features and labels in 
convenient data science friendly format. Also one can specify, how to treat categorical data.

## A simple usage example
Let's download some data from [Kaggle](https://www.kaggle.com) - let it be amazing [black friday](https://www.kaggle.com/mehdidag/black-friday) 
dataset. It's pretty interesting data with huge amount of observations (approx. 538000 rows) and a good number of 
categorical features.

First, import all necessary libraries:

````dart
import 'package:ml_preprocessing/ml_preprocessing.dart';
import 'package:xrange/zrange.dart';
````

Then, we should read the csv and create a data frame:

````dart
final dataFrame = DataFrame.fromCsv('example/black_friday/black_friday.csv',
  labelName: 'Purchase\r',
  columns: [ZRange.closed(2, 3), ZRange.closed(5, 7), ZRange.closed(11, 11)],
  rows: [ZRange.closed(0, 20)],
  categories: {
    'Gender': CategoricalDataEncoderType.oneHot,
    'Age': CategoricalDataEncoderType.oneHot,
    'City_Category': CategoricalDataEncoderType.oneHot,
    'Stay_In_Current_City_Years': CategoricalDataEncoderType.oneHot,
    'Marital_Status': CategoricalDataEncoderType.oneHot,
  },
);
````

Apparently, it is needed to explain input parameters. 

- **labelName** - name of a column, that contains dependant variables
- **columns** - a set of intervals, representing which columns one needs to read
- **rows** - the same as **columns**, but in this case it's being described, which rows one needs to read
- **categories** - columns, which contains categorical data, and encoders we want these columns to be 
processed with. In this particular case we want to encode all the categorical columns with [one-hot encoder](https://en.wikipedia.org/wiki/One-hot)

It's time to take a look at our processed data! Let's read it:

````dart
final features = await dataFrame.features;
final labels = await = dataFrame.labels;

print(features);
print(labels);
```` 

In output we will see just numerical data, that's exactly we wanted to reach.
