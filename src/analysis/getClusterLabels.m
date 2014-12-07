function c = getClusterLabels(X, mu)
% Use
%   Assign data points to closest centroids.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   mu : cluster centroid positions, where each column is a centroid
% Output
%   c : cluster labels for each point

    % constants
    NDATA = size(X, 1);

    c = zeros(NDATA, 1);
    for data = 1:NDATA
        diff = repmat(X(data, :)', 1, size(mu, 2)) - mu;
        [~, c(data)] = min(norms(diff, 2));
    end % for data

end