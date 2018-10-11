% function transform2csv
% to use in R

names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol' 'FScontrol' 'XWcontrol' 'SCcontrol' 'JFcontrol'};
conditions = [25 50 100 200];
dirI = [-1 1];
eyeName = {'L' 'R'};
trialBaseAll = 48; % total trial numbers
trialExpAll = 288;

% load data
% baseline
dataBase = load('dataBaseLongbaseline.mat');
% experiment
data1 = load(['dataLong120msToReversal.mat']);
data2 = load(['dataLongatReversal.mat']);
data3 = load(['dataLong120msToEnd.mat']);

trialN = size(data1.trialData, 1);
conN = size(data1.conData, 1);

data1.trialData.timeWindow = -1*ones(trialN, 1); % before reversal
data2.trialData.timeWindow = 0*ones(trialN, 1); % at reversal
data3.trialData.timeWindow = 1*ones(trialN, 1); % after reversal

data1.conData.timeWindow = -1*ones(conN, 1);
data2.conData.timeWindow = 0*ones(conN, 1);
data3.conData.timeWindow = 1*ones(conN, 1);

trialData = data1.trialData;
trialData = [trialData; data2.trialData];
trialData = [trialData; data3.trialData];
trialData.exp(:, 1) = repmat(2, size(trialData.sub));

tempIL = find(trialData.eye==1 & trialData.targetSide==-1);
tempIR = find(trialData.eye==2 & trialData.targetSide==1);
tempAll = [tempIL; tempIR];
trialDataBothEyes = trialData(tempAll, :);

count = 1;
speed = [25 50 100 200];
conDataBothEyes = table();
for tw = 1:3
    for t = 1:size(names, 2)
        for sI = 1:4
            dataBoth = trialDataBothEyes(trialDataBothEyes.sub==t & trialDataBothEyes.timeWindow==tw-2 & trialDataBothEyes.rotationSpeed==speed(sI), :);
            for directionI = 1:2
                dataBothDir = dataBoth(dataBoth.afterReversalD==dirI(directionI), :);
                
                conDataBothEyes.sub(count, 1) = t;
                conDataBothEyes.timeWindow(count, 1) = tw-2;
                conDataBothEyes.exp(count, 1) = 2;
                conDataBothEyes.afterReversalD(count, 1) = dirI(directionI);
                conDataBothEyes.rotationSpeed(count, 1) = speed(sI);
                conDataBothEyes.torsionVelTMean(count, 1) = mean(dataBothDir.torsionVelTMerged);
                conDataBothEyes.torsionAngleSameMean(count, 1) = mean(dataBothDir.torsionAngleTSameMerged);
                conDataBothEyes.torsionAngleAntiMean(count, 1) = mean(dataBothDir.torsionAngleTAntiMerged);
                conDataBothEyes.torsionAngleTotalMean(count, 1) = mean(dataBothDir.torsionAngleTotal);
                conDataBothEyes.perceptualErrorMean(count, 1) = mean(dataBothDir.perceptualError);
                conDataBothEyes.sacNumTMean(count, 1) = mean(dataBothDir.sacNumT);
                conDataBothEyes.sacAmpSumTMean(count, 1) = mean(dataBothDir.sacAmpSumT);
                count = count+1;
            end
            conDataBothEyes.sub(count, 1) = t;
            conDataBothEyes.timeWindow(count, 1) = tw-2;
            conDataBothEyes.exp(count, 1) = 2;
            conDataBothEyes.afterReversalD(count, 1) = 0;
            conDataBothEyes.rotationSpeed(count, 1) = speed(sI);
            conDataBothEyes.torsionVelTMean(count, 1) = mean(dataBoth.torsionVelTMerged);
            conDataBothEyes.torsionAngleSameMean(count, 1) = mean(dataBoth.torsionAngleTSameMerged);
            conDataBothEyes.torsionAngleAntiMean(count, 1) = mean(dataBoth.torsionAngleTAntiMerged);
            conDataBothEyes.torsionAngleTotalMean(count, 1) = mean(dataBoth.torsionAngleTotal);
            conDataBothEyes.perceptualErrorMean(count, 1) = mean(dataBoth.perceptualError);
            conDataBothEyes.sacNumTMean(count, 1) = mean(dataBoth.sacNumT);
            conDataBothEyes.sacAmpSumTMean(count, 1) = mean(dataBoth.sacAmpSumT);
            count = count+1;
        end
    end
end

conDataBase = dataBase.conData;
conDataBase.exp(:, 1) = repmat(2, size(conDataBase.sub));

% % merge and save csv
cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\TorsionPerception\analysis')
% writetable(trialData, 'trialDataAllExp2.csv')
% writetable(trialDataBothEyes, 'trialDataAllExp2BothEyes.csv')
writetable(conDataBothEyes, 'conDataAllExp2BothEyes.csv')
% writetable(conDataBase, 'conDataBaseAllExp2.csv')