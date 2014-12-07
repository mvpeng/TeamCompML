function [c, mu, k] = myDPMeans(X, XTest, lambda)
% Use
%   Implementation of DP-means algorithm with random restarts and 10%-hold
%   out cross validation for objective function evaluation. 
% Input
%   X : m-samples train set, where each row is a sample feature vector
%   XTest : m-samples test set, where each row is a sample feature vector
%   lambda : cluster penalty parameter
% Output
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
%   k : number of clusters

    % constants
    NDATA = size(X, 1);
    NFEAT = size(X, 2);
    NTEST = size(XTest, 1);
    MAX_ITERS = 1e2;
    
    % initialization
    [c, mu, k] = initClusters(X);
    objvalPrev = inf;
    
    fprintf('\nRunning DP-means...\n\n');
    fprintf('%3s\t%3s\t%10s\t%10s\t%10s\t%10s\n', ...
            'iter', 'k', 'objval', 'diff', 'deltaConv', 'cpu time');
    fprintf('%s\n',repmat('-', 80, 1));

    for iter = 1:MAX_ITERS

        tic;
        X = randPermData(X);
        for data = 1:NDATA
            
            x = X(data, :)';
            
            % compute distance to each centroid
            dist = inf * ones(k, 1);
            for centroid = 1:k
                dist(centroid) = (x - mu(:, centroid))' * ...
                                 (x - mu(:, centroid));
            end % for centroid

            % assign cluster label
            if min(dist) > lambda
                % create new cluster if far from existing clusters
                k = k + 1;
                c(data) = k;
                mu = [mu x];
            else
                [~, c(data)] = min(dist);
            end % if

        end % for data        

        % compute centroid positions
        for centroid = 1:k
            mu(:, centroid) = mean(X(c == centroid, :))';
        end % for centroid
        
        % stop when objective values converge (op test set)
        cTest = getLabels(XTest, mu);
        objval = lambda * k;
        for data = 1:NTEST
            objval = objval + (XTest(data, :)' - mu(:, cTest(data)))' * ...
                              (XTest(data, :)' - mu(:, cTest(data)));
        end % for data
        
        [hasConverged, delta, diff] = ...
            getConvergence(objval, objvalPrev, NDATA, NFEAT);
        
        fprintf('%3d\t%3d\t%10.3f\t%10.2e\t%10.2e\t%10.3f\n', ...
                iter, k, objval, diff, delta, toc);
        
        if hasConverged
            saveResults(c, mu, k, objval);
            break
        end % if
        objvalPrev = objval;

    end % for iter

end % function myDPMeans


function c = getLabels(X, mu)
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


function saveResults(c, mu, k, objval)
% Use
%   Saves the results for the best DP-means clustering.
% Input
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
%   k : number of clusters
%   objval : objective value of best trial

    results.c = c;
    results.mu = mu;
    results.distortionValue = objval;
    results.k = k;
    outfile = sprintf('results-%s-%dclus-%s.mat', 'dpmeans', ...
                      k, datestr(clock));
    save(outfile, 'results');
    fprintf('Results saved to %s\n', outfile);

end % function saveResults


function Xperm = randPermData(X)
% Use
%   Randomly permutes the order of data points.
% Input
%   X : m-samples training set, where each row is a sample feature vector
% Output
%   Xperm : randomly ordered m-samples training set (from X)

  % constants
  NDATA = size(X, 1);

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


function [hasConverged, delta, diff] = getConvergence(objval, objvalPrev, nData, nFeat)
% Use
%   Returns a boolean indicating whether the DP-means iterations have
%   converged (to a local minimum).
% Input
%   objval : current objective value
%   objvalPrev : previous objective value
% Output
%   hasConverged : boolean indicating whether the objective values have
%   converged

    % constants
    REL_TOL = 1e-4;
    ABS_TOL = 1e-4;
    
    diff = abs(objvalPrev - objval);
    delta = REL_TOL * max(objvalPrev, objval) + ...
            ABS_TOL * sqrt(nData * nFeat);
    hasConverged = diff < delta;

end % function hasConverged