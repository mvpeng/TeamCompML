% EM Gaussian

clc; clear all;
X = csvread('../lolapi/training_full.csv',1);
X = X(:,1:end-1);
[m,n] = size(X);

k = 10; % number of gaussians

% Random INIT
phi = rand(k,1);
mu = rand(n,k);
mu_old = 10*ones(n,k); %init
sigma = zeros(n,n,k);
iters = 0;

while norm(mu-mu_old) > 1e-6
    iters = iters+1
    mu_old = mu;
    for i = 1:k
        sigma(:,:,i) = eye(n,n);
    end

    % E step
    w = zeros(m,k); 
    tot = zeros(m,1);
     for j = 1:k
         sig = sigma(:,:,j);
         densities = mvnpdf(X,mu(:,j)',sig);
         w(:,j) = densities*phi(j);
         tot = tot+ densities*phi(j);
     end

    for j=1:k
       w(:,j) = w(:,j)/tot(j);
    end


    % M step
    for j = 1:k
        sigma(:,:,j) = zeros(16);
        phi(j) = 1/m * sum(w(:,j));
        mu(:,j) = (X' * w(:,j) )/sum(w(:,j));
        for i = 1:m
           sigma(:,:,j) =  sigma(:,:,j) + (w(i,j) * (X(i,:)'-mu(:,j))*(X(i,:)'-mu(:,j))')/sum(w(:,j));
        end
    end

end
