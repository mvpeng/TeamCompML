function [X, Y] = getKMeansFeatures(y)
% Use
%   Returns the k-means compressed data-trained SVM model.
% Input
%   y : m-samples training set vector, where each element is a sample label
% Output
%   X : feature vector for each game
%   Y : classification label for each game

    % constants
    KMEANS_DATAFILE = 'results-kfold-training-full-3';
    OFFSET = 4;
    K_VALUE = 12;
    KMEANS_INDEX = K_VALUE - OFFSET;
    
    % load k-means results
    kmeansModel = load(KMEANS_DATAFILE);
    c = kmeansModel.results{KMEANS_INDEX}.c;
    
    % get team composition-based features and labels
    [X, Y] = clusterLabelsToFeatures(c, y);
    
end % function getKMeansFeatures