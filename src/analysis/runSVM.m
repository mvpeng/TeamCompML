function [svm, svmObj] = runSVM(method)
% Use
%   Runs SVM with cross validation on features selected with raw features
%   or k-means, DP-means, EM with Gaussian mixture model, or PCA 
%   data compression methods.
% Input
%   method : string indicating k-means ('kmeans'), DP-means ('dpmeans'), EM
%            Gaussian mixture model ('emgmm'), PCA ('pca'), or features
%            ('raw')
% Output
%   svm : svm function handle that outputs a win/loss (1/0) classification
%         based on the input data point
%   svmObj : classification SVM model object (ClassificationSVM)

    % constants
    KMEANS = 'kmeans';
    DPMEANS = 'dpmeans';
    EMGMM = 'emgmm';
    DATAFILE = '../lolapi/training_full.csv';
    
    % check input arguments
    if ~strcmp(method, KMEANS) && ~strcmp(method, DPMEANS) && ...
       ~strcmp(method, EMGMM)
        error(['Error: method must be a valid string indicating the ' ...
               'data compression method']);
    end % if
    
    % load training data
    dataset = csvread(DATAFILE, 1, 0);
    x = dataset(:, 2:end);
    y = dataset(:, 1);
    
    % get compressed features and labels
    tic;
    if strcmp(method, KMEANS)
        [X, Y] = svmKMeans(y);
    elseif strcmp(method, DPMEANS)
        [X, Y] = svmDPMeans(x, y);
    elseif strcmp(method, EMGMM)
        % TODO: code EM algorithm up
        error('Error: EM algorithm not implemented!');
    else
        assert(false, 'Assertion failed: Shouldn''t reach here');
    end % if
    
    % train svm model and convert to function handle
    svmObj = fitcsvm(X, Y);
    svm = @(z)predict(svmObj, z);
    
    fprintf(['\nSVM model trained with %s data compression method in ' ...
             '%.2f sec\n'], method, toc);

end % function runSVM