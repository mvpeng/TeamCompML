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
fprintf('Training predictors...\n'); startTime = tic;
[predKS, ~, muKS] = runTeamCompPred('kmeans', 'svm');
[predKG, ~, muKG] = runTeamCompPred('kmeans', 'gda');
[predKL, ~, muKL] = runTeamCompPred('kmeans', 'lr');
[predDS, ~, muDS] = runTeamCompPred('dpmeans', 'svm');
[predDG, ~, muDG] = runTeamCompPred('dpmeans', 'gda');
[predDL, ~, muDL] = runTeamCompPred('dpmeans', 'lr');
fprintf('Predictors trained in %.2f sec\n', toc(startTime));

% get features from testset data
fprintf('Extracting features from testset data...');
[xKS, yKS] = clusterLabelsToFeatures(getClusterLabels(xTest, muKS), yTest);
[xKG, yKG] = clusterLabelsToFeatures(getClusterLabels(xTest, muKG), yTest);
[xKL, yKL] = clusterLabelsToFeatures(getClusterLabels(xTest, muKL), yTest);
[xDS, yDS] = clusterLabelsToFeatures(getClusterLabels(xTest, muDS), yTest);
[xDG, yDG] = clusterLabelsToFeatures(getClusterLabels(xTest, muDG), yTest);
[xDL, yDL] = clusterLabelsToFeatures(getClusterLabels(xTest, muDL), yTest);
fprintf('done\n');

% get accuracies from predictors
accKS = sum(predKS(xKS) == yKS) / length(yKS);
accKG = sum(predKG(xKG) == yKG) / length(yKG);
accKL = sum(predKL(xKL) == yKL) / length(yKL);
accDS = sum(predDS(xDS) == yDS) / length(yDS);
accDG = sum(predDG(xDG) == yDG) / length(yDG);
accDL = sum(predDL(xDL) == yDL) / length(yDL);

fprintf('Predictor accuracies:\n');
fprintf('%10s\t%10s\t%10s\n', 'kmeans, svm', 'kmeans, gda', 'kmeans, lr');
fprintf('%s\n',repmat('-', 50, 1));
fprintf('%10.4f\t%10.4f\t%10.4f\n\n', accKS, accKG, accKL);
fprintf('%10s\t%10s\t%10s\n', 'dpmeans, svm', 'dpmeans, gda', 'dpmeans, lr');
fprintf('%s\n',repmat('-', 50, 1));
fprintf('%10.4f\t%10.4f\t%10.4f\n', accDS, accDG, accDL);

OUTFILE = sprintf('ResultsTable-%s.mat', datestr(clock));
save(OUTFILE, 'accKS', 'accKG', 'accKL', 'accDS', 'accDG', 'accDL');