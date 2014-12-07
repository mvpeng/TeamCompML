% Use
%   Runs PCA for 3-D cluster visualization based on k-means clustering 
%   (with k = 12).

clear; close all; clc;

% constants
DATAFILE = '../lolapi/training_full_v3.csv';
KMEANS_DATAFILE = 'results-kfold-training-full-3';
OFFSET = 4;
K_VALUE = 12;
KMEANS_INDEX = K_VALUE - OFFSET;
NDIM_VIZ = 3;

% load dataset and k-means results
dataset = csvread(DATAFILE, 1, 0);
x = dataset(:, 2:end);
y = dataset(:, 1);

kmeansModel = load(KMEANS_DATAFILE);
mu = kmeansModel.results{KMEANS_INDEX}.mu;

% run PCA to get 3 principal components
[xr, basis] = myPCA(x, NDIM_VIZ);

% get team composition-based features and labels
tic; c = getClusterLabels(x, mu);
fprintf('Cluster labeling done in %.2f sec\n', toc);

% plot stuff
tic; figure;
for label = 1:max(c)
    xl = xr(c == label, :);
    scatter3(xl(:, 1), xl(:, 2), xl(:, 3)); hold on;
end % for label
fprintf('Clusters plotted in %.2f sec\n', toc); hold off;