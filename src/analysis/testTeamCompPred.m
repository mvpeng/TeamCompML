% Use
%   Test predictor error rates.

% load testing data
fprintf('Loading testing data...');
DATAFILE = '../lolapi/testing_v3.csv';
testset = csvread(DATAFILE, 1, 0);
xTest = testset(:, 2:end);
yTest = testset(:, 1);
fprintf('done\n');

% get predictors
fprintf('Training predictors...\n'); tic;
[predKS, ~] = runTeamCompPred('kmeans', 'svm');
[predKG, ~] = runTeamCompPred('kmeans', 'gda');
[predDS, ~] = runTeamCompPred('dpmeans', 'svm');
[predDG, ~] = runTeamCompPred('dpmeans', 'gda');
fprintf('Predictors trained in %.2f sec\n', toc);

% test predictors
