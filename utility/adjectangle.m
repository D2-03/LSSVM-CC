clear;
clc;
%%

load('dataTrainGS.mat');
dataTrain = dataTrainGS;

%%
adjacentAngleError = getAdjacentAngleError(dataTrain);

%%
dataTrainGS.adjacentAngleError = adjacentAngleError;
save dataTrainGS dataTrainGS