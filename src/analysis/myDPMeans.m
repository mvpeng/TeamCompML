function [c, mu, k] = myDPMeans(X, nRestarts, lambda)
% Use
%   Implementation of DP-means algorithm with random restarts.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   nRestarts : number of random restarts
%   lambda : cluster penalty parameter
% Output
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
%   k : number of clusters

    % check arguments
    if nRestarts < 1
        error('Error: nRestarts needs to be a positive integer');
    end

    % constants
    NDATA = size(X, 1);
    MAX_ITERS = 1e4;

    % initialization
    X = randPermData(X);
    [c, mu, k] = initClusters(X);
    cPrev = zeros(NDATA, 1);

    for iter = 1:MAX_ITERS

        

        % stop when labels converge
        if sum(cPrev ~= c) == 0, break, end
        cPrev = c;

    end % for iter

end % function myDPMeans


function Xperm = randPermData(X)
% Use
%   Randomly permutes the order of data points.
% Input
%   X : m-samples training set, where each row is a sample feature vector
% Output
%   Xperm : randomly ordered m-samples training set (from X)

  Xperm = X(randperm(NDATA), :);

end % function randPermData


function [c, mu, k] = initClusters(X)
% Use
%   Initalizes the DP-means algorithm with a single cluster.
% Input
%   X : m-samples training set, where each row is a sample feature vector
% Output
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
%   k : number of clusters

  % constants
  NDATA = size(X, 1);

  k = 1;
  mu = mean(X)';
  c = ones(NDATA, 1);

end % function initClusters