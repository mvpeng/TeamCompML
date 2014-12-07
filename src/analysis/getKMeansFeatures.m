function [X, Y, mu] = getKMeansFeatures(x, y)
% Use
%   Returns the k-means compressed data-trained SVM model.
% Input
%   x : m-samples train set, where each row is a sample feature vector
%   y : m-samples training set vector, where each element is a sample label
% Output
%   X : feature vector for each game
%   Y : classification label for each game
%   mu : cluster centroid positions, where each column is a centroid

    % constants
    KMEANS_DATAFILE = 'results-kfold-training-full-3';
    OFFSET = 4;
    K_VALUE = 12;
    KMEANS_INDEX = K_VALUE - OFFSET;
    
    % load k-means results
    kmeansModel = load(KMEANS_DATAFILE);
    mu = kmeansModel.results{KMEANS_INDEX}.mu;
    
    % get team composition-based features and labels
    c = getClusterLabels(x, mu);
    [X, Y] = clusterLabelsToFeatures(c, y);
    
end % function getKMeansFeatures