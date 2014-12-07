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
colorset = varycolor(max(c));
for label = 1:max(c)
    xl = xr(c == label, :);
    scatter3(xl(:, 1), xl(:, 2), xl(:, 3), 30, colorset(label, :)); hold on;
end % for label
grid off; hold off;
xlabel('PC 1', 'FontSize', 14);
ylabel('PC 2', 'FontSize', 14);
zlabel('PC 3', 'FontSize', 14);
leg = legend('C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C9', ...
             'C10', 'C11', 'C12', 'location', 'best', 'FontSize', 24);
set(leg, 'FontSize', 14);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
set(gca,'ZTickLabel','');
title('PCA cluster visualization', 'FontSize', 18);

fprintf('Clusters plotted in %.2f sec\n', toc);