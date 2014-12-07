load('results-kfold-training-full-3.mat');
for i = 1:20
    results{i}.mu = results{i}.mu(1:21,:);
end
save('results-kfold-training-full-32.mat', 'results');