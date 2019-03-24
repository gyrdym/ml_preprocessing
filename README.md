[![Build Status](https://travis-ci.com/gyrdym/ml_algo.svg?branch=master)](https://travis-ci.com/gyrdym/ml_preprocessing)
[![Coverage Status](https://coveralls.io/repos/github/gyrdym/ml_preprocessing/badge.svg)](https://coveralls.io/github/gyrdym/ml_preprocessing)
[![pub package](https://img.shields.io/pub/v/ml_preprocessing.svg)](https://pub.dartlang.org/packages/ml_preprocessing)
[![Gitter Chat](https://badges.gitter.im/gyrdym/gyrdym.svg)](https://gitter.im/gyrdym/)

# ml_preprocessing

Data preprocessing algorithms in Dart

## What is data preprocessing?

*Data preprocessing* is a set of techniques for data preparation before one can use the data in Machine Learning algorithms.

## Why does it needed?

Let's say, you have a dataset:

````
    ----------------------------------------------------------------------------------------
    | Gender | Country | Height (cm) | Weight (kg) | Diabetes (1 - Positive, 0 - Negative) |
    ----------------------------------------------------------------------------------------
    | Female | French  |     165     |     55      |                    1                  |
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
should be a way to convert this data to a valid numeric representation. Here data preprocessing techniques come to play. 
You should decide, how to convert string data (aka *categorical data*) to numbers and how to treat empty values. Of 
course, you can come up with your own unique algorithms to do all of these operations, but, actually, there are a 
bunch of well-known well-performed techniques for doing all the conversions.      

## [`DataFrame`](https://github.com/gyrdym/ml_preprocessing/blob/master/lib/src/data_frame/data_frame.dart)
Factory, that creates instances of different adapters for data. For example, one can create a csv reader, that makes 
work with csv data easier: it's just needed to point, where a dataset resides and then get features and labels in 
convenient data science friendly format.