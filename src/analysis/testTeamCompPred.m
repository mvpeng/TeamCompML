% Use
%   Test predictor accuracies.

clear; close all; clc;

% load testing data
fprintf('Loading testing data...');
TEST_FILE = '../lolapi/testing_v3.csv';
testset = csvread(TEST_FILE, 1, 0);
xTest = testset(:, 2:end);
yTest = testset(:, 1);
fprintf('done\n');

% load training data
fprintf('Loading training data...');
TRAIN_FILE = '../lolapi/training_full_v3.csv';
trainset = csvread(TRAIN_FILE, 1, 0);
xTrain = trainset(:, 2:end);
yTrain = trainset(:, 1);
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

% get accuracies from predictors on testset
accKSTest = sum(predKS(xKS) == yKS) / length(yKS);
accKGTest = sum(predKG(xKG) == yKG) / length(yKG);
accKLTest = sum(predKL(xKL) == yKL) / length(yKL);
accDSTest = sum(predDS(xDS) == yDS) / length(yDS);
accDGTest = sum(predDG(xDG) == yDG) / length(yDG);
accDLTest = sum(predDL(xDL) == yDL) / length(yDL);

fprintf('Predictor accuracies on testset:\n');
fprintf('%10s\t%10s\t%10s\n', 'kmeans, svm', 'kmeans, gda', 'kmeans, lr');
fprintf('%s\n',repmat('-', 50, 1));
fprintf('%10.4f\t%10.4f\t%10.4f\n\n', accKSTest, accKGTest, accKLTest);
fprintf('%10s\t%10s\t%10s\n', 'dpmeans, svm', 'dpmeans, gda', 'dpmeans, lr');
fprintf('%s\n',repmat('-', 50, 1));
fprintf('%10.4f\t%10.4f\t%10.4f\n', accDSTest, accDGTest, accDLTest);

% get accuracies from predictors on trainset
fprintf('Extracting features from trainset data...');
[xKS, yKS] = clusterLabelsToFeatures(getClusterLabels(xTrain, muKS), yTrain);
[xKG, yKG] = clusterLabelsToFeatures(getClusterLabels(xTrain, muKG), yTrain);
[xKL, yKL] = clusterLabelsToFeatures(getClusterLabels(xTrain, muKL), yTrain);
[xDS, yDS] = clusterLabelsToFeatures(getClusterLabels(xTrain, muDS), yTrain);
[xDG, yDG] = clusterLabelsToFeatures(getClusterLabels(xTrain, muDG), yTrain);
[xDL, yDL] = clusterLabelsToFeatures(getClusterLabels(xTrain, muDL), yTrain);
fprintf('done\n');

% get accuracies from predictors on trainset
accKSTrain = sum(predKS(xKS) == yKS) / length(yKS);
accKGTrain = sum(predKG(xKG) == yKG) / length(yKG);
accKLTrain = sum(predKL(xKL) == yKL) / length(yKL);
accDSTrain = sum(predDS(xDS) == yDS) / length(yDS);
accDGTrain = sum(predDG(xDG) == yDG) / length(yDG);
accDLTrain = sum(predDL(xDL) == yDL) / length(yDL);

fprintf('Predictor accuracies:\n');
fprintf('%10s\t%10s\t%10s\n', 'kmeans, svm', 'kmeans, gda', 'kmeans, lr');
fprintf('%s\n',repmat('-', 50, 1));
fprintf('%10.4f\t%10.4f\t%10.4f\n\n', accKSTrain, accKGTrain, accKLTrain);
fprintf('%10s\t%10s\t%10s\n', 'dpmeans, svm', 'dpmeans, gda', 'dpmeans, lr');
fprintf('%s\n',repmat('-', 50, 1));
fprintf('%10.4f\t%10.4f\t%10.4f\n', accDSTrain, accDGTrain, accDLTrain);

OUTFILE = sprintf('ResultsTable-%s.mat', datestr(clock));
save(OUTFILE, 'accKSTest', 'accKGTest', 'accKLTest', 'accDSTest', 'accDGTest', 'accDLTest', ...
     'accKSTrain', 'accKGTrain', 'accKLTrain', 'accDSTrain', 'accDGTrain', 'accDLTrain');