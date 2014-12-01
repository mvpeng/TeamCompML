function [Y, V] = myPCA(X, k)
% Use
%   Runs PCA algorithm for data dimensionality reduction.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   k : number of desired principal components of data
% Output
%   Y : m-samples reduced dimensionality training set (row-wise samples)
%   V : nFeat x k column-wise basis vectors

    % constants
    NDATA = size(X, 1);
    NFEAT = size(X, 2);

    % compute basis vectors for principal components
    XT = zeros(NFEAT);
    for data = 1:NDATA
        XT = XT + X(data, :)' * X(data, :);
    end % for data
    [V, ~] = eig(XT);

    % map data to reduced dimensionality space
    Y = zeros(NDATA, k);
    for data = 1:NDATA
        Y(data, :) = V' * X(data, :)';
    end % for data

end % function myPCA