% Use
%   Script to run k-means with cross validation over a given range of
%   k-values.

clear; close all; clc;

% constants
DATAFILE = '../lolapi/training_full_v3.csv';
LAMBDA = (1 + sqrt(5)) / 2; % ~23 clusters
% LAMBDA = 2; % ~15 clusters
% LAMBDA = 2.5; % ~8 clusters

% load training data
X = csvread(DATAFILE, 1, 1);

% run DP-means
[c, mu, k] = myDPMeans(X, LAMBDA);