TeamCompML
==========

Repository for CS 229 League of Legends + Machine Learning project. 

## Title

Classifying Player Behavior and Optimal Team Composition in Massively Multiplayer Online Role-Playing Games

### Members
Hao Yi Ong, Sunil Deolalikar, Mark Peng

## Description

###Introduction and objective

Online virtual worlds are an increasingly significant venue for human interaction. By far the most active virtual worlds belong to a genre of video games called massively multiplayer online role-playing games (MMORPGs), where players interact with each other in a virtual world. In an MMORPG, a very large number of players assume the role of characters and take control over most of their characters’ actions, often working in teams to accomplish a common objective (e.g., defeating computer enemies). Recognizing the potential of these online interactions, research communities have formed around studying the use of virtual worlds for education, training, and scientific research [Bai07, Dic05].

In MMORPGs, there are near-endless actions that each user can choose and influence future events in the game. This freedom and flexibility in player choices makes it difficult to predict exactly what will occur in a particular game. With proper machine learning techniques, however, it might be possible to use data from large sets of game histories and predict the outcome of player interactions given fixed pre-interaction factors. In other words, we are interested in how likely it is that a team of players can accomplish a certain objective given features such as a player’s character choice and the composition of the characters on a player team.

For this project we consider a very popular RPG---League of Legends. This game is focused on two opposing teams of five players (each playing as one of over 100 different characters) battling each other to destroy opposing “bases,” structures that are destroyed after suffering enough attacks from a character. Here, we are interested in predicting which team might win, given features such as a player’s character choice, team characters composition, and certain player behaviors. 

### Dataset acquisition

League of Legends is run by Riot Games, which serves over 20 million users each day and generates vast amounts of rich player data that can be accessed via an API. Using this API, we can acquire detailed datasets on game histories that includes information such as performance statistics (e.g., how many actions of a specific type that a character has used), composition of the team (i.e., the specific characters each team has chosen to match-up against the other), and the results of the match (wins/losses, important objectives obtained during the game, etc.).

###Methods

We consider unsupervised learning, specifically K-means (w/ cross validation) or DP-means [KJ12], to cluster player character behaviors and team compositions that are statistically more successful against a given opposing team composition. By identifying such a trend between team composition and victory/defeat, we aim to predict the win-lose outcome of a League of Legends match before it actually begins.

### References

[Bai07] W. Bainbridge. The scientific research potential of virtual worlds. Science, vol. 317, no. 5837, pp. 472--476, 2012.

[Dic05] M. Dickey. Three dimensional virtual worlds and distance learning: Two case studies of Active Worlds as a medium for distance education. British Journal of Educational Technology, vol. 36, no. 3, pp. 439--451, 2005.

[KJ12] B. Kulis and M. Jordan. Revisiting K-means: New algorithms via Bayesian Nonparametrics. Proceedings of the 29th International Conference on Machine Learning, Edinburgh, Scotland, UK, 2012. 
