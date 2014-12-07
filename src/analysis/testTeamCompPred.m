% Use
%   Test predictor error rates.

% load testing data


% get predictors
[predKS, ~] = runTeamCompPred('kmeans', 'svm');
[predKG, ~] = runTeamCompPred('kmeans', 'gda');
[predDS, ~] = runTeamCompPred('dpmeans', 'svm');
[predDG, ~] = runTeamCompPred('dpmeans', 'gda');

