function [X, Y] = getDPMeansFeatures(x, y)
% Use
%   Returns the DP-means compressed data-trained SVM model.
% Input
%   x : m-samples training set, where each row is a sample feature vector
%   y : m-samples training set vector, where each element is a sample label
% Output
%   X : feature vector for each game
%   Y : classification label for each game

    % constants
    % LAMBDA = (1 + sqrt(5)) / 2; % ~23 clusters
    % LAMBDA = 2; % ~15 clusters
    LAMBDA = 2.5; % ~ 8 clusters
    
    % get cluster labels
    [c, ~, ~] = myDPMeans(x, LAMBDA);
    
    % get team composition-based features and labels
    [X, Y] = clusterLabelsToFeatures(c, y);
    
end % function getDPMeansFeatures