function [c, mu, distortionValue] = myKMeans(X, k, nRestarts)
% Use
%   Implementation of k-means algorithm with random restarts.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   k : predetermined number of point clusters
%   nRestarts : number of random restarts
% Output
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
%   distortionValue: distortion function value

    % check arguments
    if k < 1
        error('Error: k needs to be a positive integer');
    elseif nRestarts < 1
        error('Error: nRestarts needs to be a positive integer');
    end
    
    % constants
    NTRIALS = 10 * nRestarts;
    
    % initialization
    c = -1 * ones(size(X, 1), 1);
    mu = inf * ones(size(X, 2), k);
    
    % run k-means with random restarts
    nTrial = 0;
    nRestart = 0;
    while nRestart < nRestarts && nTrial < NTRIALS
        [cNew, muNew, hasConverged] = singleKMeans(X, k);
        if hasConverged && ...
           distortion(X, cNew, muNew) < distortion(X, c, mu)
            c = cNew;
            mu = muNew;
            distortionValue = distortion(X, c, mu);
            nRestart = nRestart + 1;
        end % if
        nTrial = nTrial + 1;
    end % while
    
end


function [c, mu, converged] = singleKMeans(X, k)
% Use
%   Single run of k-means algorithm, where k is a chosen parameter.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   k : predetermined number of point clusters
% Output
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
%   converged : boolean indicating convergence status

    % constants
    TOL = 1e-4;
    MAX_ITER = 1e2;
    NDATA = size(X, 1);

    % initialization
    c = zeros(NDATA, 1);
    mu = initClusterCentroids(X, k);
    muPrev = inf * ones(size(mu));
    converged = false;
    
    % (locally) optimize over cluster centroids and labels
    for iter = 1:MAX_ITER
        
        % check termination condition
        if hasConverged(mu, muPrev, TOL), break, end
        muPrev = mu;
        
        % assign data points to closest centroids
        for data = 1:NDATA
            diff = repmat(X(data, :)', 1, size(mu, 2)) - mu;
            [~, c(data)] = min(norms(diff, 2));
        end % for data
        
        % assign centroids to cluster means
        for centroid = 1:k
            mu(:, centroid) = mean(X(c == centroid,:))';
        end % for centroid
        
    end % for iter
    
    if iter < MAX_ITER, converged = true; end

end


function mu = initClusterCentroids(X, k)
% Use
%   Randomly initialize k cluster centroids.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   k : predetermined number of point clusters
% Output
%   mu : cluster centroid positions, where each column is a centroid

    minRange = min(X)';
    maxRange = max(X)';
    range = maxRange - minRange;
    
    mu = zeros(length(range), k);
    for i = 1:k
        mu(:,i) = minRange + range .* rand(size(range));
    end % for i

end


function hasConverged = hasConverged(mu, muPrev, tol)
% Use
%   Returns whether the k-means algorithm has converged.
% Input
%   mu : current centroid positions
%   muPrev : previous centroid positions
%   tol : convergence tolerance (L2-norm)
% Output
%   hasConverged : boolean indicating convergence status
    
    hasConverged = norm(mu - muPrev, 2) < tol;

end


function distortion = distortion(X, c, mu)
% Use
%   Computes the distortion function value.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
% Output
%   distortion : distortion function value

    if c(1) < 0
        distortion = inf;
    else
        distortion = 1 / size(X, 1) * sum(norms(X' - mu(:, c), 2)) ^ 2;
    end % if

end