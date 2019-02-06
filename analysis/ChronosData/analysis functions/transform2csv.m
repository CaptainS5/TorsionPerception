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
dataBase = load('dataBaseLong.mat');
% experiment
data1 = load(['dataLongBeforeReversal.mat']);
% data2 = load(['dataLongAtReversal.mat']);
data3 = load(['dataLongAfterReversal.mat']);

data1.trialData.timeWindow = -1*ones(size(data1.trialData, 1), 1); % before reversal
% data2.trialData.timeWindow = 0*ones(size(data2.trialData, 1), 1); % at reversal
data3.trialData.timeWindow = 1*ones(size(data3.trialData, 1), 1); % after reversal

trialData = data1.trialData;
% trialData = [trialData; data2.trialData];
trialData = [trialData; data3.trialData];
trialData.exp(:, 1) = repmat(2, size(trialData.sub));

trialDataBase = dataBase.trialData;
trialDataBase.exp(:, 1) = repmat(2, size(trialDataBase.sub));

trialDataBoth = table();
count = 1;
for ii = 1:size(trialData)
    if ((~isnan(trialData.LtorsionVelT(ii, 1)) && trialData.targetSide(ii, 1) == -1) || ...
            (~isnan(trialData.RtorsionVelT(ii, 1)) && trialData.targetSide(ii, 1) == 1))
        trialDataBoth.sub(count, 1) = trialData.sub(ii, 1);
        trialDataBoth.rotationSpeed(count, 1) = trialData.rotationSpeed(ii, 1);
        trialDataBoth.afterReversalD(count, 1) = trialData.afterReversalD(ii, 1);
        trialDataBoth.targetSide(count, 1) = trialData.targetSide(ii, 1);
        trialDataBoth.timeWindow(count, 1) = trialData.timeWindow(ii, 1);
        trialDataBoth.exp(count, 1) = 2;
        trialDataBoth.perceptualError(count, 1) = trialData.perceptualError(ii, 1);
        if ~isnan(trialData.LtorsionVelT(ii, 1)) && trialData.targetSide(ii, 1) == -1
            trialDataBoth.eye(count, 1) = 1; % left eye
            trialDataBoth.torsionPosition(count, 1) = trialData.LtorsionPosition(ii, 1);           
            trialDataBoth.torsionVelT(count, 1) = trialData.LtorsionVelT(ii, 1);           
            trialDataBoth.torsionAngleTotal(count, 1) = trialData.LtorsionAngleTotal(ii, 1);
            trialDataBoth.torsionAngleCW(count, 1) = trialData.LtorsionAngleCW(ii, 1);
            trialDataBoth.torsionAngleCCW(count, 1) = trialData.LtorsionAngleCCW(ii, 1);          
            trialDataBoth.sacNumT(count, 1) = trialData.LsacNumT(ii, 1);
            trialDataBoth.sacNumTCW(count, 1) = trialData.LsacNumTCW(ii, 1);
            trialDataBoth.sacNumTCCW(count, 1) = trialData.LsacNumTCCW(ii, 1);           
            trialDataBoth.sacAmpSumT(count, 1) = trialData.LsacAmpSumT(ii, 1);
            trialDataBoth.sacAmpSumTCW(count, 1) = trialData.LsacAmpSumTCW(ii, 1);
            trialDataBoth.sacAmpSumTCCW(count, 1) = trialData.LsacAmpSumTCCW(ii, 1);           
            trialDataBoth.sacAmpMeanT(count, 1) = trialData.LsacAmpMeanT(ii, 1);
            trialDataBoth.sacAmpMeanTCW(count, 1) = trialData.LsacAmpMeanTCW(ii, 1);
            trialDataBoth.sacAmpMeanTCCW(count, 1) = trialData.LsacAmpMeanTCCW(ii, 1);
        elseif ~isnan(trialData.RtorsionVelT(ii, 1)) && trialData.targetSide(ii, 1) == 1
            trialDataBoth.eye(count, 1) = 2; % right eye
            trialDataBoth.torsionPosition(count, 1) = trialData.RtorsionPosition(ii, 1);           
            trialDataBoth.torsionVelT(count, 1) = trialData.RtorsionVelT(ii, 1);           
            trialDataBoth.torsionAngleTotal(count, 1) = trialData.RtorsionAngleTotal(ii, 1);
            trialDataBoth.torsionAngleCW(count, 1) = trialData.RtorsionAngleCW(ii, 1);
            trialDataBoth.torsionAngleCCW(count, 1) = trialData.RtorsionAngleCCW(ii, 1);          
            trialDataBoth.sacNumT(count, 1) = trialData.RsacNumT(ii, 1);
            trialDataBoth.sacNumTCW(count, 1) = trialData.RsacNumTCW(ii, 1);
            trialDataBoth.sacNumTCCW(count, 1) = trialData.RsacNumTCCW(ii, 1);           
            trialDataBoth.sacAmpSumT(count, 1) = trialData.RsacAmpSumT(ii, 1);
            trialDataBoth.sacAmpSumTCW(count, 1) = trialData.RsacAmpSumTCW(ii, 1);
            trialDataBoth.sacAmpSumTCCW(count, 1) = trialData.RsacAmpSumTCCW(ii, 1);           
            trialDataBoth.sacAmpMeanT(count, 1) = trialData.RsacAmpMeanT(ii, 1);
            trialDataBoth.sacAmpMeanTCW(count, 1) = trialData.RsacAmpMeanTCW(ii, 1);
            trialDataBoth.sacAmpMeanTCCW(count, 1) = trialData.RsacAmpMeanTCCW(ii, 1);
        end
        count = count+1;
    end
end

% % merge and save csv
cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1stYear\TorsionPerception\analysis')
writetable(trialData, 'trialDataAllExp2.csv')
writetable(trialDataBoth, 'trialDataAllBothEyeExp2.csv')
writetable(trialDataBase, 'trialDataBaseAllExp2.csv')