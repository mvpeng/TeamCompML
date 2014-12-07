% Use
%   Baseline algorithm to test for accuracy of logistic regression on
%   official guide's clustering information (maps characters to play class)

clear; close all; clc;

% constants
CLUSTER_FILE = '../lolapi/champion_tags.csv';
DATA_FILE = '../lolapi/championIDs.csv';
WINLOSS_FILE = '../lolapi/training_full_v3.csv';

% load champion id and corresponding cluster tags
clusterMap = csvread(CLUSTER_FILE);
champID = clusterMap(:, 1);
champTag = clusterMap(:, 2);

% load datafile and win/loss data and get features
cRaw = csvread(DATA_FILE);
nData = size(cRaw, 1);

c = zeros(nData, 1);
for label = 1:nData
    c(label) = champTag(champID == cRaw(label));
end % for label

wl = csvread(WINLOSS_FILE, 1, 0);
y = wl(:, 1);

[X, Y] = clusterLabelsToFeatures(c, y);

% fit with logistic regression and test data
wt = glmfit(X, Y, 'binomial', 'link', 'logit', 'estdisp', 'on', ...
            'constant', 'on');
pred = @(z)(z * wt(2:end) + wt(1) > 0.5);
fprintf(['Training accuracy for logistic regression with suggested ' ...
         'clustering was %.4f\n'], sum(pred(X) == Y) / length(Y));
fprintf(['Training accuracy for logistic regression with suggested ' ...
         'clustering was %.4f\n'], ...
         sum(pred(X(end-2400+1-3450:end-3450, :)) == ...
             Y(end-2400+1-3450:end-3450)) / ...
             length(Y(end-2400+1-3450:end-3450)));