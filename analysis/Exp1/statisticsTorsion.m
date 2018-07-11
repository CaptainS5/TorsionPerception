% all statistic analysis and results for torsion Exp1
% 07/08/2018 Xiuyun Wu
clear all; close all; clc

global trial

names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
conditions = [25 50 100 200 400];
eyeName = {'L' 'R'};
eye = 2;
endName = '120msToEnd';
trialBaseAll = 50; % total trial numbers
trialExpAll = 300;

% load data
cd('ChronosData\analysis functions')
% baseline
dataBase = load('dataBaseLongbaseline.mat');
% experiment
data1 = load(['dataLong120msToReversal.mat']);
data2 = load(['dataLongatReversal.mat']);
data3 = load(['dataLong120msToEnd.mat']);

%% valid trial numbers
cd ..
cd ('Errorfiles')

for t = 1:size(names, 2)
    % baseline eye valid
    if t>8
    idxBase = find(dataBase.trialData.sub==t-8);
    validBase(t-8, 1) = length(idxBase);
    end
    % exp both perception and eye data valid
    idxExp = find(data1.trialData.sub==t);
    validExp(t, 1) = length(idxExp);
    % exp eye valid
    numE = 0;
    for bN = 1:5
        load(['Exp' num2str(bN) '_Subject' num2str(t,'%.2i') '_Block' num2str(bN,'%.2i') '_' eyeName{eye} '_errorFile.mat']);
        numE = numE+length(find(errorStatus==0));
    end
    validExpEye(t, 1) = numE;
end

disp(['baseline excluded trial number: ', num2str(mean(1-validBase/trialBaseAll)), ' +- ', num2str(std(1-validBase/trialBaseAll))])
disp(['exp eye excluded trial number: ', num2str(mean(1-validExpEye/trialExpAll)), ' +- ', num2str(std(1-validExpEye/trialExpAll))])
disp(['exp all valid trial number: ', num2str(mean(validExp/trialExpAll)), ' +- ', num2str(std(validExp/trialExpAll))])

%% ANOVA with time window, speed and direction for torsion
data1.conData.timeWindow = ones(size(data1.conData, 1), 1);
data2.conData.timeWindow = 2*ones(size(data2.conData, 1), 1);
data3.conData.timeWindow = 3*ones(size(data3.conData, 1), 1);
dataAll = [data1.conData; data2.conData; data3.conData];

tempI = find(dataAll.afterReversalD~=0);
dataAll.torsionVelTMean(tempI) = dataAll.torsionVelTMean(tempI).*dataAll.afterReversalD(tempI);
dataAll.torsionAngleMean(tempI) = dataAll.torsionAngleMean(tempI).*dataAll.afterReversalD(tempI);

% one way anova of time window
for t = 1:size(names, 2)
    for ii = 1:3
    tempI = find(dataAll.sub==t & dataAll.timeWindow==ii & dataAll.afterReversalD~=0);
    dataV(t, ii) = mean(dataAll.torsionVelTMean(tempI));
    dataA(t, ii) = mean(dataAll.torsionAngleMean(tempI));
    end
end
WM = table([1 2 3]', 'VariableNames', {'timeWindow'});
dataV = mat2cell(dataV, size(dataV, 1), ones(1, size(dataV, 2)));
dataV = table(dataV{:}, 'VariableNames', {'t1', 't2', 't3'});
dataA = mat2cell(dataA, size(dataA, 1), ones(1, size(dataA, 2)));
dataA = table(dataA{:}, 'VariableNames', {'t1', 't2', 't3'});
rmV = fitrm(dataV, 't1-t3~1', 'WithinDesign', WM);
rmA = fitrm(dataA, 't1-t3~1', 'WithinDesign', WM);
ranovatblV = ranova(rmV)
ranovatblA = ranova(rmA)

% two-way anovas of speed and direction
% before-reversal
tempI = find(dataAll.timeWindow==1 & dataAll.afterReversalD~=0);
dataT = dataAll(tempI, :);
statsV1 = rm_anova2(dataT.torsionVelTMean, dataT.sub, dataT.rotationSpeed, dataT.afterReversalD, {'rotationSpeed', 'afterDirection'})
statsA1 = rm_anova2(dataT.torsionAngleMean, dataT.sub, dataT.rotationSpeed, dataT.afterReversalD, {'rotationSpeed', 'afterDirection'})

% at-revresal
tempI = find(dataAll.timeWindow==2 & dataAll.afterReversalD~=0);
dataT = dataAll(tempI, :);
statsV2 = rm_anova2(dataT.torsionVelTMean, dataT.sub, dataT.rotationSpeed, dataT.afterReversalD, {'rotationSpeed', 'afterDirection'})
statsA2 = rm_anova2(dataT.torsionAngleMean, dataT.sub, dataT.rotationSpeed, dataT.afterReversalD, {'rotationSpeed', 'afterDirection'})

% after-reversal
tempI = find(dataAll.timeWindow==3 & dataAll.afterReversalD~=0);
dataT = dataAll(tempI, :);
statsV3 = rm_anova2(dataT.torsionVelTMean, dataT.sub, dataT.rotationSpeed, dataT.afterReversalD, {'rotationSpeed', 'afterDirection'})
statsA3 = rm_anova2(dataT.torsionAngleMean, dataT.sub, dataT.rotationSpeed, dataT.afterReversalD, {'rotationSpeed', 'afterDirection'})

% % three way anova...
% speedI = unique(dataAll.rotationSpeed);
% for ii = 1:length(speedI)
%     tempI = find(dataAll.rotationSpeed==speedI(ii));
%     dataAll.rotationSpeed(tempI) = ii;
% end
% for ii = 1:size(dataAll, 1)
%     if dataAll.afterReversalD(ii, 1) == -1;
%         dataAll.afterReversalD(ii, 1) = 1; % CCW
%     elseif dataAll.afterReversalD(ii, 1) == 1;
%         dataAll.afterReversalD(ii, 1) = 2; % CW
%     end
% end
% 
% % torsional velocity
% dataV = [dataAll.torsionVelTMean, dataAll.rotationSpeed, dataAll.afterReversalD, dataAll.timeWindow, dataAll.sub];
% RMAOV33(dataV, 0.05)
% 
% % torsional angle
% dataV = [dataAll.torsionAngleMean, dataAll.rotationSpeed, dataAll.afterReversalD, dataAll.timeWindow, dataAll.sub];
% RMAOV33(dataV, 0.05)

%% ANOVA for perception
tempI = find(dataAll.timeWindow==3 & dataAll.afterReversalD~=0);
dataT = dataAll(tempI, :);
statsP = rm_anova2(dataT.perceptualErrorMean, dataT.sub, dataT.rotationSpeed, dataT.afterReversalD, {'rotationSpeed', 'afterDirection'})

%% Correlation
% Across participants
for tw = 1:3
    tempI = find(dataAll.timeWindow==tw & dataAll.afterReversalD==0);
    dataT = dataAll(tempI, :);
    [rho pval] = partialcorr([dataT.perceptualErrorMean, dataT.torsionVelTMean], dataT.rotationSpeed);
    disp(['Time Window' num2str(tw) ' across participants, Velocity: r=' num2str(rho(1, 2), '%.2f') ', p=' num2str(pval(1, 2), '%.3f')])
    [rho pval] = partialcorr([dataT.perceptualErrorMean, dataT.torsionAngleMean], dataT.rotationSpeed);
    disp(['Time Window' num2str(tw) ' across participants, Angle: r=' num2str(rho(1, 2), '%.2f') ', p=' num2str(pval(1, 2), '%.3f')])
end

% Individual trial-by-trial
data1.trialData.timeWindow = ones(size(data1.trialData, 1), 1);
data2.trialData.timeWindow = 2*ones(size(data2.trialData, 1), 1);
data3.trialData.timeWindow = 3*ones(size(data3.trialData, 1), 1);
dataAllTrial = [data1.trialData; data2.trialData; data3.trialData];

for tw = 1:3
    for t = 1:size(names, 2)
        tempI = find(dataAllTrial.timeWindow==tw & dataAllTrial.sub==t);
        dataT = dataAllTrial(tempI, :);
        [tbtCorrVRho(t, tw) tbtCorrVpval(t, tw)] = corr(dataT.perceptualError, dataT.torsionVelTMerged);
        [tbtCorrARho(t, tw) tbtCorrApval(t, tw)] = corr(dataT.perceptualError, dataT.torsionAngleMerged);
        
        % partial correlation... no reason to do this...
%         [rho pval] = partialcorr([dataT.perceptualError, dataT.torsionVelTMerged], dataT.rotationSpeed);
%         tbtCorrVRho(t, tw) = rho(1, 2);
%         tbtCorrVpval(t, tw) = pval(1, 2);
%         [rho pval] = partialcorr([dataT.perceptualError, dataT.torsionAngleMerged], dataT.rotationSpeed);
%         tbtCorrARho(t, tw) = rho(1, 2);
%         tbtCorrApval(t, tw) = pval(1, 2);
    end
end

tempI = find(tbtCorrVpval(:, 3)<0.05);
Vr3N = length(tempI)
meanVr3 = mean(tbtCorrVRho(tempI, 3))
stdVr3 = std(tbtCorrVRho(tempI, 3))

tempI = find(tbtCorrVpval(:, 1)<0.05);
Vr1N = length(tempI)
meanVr1 = mean(tbtCorrVRho(tempI, 1))
stdVr1 = std(tbtCorrVRho(tempI, 1))

tempI = find(tbtCorrApval(:, 3)<0.05);
Ar3N = length(tempI)
meanAr3 = mean(tbtCorrARho(tempI, 3))
stdAr3 = std(tbtCorrARho(tempI, 3))

tempI = find(tbtCorrApval(:, 1)<0.05);
Ar1N = length(tempI)
meanAr1 = mean(tbtCorrARho(tempI, 1))
stdAr1 = std(tbtCorrARho(tempI, 1))
