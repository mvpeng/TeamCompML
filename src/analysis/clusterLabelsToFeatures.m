function [X, Y] = clusterLabelsToFeatures(c, z)
% Use
%   Converts cluster labels to features.
% Input
%   c : cluster number for each training sample
%   z : original classification labels
% Output
%   X : feature vector for each game
%   Y : classification label for each game

    % constants
    NPLAYERS_PER_TEAM = 5;
    NPLAYERS_PER_GAME = 10;
    NDATA = length(c) - mod(length(c), NPLAYERS_PER_GAME);
    NGAMES = NDATA / NPLAYERS_PER_GAME;
    NDATA_FINAL = 2 * NGAMES;
    NCLUSTERS = max(c);
    NFEAT_FINAL = 2 * NCLUSTERS;
    
    % initialize output features and counter
    X = zeros(NDATA_FINAL, NFEAT_FINAL);
    Y = zeros(NDATA_FINAL, 1);
    game = 1;
    
    % populate features and labels
    for data = 1:NPLAYERS_PER_GAME:NDATA
        
        % win/loss indicators (1/0)
        score1 = z(data);
        score2 = 1 - score1;
        
        % populate team 1 features
        for playerIdx = data:data + NPLAYERS_PER_TEAM - 1
            X(game, c(playerIdx)) = X(game, c(playerIdx)) + 1;
            X(game + 1, c(playerIdx) + NCLUSTERS) = ...
                X(game + 1, c(playerIdx) + NCLUSTERS) + 1;
        end % for playerIdx
        
        % populate team 2 features
        for playerIdx = data + NPLAYERS_PER_TEAM:data + NPLAYERS_PER_GAME - 1
            X(game, c(playerIdx) + NCLUSTERS) = ...
                X(game, c(playerIdx) + NCLUSTERS) + 1;
            X(game + 1, c(playerIdx)) = X(game + 1, c(playerIdx)) + 1;
        end % for playerIdx
        
        % populate game labels
        Y(game) = score1;
        Y(game + 1) = score2;
        
        % increment game index
        game = game + 2;
        
    end % for data
    
end % function clusterLabelsToFeatures