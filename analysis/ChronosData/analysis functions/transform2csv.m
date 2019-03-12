% function transform2csv
% to use in R

% load data
% baseline
dataBase = load('dataLongBase.mat');
% experiment
data1 = load(['dataLongBeforeReversal3.mat']);
% data2 = load(['dataLongAtReversal.mat']);
data3 = load(['dataLongAfterReversal3.mat']);

data1.trialData.timeWindow = -1*ones(size(data1.trialData, 1), 1); % before reversal
% data2.trialData.timeWindow = 0*ones(size(data2.trialData, 1), 1); % at reversal
data3.trialData.timeWindow = 1*ones(size(data3.trialData, 1), 1); % after reversal

trialData = data1.trialData;
% trialData = [trialData; data2.trialData];
trialData = [trialData; data3.trialData];
trialData.exp(:, 1) = repmat(3, size(trialData.sub));

trialDataBase = dataBase.trialDataBase;
trialDataBase.exp(:, 1) = repmat(3, size(trialDataBase.sub));

% % merge and save csv
cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1stYear\TorsionPerception\analysis')
writetable(trialData, 'trialDataAllExp3pilot.csv')
writetable(trialDataBase, 'trialDataBaseAllExp3pilot.csv')