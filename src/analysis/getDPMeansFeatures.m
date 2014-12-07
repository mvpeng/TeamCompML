function [X, Y, mu] = getDPMeansFeatures(x, y)
% Use
%   Returns the DP-means compressed data-trained SVM model.
% Input
%   x : m-samples train set, where each row is a sample feature vector
%   y : m-samples training set vector, where each element is a sample label
% Output
%   X : feature vector for each game
%   Y : classification label for each game
%   mu : cluster centroid positions, where each column is a centroid

    % constants
    DPMEANS_DATAFILE = 'results-dpmeans-8clus';
    
    % load k-means results
    kmeansModel = load(DPMEANS_DATAFILE);
    mu = kmeansModel.results.mu;
    
    % get team composition-based features and labels
    c = getClusterLabels(x, mu);
    [X, Y] = clusterLabelsToFeatures(c, y);
    
end % function getDPMeansFeatures