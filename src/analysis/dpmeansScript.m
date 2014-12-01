% Use
%   Script to run k-means with cross validation over a given range of
%   k-values.

clear; close all; clc;

% constants
DATAFILE = '../lolapi/training_full.csv';
LAMBDA = 2;

% load training data
X = csvread(DATAFILE, 1, 1);

% run DP-means
[c, mu, k] = myDPMeans(X, LAMBDA);