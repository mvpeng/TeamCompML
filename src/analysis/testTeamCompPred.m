% Use
%   Test predictor accuracies.

clear; close all; clc;

% load testing data
fprintf('Loading testing data...');
DATAFILE = '../lolapi/testing_v3.csv';
testset = csvread(DATAFILE, 1, 0);
xTest = testset(:, 2:end);
yTest = testset(:, 1);
fprintf('done\n');

% get predictors
fprintf('Training predictors...\n'); tic;
[predKS, ~, muKS] = runTeamCompPred('kmeans', 'svm');
[predKG, ~, muKG] = runTeamCompPred('kmeans', 'gda');
[predDS, ~, muDS] = runTeamCompPred('dpmeans', 'svm');
[predDG, ~, muDG] = runTeamCompPred('dpmeans', 'gda');
fprintf('Predictors trained in %.2f sec\n', toc);

% get features from testset data
fprintf('Extracting features from testset data...');
[xKS, yKS] = clusterLabelsToFeatures(getClusterLabels(xTest, muKS), yTest);
[xKG, yKG] = clusterLabelsToFeatures(getClusterLabels(xTest, muKG), yTest);
[xDS, yDS] = clusterLabelsToFeatures(getClusterLabels(xTest, muDS), yTest);
[xDG, yDG] = clusterLabelsToFeatures(getClusterLabels(xTest, muDG), yTest);
fprintf('done\n');

% get accuracies from predictors
accKS = sum(predKS(xKS) == yKS) / length(yKS);
accKG = sum(predKG(xKG) == yKG) / length(yKG);
accDS = sum(predDS(xDS) == yDS) / length(yDS);
accDG = sum(predDG(xDG) == yDG) / length(yDG);

fprintf('Predictor accuracies:\n');
fprintf('%10s\t%10s\t%10s\t%10s\n', ...
        'kmeans, svm', 'kmeans, gda', 'dpmeans, svm', 'dpmeans, gda');
fprintf('%s\n',repmat('-', 70, 1));
fprintf('%10.4f\t%10.4f\t%10.4f\t%10.4f\n', accKS, accKG, accDS, accDG);