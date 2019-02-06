% function transform2csv
% this is for data analysis without velocity trace... not used in the
% final manuscript
% to use in R

names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
conditions = [25 50 100 200 400];
eyeName = {'L' 'R'};
trialBaseAll = 50; % total trial numbers
trialExpAll = 360;

% load data
% baseline
dataBase = load('dataBaseLong.mat');
% experiment
data1 = load(['dataLongBeforeReversal.mat']);
% data2 = load(['dataLongAtReversal.mat']);
data3 = load(['dataLongAfterReversal.mat']);

conN = size(data1.conData, 1);

data1.trialData.timeWindow = -1*ones(size(data1.trialData, 1), 1); % before reversal
% data2.trialData.timeWindow = 0*ones(size(data2.trialData, 1), 1); % at reversal
data3.trialData.timeWindow = 1*ones(size(data3.trialData, 1), 1); % after reversal

data1.conData.timeWindow = -1*ones(conN, 1);
% data2.conData.timeWindow = 0*ones(conN, 1);
data3.conData.timeWindow = 1*ones(conN, 1);

trialData = data1.trialData;
% trialData = [trialData; data2.trialData];
trialData = [trialData; data3.trialData];
trialData.exp(:, 1) = repmat(1, size(trialData.sub));

conData = data1.conData;
% conData = [conData; data2.conData];
conData = [conData; data3.conData];
conData.exp(:, 1) = repmat(1, size(conData.sub));

conDataBase = dataBase.conData;
conDataBase.exp(:, 1) = repmat(1, size(conDataBase.sub));

trialDataBase = dataBase.trialData;
trialDataBase.exp(:, 1) = repmat(2, size(trialDataBase.sub));

% merge and save csv
cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1stYear\TorsionPerception\analysis')
writetable(trialData, 'trialDataAllExp1.csv')
% writetable(conData, 'conDataAllExp1.csv')
% writetable(conDataBase, 'conDataBaseAllExp1.csv')
writetable(trialDataBase, 'trialDataBaseAllExp1.csv')