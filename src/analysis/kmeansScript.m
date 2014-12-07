% Use
%   Script to run k-means with cross validation over a given range of
%   k-values.

clear; close all; clc;

% constants
DATAFILE = '../lolapi/training_full_v3.csv';
HOLDOUT = 'holdout';
KFOLD = 'kfold';
KRANGE = 5:24;

% load training data
X = csvread(DATAFILE, 1, 1);

% run k-means with hold-out cross validation
[cH, muH, distortionValueH, kH] = cvKMeans(X, KRANGE, HOLDOUT);

% run k-means with k-fold cross validation
[cK, muK, distortionValueK, kK] = cvKMeans(X, KRANGE, KFOLD);