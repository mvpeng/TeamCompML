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
    DATAFILE = '../lolapi/training_full.csv';
    KMEANS = 'kmeans';
    DPMEANS = 'dpmeans';
    EMGMM = 'emgmm';
    PCA = 'pca';
    RAW = 'raw';
    
    % check input arguments
    if ~strcmp(method, KMEANS) && ~strcmp(method, DPMEANS) && ...
       ~strcmp(method, EMGMM) && ~strcmp(method, PCA) && ...
       ~strcmp(method, RAW)
        error('Error: method must be a valid string indicating the data compression method');
    end % if
    
    % load training data
    dataset = csvread(DATAFILE, 1, 0);
    X = dataset(:, 2:end);
    Y = dataset(:, 1);

    tic;
    if strcmp(method, KMEANS)
        [svm, svmObj] = svmKMeans(Y);
    elseif strcmp(method, DPMEANS)
        
    elseif strcmp(method, EMGMM)
        
    elseif strcmp(method, PCA)
        
    elseif strcmp(method, RAW)
        
    else
        assert(false, 'Assertion failed: Should not be able to reach here');
    end % if
    
    fprintf('SVM model trained with %s data compression method in %.2f sec\n', method, toc);

end % function runSVM


function [svm, svmObj] = svmKMeans(y)
% Use
%   Returns the k-means compressed data-trained SVM model.
% Input
%   y : m-samples training set vector, where each element is a sample label
% Output
%   svm : svm function handle that outputs a win/loss (1/0) classification
%         based on the input data point
%   svmObj : classification SVM model object (ClassificationSVM)

    % constants
    KMEANS_DATAFILE = 'results-kfold-training-full';
    KMEANS_INDEX = 2;
    
    % load k-means results
    kmeansModel = load(KMEANS_DATAFILE);
    c = kmeansModel.results{KMEANS_INDEX}.c;
    mu = kmeansModel.results{KMEANS_INDEX}.mu;
    
    % get team composition-based features and labels
    [X, Y] = kmeansLabelsToFeatures(c, y);
    
    % train svm model
    svmObj = fitcsvm(X, Y);
    
    % convert svm model to function handle
    svm = svmKMeansFunctionHandle(svmObj);
    
    sum(Y == svm(X))
    
end % function svmKMeans


function [X, Y] = kmeansLabelsToFeatures(c, z)
% Use
%   Converts k-means labels to features.
% Input
%   c : cluster number for each training sample
%   z : original classification labels
% Output
%   X : feature vector for each game
%   Y : classification label for each game

    % constants
    NPLAYERS_PER_TEAM = 5;
    NPLAYERS_PER_GAME = 10;
    NDATA = length(c);
    NGAMES = NDATA / NPLAYERS_PER_GAME;
    NDATA_FINAL = 2 * NGAMES;
    NCLUSTERS = max(c);
    NFEAT_FINAL = 2 * NCLUSTERS;
    
    % initialize output features and counter
    X = zeros(NDATA_FINAL, NFEAT_FINAL);
    Y = zeros(NDATA_FINAL, 1);
    game = 1;
    
    % populate features and labels
    for data = 1:NPLAYERS_PER_GAME:NDATA
        
        % win/loss indicators (1/0)
        score1 = z(data);
        score2 = 1 - score1;
        
        % populate team 1 features
        for playerIdx = data:data + NPLAYERS_PER_TEAM - 1
            X(game, c(playerIdx)) = X(game, c(playerIdx)) + 1;
            X(game + 1, c(playerIdx) + NCLUSTERS) = ...
                X(game + 1, c(playerIdx) + NCLUSTERS) + 1;
        end % for playerIdx
        
        % populate team 2 features
        for playerIdx = data + NPLAYERS_PER_TEAM:data + NPLAYERS_PER_GAME - 1
            X(game, c(playerIdx) + NCLUSTERS) = ...
                X(game, c(playerIdx) + NCLUSTERS) + 1;
            X(game + 1, c(playerIdx)) = X(game + 1, c(playerIdx)) + 1;
        end % for playerIdx
        
        % populate game labels
        Y(game) = score1;
        Y(game + 1) = score2;
        
        % increment game index
        game = game + 2;
        
    end % for data
    
end % function kmeansLabelsToFeatures


function svm = svmKMeansFunctionHandle(svmObj)
% Use
%   Returns a function handle that outputs a win/loss (1/0) classification
%   based on some input data points.
% Input
%   svmObj : classification SVM model object (ClassificationSVM)
% Output
%   svm : svm function handle that outputs a win/loss (1/0) classification
%         based on the input data point

    svm = @(x)predict(svmObj, x);

end % function svmKMeansFunctionHandle