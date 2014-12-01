% Logistic Regression
load results_kfold.mat

pt = 2;  % point chosen from kmeans cv iteration
X = csvread('training_full.csv',1,0);
[m,n] = size(X);

k = results{pt}.k;
mu = results{pt}.mu;
cluster = results{pt}.c;

% Reorganizing data
X1 = zeros(m/10, k);
X2 = zeros(m/10, k);
for i = 1:10:m
    X1(ceil(i/10),cluster(i)) = X1(ceil(i/10),cluster(i)) +1;
    X1(ceil(i/10),cluster(i+1)) = X1(ceil(i/10),cluster(i+1)) +1;
    X1(ceil(i/10),cluster(i+2)) = X1(ceil(i/10),cluster(i+2)) +1;
    X1(ceil(i/10),cluster(i+3)) = X1(ceil(i/10),cluster(i+3)) +1;
    X1(ceil(i/10),cluster(i+4)) = X1(ceil(i/10),cluster(i+4)) +1;
    
    X2(ceil(i/10),cluster(i+5)) = X2(ceil(i/10),cluster(i+5)) +1;
    X2(ceil(i/10),cluster(i+6)) = X2(ceil(i/10),cluster(i+6)) +1;
    X2(ceil(i/10),cluster(i+7)) = X2(ceil(i/10),cluster(i+7)) +1;
    X2(ceil(i/10),cluster(i+8)) = X2(ceil(i/10),cluster(i+8)) +1;
    X2(ceil(i/10),cluster(i+9)) = X2(ceil(i/10),cluster(i+9)) +1;
end
Y = X(:,1); % result vector (1/0 win/loss)

% training vectors to use for regression
X_training = [X1 X2; X2 X1]; % symmetrically concatenate
Y_training = [Y(1:10:end) ; Y(6:10:end)];

% logistic regression
[theta, dev, stats] = mnrfit(X_training,Y_training+1); %coefficients
