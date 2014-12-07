function [X, Y] = getDPMeansFeatures(y)
% Use
%   Returns the DP-means compressed data-trained SVM model.
% Input
%   y : m-samples training set vector, where each element is a sample label
% Output
%   X : feature vector for each game
%   Y : classification label for each game

    % constants
    DPMEANS_DATAFILE = 'results-dpmeans-10clus';
    
    % load k-means results
    kmeansModel = load(DPMEANS_DATAFILE);
    c = kmeansModel.results.c;
    
    % get team composition-based features and labels
    [X, Y] = clusterLabelsToFeatures(c, y);
    
end % function getDPMeansFeatures