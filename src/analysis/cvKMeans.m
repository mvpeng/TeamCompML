function [c, mu, distortionValue, k] = cvKMeans(X, kRange, method)
% Use
%   Implementation of k-means with k-fold or hold-out cross-validation to 
%   determine the best number of clusters to use within user-input range.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   kRange : range of k-values for cross-validation
%   method : string indicating either k-fold ('kfold') or hold-out 
%            ('holdout') cross validation method
% Output
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
%   distortionValue: distortion function value
%   k : best k-value out of kRange
% Additional notes
%   Outputs a .mat data file containing the labels, centroids, distortion
%   values, and numbers of clusters.

    % constants
    KFOLD = 'kfold';
    HOLDOUT = 'holdout';

    % check arguments
    if sum(kRange < 1) > 0
        error('Error: kRange must only contain positive integers');
    elseif ~strcmp(method, KFOLD) && ~strcmp(method, HOLDOUT)
        error('Error: method can only be kfold or holdout');
    end % if
    
    % run cross-validation
    if strcmp(method, KFOLD)
        [c, mu, distortionValue, k] = kfold(X, kRange);
    else % strcmp(method, HOLDOUT)
        [c, mu, distortionValue, k] = holdout(X, kRange);
    end % if
    
end


function [c, mu, distortionValue, k] = holdout(X, kRange)
% Use
%   Implementation of k-means with hold-out cross-validation to determine
%   the best number of clusters to use within user-input range.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   kRange : range of k-values for cross-validation
% Output
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
%   distortionValue: distortion function value
%   k : best k-value out of kRange

    fprintf('\nRunning hold-out cross-validation for k-means...\n\n');
    fprintf('%3s\t%3s\t%10s\t%10s\t%10s\n', ...
            'k', 'best k', 'objval', 'best objval', 'cpu time');
    fprintf('%s\n',repmat('-', 60, 1));
    
    % constants
    TRAIN_PROP = 0.7;
    NRESTARTS = 20;
    NDATA = size(X, 1);
    NFEAT = size(X, 2);
    OPT = statset('MaxIter', 1e4);
    
    % initialization
    distortionValue = inf;
    results = initResultsCellArray(NDATA, NFEAT, kRange);
    
    % randomly split X to train and test sets
    nTrain = floor(TRAIN_PROP * NDATA);
    perm = randperm(NDATA);
    Xperm = X(perm, :);
    XTrain = Xperm(1:nTrain, :);
    XTest = Xperm(nTrain + 1:end, :);
    
    % try all k-values
    for i = 1:length(kRange)
        
        % train and test centroids
        % tic; [~, muNew, ~] = myKMeans(XTrain, kRange(i), NRESTARTS);
        tic; [~, muNew, ~] = kmeans(XTrain, kRange(i), 'Options', OPT); 
        muNew = muNew';
        
        cNew = getLabels(XTest, muNew);
        newDistortion = distortion(XTest, cNew, muNew);
        
        if newDistortion < distortionValue
            k = kRange(i);
            distortionValue = newDistortion;
        end % if
        
        cputime = toc;
        fprintf('%3d\t%3d\t%10.2e\t%10.2e\t%10.2f\n', ...
                kRange(i), k, newDistortion, distortionValue, cputime);
        
        % record results
        [c, mu] = kmeans(X, k, 'Options', OPT); mu = mu';
        results{i}.c = c;
        results{i}.mu = mu;
        results{i}.distortionValue = newDistortion;
        results{i}.k = kRange(i);
        results{i}.cputime = cputime;
            
    end % for i

    % return k-means result using best k-value
    % [c, mu, distortionValue] = myKMeans(X, k, NRESTARTS);
    [c, mu] = kmeans(X, k, 'Options', OPT); mu = mu';
    
    % save results
    save(sprintf('results-%s-%s.mat', 'holdout', datestr(clock)), 'results');
    
end


function results = initResultsCellArray(nData, nFeat, kRange)
% Use
%   Initializes a cell array for the results of cvKMeans.
% Input
%   nData : number of data points
%   nFeat : number of features
%   kRange : range of k-values for cross-validation
% Output
%   results : empty cell array for the results of cvKMeans

    % constants
    NKVALUES = length(kRange);

    results = cell(NKVALUES, 1);
    for i = 1:NKVALUES
        results{i}.c = zeros(nData, 1);
        results{i}.mu = zeros(nFeat, kRange(i));
        results{i}.distortionValue = 0;
        results{i}.k = kRange(i);
        results{i}.cputime = 0;
    end % for i

end % function initResultsCellArray


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


function [c, mu, distortionValue, k] = kfold(X, kRange)
% Use
%   Implementation of k-means with k-fold cross-validation to determine the
%   best number of clusters to use within user-input range.
% Input
%   X : m-samples training set, where each row is a sample feature vector
%   kRange : range of k-values for cross-validation
% Output
%   c : cluster labels for each point
%   mu : cluster centroid positions, where each column is a centroid
%   distortionValue: distortion function value
%   k : best k-value out of kRange

    fprintf('\nRunning k-fold cross-validation for k-means...\n\n');
    fprintf('%3s\t%3s\t%10s\t%10s\t%10s\n', ...
            'k', 'best k', 'objval', 'best objval', 'cpu time');
    fprintf('%s\n',repmat('-', 60, 1));

    % constants
    NRESTARTS = 20;
    NDATA = size(X, 1);
    NFEAT = size(X, 2);
    KFOLD = min(sqrt(NDATA), 10);
    OPT = statset('MaxIter', 1e4);
    
    % randomly split X into KFOLD disjoint subsets
    assignments = randi(KFOLD, NDATA, 1);
    
    % initialization
    bestDistortion = inf;
    results = initResultsCellArray(NDATA, NFEAT, kRange);
    
    % try all k-values
    for i = 1:length(kRange)
        
        kNew = kRange(i);
        tic; netDistortion = 0;
        
        for kfold = 1:KFOLD
            
            XTrain = X(assignments ~= kfold, :);
            XTest = X(assignments == kfold, :);
            
            % [~, muNew, ~] = myKMeans(XTrain, kNew, NRESTARTS);
            [~, muNew] = kmeans(XTrain, kNew, 'Options', OPT); muNew = muNew';
            cNew = getLabels(XTest, muNew);
            cFull = getLabels(X, muNew);
            
            netDistortion = netDistortion ...
                          + size(XTest, 1) / NDATA ...
                          * (distortion(XTest, cNew, muNew) ...
                             - distortion(X, cFull, muNew));
        end % for kfold
        
        % compute cross-validation score bias term
        % [~, ~, fullSetDistortion] = myKMeans(X, kNew, NRESTARTS);
        [c, mu] = kmeans(X, kNew, 'Options', OPT); mu = mu';
        fullSetDistortion = distortion(X, c, mu);
        
        netDistortion = netDistortion + fullSetDistortion;
        if netDistortion < bestDistortion
            k = kNew;
            bestDistortion = netDistortion;
        end % if
        
        cputime = toc;
        fprintf('%3d\t%3d\t%10.2e\t%10.2e\t%10.2f\n', ...
                kNew, k, netDistortion, bestDistortion, cputime);
        
        % record results
        [c, mu] = kmeans(X, k, 'Options', OPT); mu = mu';
        results{i}.c = c;
        results{i}.mu = mu;
        results{i}.distortionValue = netDistortion;
        results{i}.k = kNew;
        results{i}.cputime = cputime;
        
    end % for i
    
    % return k-means result using best k-value
    % [c, mu, distortionValue] = myKMeans(X, k, NRESTARTS);
    [c, mu] = kmeans(X, k, 'Options', OPT); mu = mu';
    distortionValue = distortion(X, c, mu);
    
    % save results
    save(sprintf('results-%s-%s.mat', 'kfold', datestr(clock)), 'results');

end