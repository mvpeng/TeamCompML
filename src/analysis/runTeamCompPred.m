function [pred, predObj, mu] = runTeamCompPred(compressor, classifier)
% Use
%   Runs classifier with features selected with k-means, DP-means, or EM
%   with Gaussian mixture model data compression methods.
% Input
%   compressor : string indicating k-means ('kmeans'), DP-means 
%                ('dpmeans'), EM Gaussian mixture model ('emgmm')
% Output
%   pred : predictor function handle that outputs a win/loss (1/0)
%          classification based on the input data point
%   predObj : classification model object
%   mu : cluster centroid positions, where each column is a centroid

    % constants
    DATAFILE = '../lolapi/training_full_v3.csv';
    KMEANS = 'kmeans';
    DPMEANS = 'dpmeans';
    EMGMM = 'emgmm';
    SVM = 'svm';
    GDA = 'gda';
    LR = 'logisticRegression';
    
    % check input arguments
    if ~strcmp(compressor, KMEANS) && ...
       ~strcmp(compressor, DPMEANS) && ...
       ~strcmp(compressor, EMGMM)
        error(['Error: compressor must be a valid string indicating ' ...
               'the data compression method']);
    elseif ~strcmp(classifier, SVM) && ...
           ~strcmp(classifier, GDA) && ...
           ~strcmp(classifier, LR)
        error(['Error: classifier must be a valid string indicating ' ...
               'the classification method']);
    end % if
    
    % load training data
    dataset = csvread(DATAFILE, 1, 0);
    x = dataset(:, 2:end);
    y = dataset(:, 1);
    
    % get compressed features and labels
    startTime = tic;
    if strcmp(compressor, KMEANS)
        [X, Y, mu] = getKMeansFeatures(x, y);
    elseif strcmp(compressor, DPMEANS)
        [X, Y, mu] = getDPMeansFeatures(x, y);
    elseif strcmp(compressor, EMGMM)
        % TODO: code EM algorithm up
        error('Error: EM algorithm not implemented!');
    else
        assert(false, 'Assertion failed: Shouldn''t reach here');
    end % if
    
    %  train classifier model and convert predictor to function handle
    if strcmp(classifier, SVM)
        predObj = fitcsvm(X, Y);
    elseif strcmp(classifier, GDA)
        predObj = fitcdiscr(X, Y);
    elseif strcmp(classifier, LR)
        % TODO: code logistic regression algorithm up
        error('Error: logistic regression algorithm not implemented!');
    end % if
    
    pred = @(z)predict(predObj, z);
    
    fprintf(['\n%s model trained with %s data compression method in ' ...
             '%.2f sec\n'], classifier, compressor, toc(startTime));

end % function runGDA