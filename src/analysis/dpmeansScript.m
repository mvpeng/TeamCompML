% Use
%   Script to run k-means with cross validation over a given range of
%   k-values.

clear; close all; clc;

% constants
DATAFILE = '../lolapi/training_full_v3.csv';
TRAIN_PROP = 0.9;
LAMBDA = (1 + sqrt(5)); % ~9 clusters
% LAMBDA = 3; % ~13 clusters
% LAMBDA = 2.9; % ~15 clusters

% load training data
X = csvread(DATAFILE, 1, 1);
nData = size(X, 1);
nTrain = floor(TRAIN_PROP * nData);    

XPerm = X(randperm(nData), :);
XTrain = XPerm(1:nTrain, :);
XTest = XPerm(nTrain + 1:end, :);

% run DP-means
[c, mu, k] = myDPMeans(XTrain, XTest, LAMBDA);