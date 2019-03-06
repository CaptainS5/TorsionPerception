% all statistic analysis and results for torsion Exp2
% 07/08/2018 Xiuyun Wu
clear all; close all; clc

global trial

names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol' 'FScontrol' 'XWcontrol' 'SCcontrol' 'JFcontrol'};
conditions = [25 50 100 200];
eyeName = {'L' 'R'};
trialBaseAll = 48; % total trial numbers
trialExpAll = 288;

% load data
cd('ChronosData\analysis functions')
% baseline
dataBase = load('dataBaseLong.mat');
% experiment
data1 = load(['dataLongBeforeReversal.mat']);
data2 = load(['dataLongAtReversal.mat']);
data3 = load(['dataLongAfterReversal.mat']);
cd ..
cd ..
trialDataBoth = readtable('trialDataAllBothEyeExp2.csv');

%% valid trial numbers
cd ('ChronosData\Errorfiles')

invalidExpEye = zeros(size(names, 2), 2);
invalidExpEyeBoth = zeros(size(names, 2), 1);
for t = 1:size(names, 2)
    %% baseline
        % left baseline eye valid
        load(['Exp0_Subject' num2str(t,'%.2i') '_Block01_L_errorFile.mat']);
        idxL = find(errorStatus~=0);
        if length(errorStatus)>48
            disp(['L, sub', num2str(t), ', baseline block']);
        end
        invalidBaseEye(t, 1) = length(idxL);
        
        % right baseline eye valid
        load(['Exp0_Subject' num2str(t,'%.2i') '_Block01_R_errorFile.mat']);
        idxR = find(errorStatus~=0);
        if length(errorStatus)>48
            disp(['R, sub', num2str(t), ', baseline block']);
        end
        invalidBaseEye(t, 2) = length(idxR);
        
        % both baseline eye valid
        idxBaseEyeBoth = unique([idxL; idxR]);
        invalidBaseEyeBoth(t, 1) = length(idxBaseEyeBoth);
        
        % left baseline valid after outlier exclusion
        idxBaseL = find(dataBase.trialData.sub==t & ...
            ~isnan(dataBase.trialData.LtorsionVelT));
        validBase(t, 1) = length(idxBaseL);
        % right baseline valid after outlier exclusion
        idxBaseR = find(dataBase.trialData.sub==t & ...
            ~isnan(dataBase.trialData.RtorsionVelT));
        validBase(t, 2) = length(idxBaseR);
        
        % both baseline valid after outlier exclusion
        idxBaseBoth = find(dataBase.trialData.sub==t & ...
            ~isnan(dataBase.trialData.LtorsionVelT) & ~isnan(dataBase.trialData.RtorsionVelT));
        validBaseBoth(t, 1) = length(idxBaseBoth);        

        %% experiment
        for bN = 1:6
            % left exp eye valid
            load(['Exp' num2str(bN) '_Subject' num2str(t,'%.2i') '_Block' num2str(bN,'%.2i') '_L_errorFile.mat']);
            idxL = find(errorStatus~=0);
            if length(errorStatus)>48
                disp(['L, sub', num2str(t), ', exp block', num2str(bN)]);
            end
            invalidExpEye(t, 1) = invalidExpEye(t, 1)+length(idxL);
            
            % right exp eye valid
            load(['Exp' num2str(bN) '_Subject' num2str(t,'%.2i') '_Block' num2str(bN,'%.2i') '_R_errorFile.mat']);
            idxR = find(errorStatus~=0);
            if length(errorStatus)>48
                disp(['R, sub', num2str(t), ', exp block', num2str(bN)]);
            end
            invalidExpEye(t, 2) = invalidExpEye(t, 2)+length(idxR);
            
            % both exp eye valid
            idxExpEyeBoth = unique([idxL; idxR]);
            invalidExpEyeBoth(t, 1) = invalidExpEyeBoth(t, 1) + length(idxExpEyeBoth);
        end
        
        % left exp valid after outlier exclusion
        idxExpL = find(data3.trialData.sub==t & ...
            ~isnan(data3.trialData.LtorsionVelT));
        validExp(t, 1) = length(idxExpL);        
        % right exp valid after outlier exclusion
        idxExpR = find(data3.trialData.sub==t & ...
            ~isnan(data3.trialData.RtorsionVelT));
        validExp(t, 2) = length(idxExpR);
        
        % both exp valid after outlier exclusion
        idxExpBoth = find(data3.trialData.sub==t & ...
            ~isnan(data3.trialData.LtorsionVelT) & ~isnan(data3.trialData.RtorsionVelT));
        validExpBoth(t, 1) = length(idxExpBoth);
        
        % both-eyes experiment
        idxExpBothEye = find(trialDataBoth.sub==t & trialDataBoth.timeWindow==1);
        validExpBothEye(t, 1) = length(idxExpBothEye);
end
save('invalidTrials', 'invalidBaseEye', 'invalidBaseEyeBoth', 'invalidExpEye', 'invalidExpEyeBoth')

disp(['left: baseline eye excluded trial number: ', num2str(mean(invalidBaseEye(:, 1)/trialBaseAll)), ' +- ', num2str(std(invalidBaseEye(:, 1)/trialBaseAll))])
disp(['      exp eye excluded trial number: ', num2str(mean(invalidExpEye(:, 1)/trialExpAll)), ' +- ', num2str(std(invalidExpEye(:, 1)/trialExpAll))])
disp(['right: baseline eye excluded trial number: ', num2str(mean(invalidBaseEye(:, 2)/trialBaseAll)), ' +- ', num2str(std(invalidBaseEye(:, 2)/trialBaseAll))])
disp(['       exp eye excluded trial number: ', num2str(mean(invalidExpEye(:, 2)/trialExpAll)), ' +- ', num2str(std(invalidExpEye(:, 2)/trialExpAll))])
disp(['both valid eye: baseline trial number: ', num2str(mean(1-invalidBaseEyeBoth(:, 1)/trialBaseAll)), ' +- ', num2str(std(1-invalidBaseEyeBoth(:, 1)/trialBaseAll))])
disp(['                exp trial number: ', num2str(mean(1-invalidExpEyeBoth(:, 1)/trialExpAll)), ' +- ', num2str(std(1-invalidExpEyeBoth(:, 1)/trialExpAll))])

disp(['after outlier exclusion: left baseline excluded trial number: ', ...
    num2str(mean(1-validBase(:, 1)/trialBaseAll)), ' +- ', num2str(std(1-validBase(:, 1)/trialBaseAll))])
disp(['                         right baseline excluded trial number: ', ...
    num2str(mean(1-validBase(:, 2)/trialBaseAll)), ' +- ', num2str(std(1-validBase(:, 2)/trialBaseAll))])
disp(['                         both baseline valid trial number: ', ...
    num2str(mean(validBaseBoth(:, 1)/trialBaseAll)), ' +- ', num2str(std(validBaseBoth(:, 1)/trialBaseAll))])
disp(['                         left exp excluded trial number: ', ...
    num2str(mean(1-validExp(:, 1)/trialExpAll)), ' +- ', num2str(std(1-validExp(:, 1)/trialExpAll))])
disp(['                         right exp excluded trial number: ', ...
    num2str(mean(1-validExp(:, 2)/trialExpAll)), ' +- ', num2str(std(1-validExp(:, 2)/trialExpAll))])
disp(['                         both exp valid trial number: ', ...
    num2str(mean(validExpBoth(:, 1)/trialExpAll)), ' +- ', num2str(std(validExpBoth(:, 1)/trialExpAll))])
disp(['"Both-eyes" exp valid trial number: ', ...
    num2str(mean(validExpBothEye(:, 1)/trialExpAll)), ' +- ', num2str(std(validExpBothEye(:, 1)/trialExpAll))])

%% Correlation
% Individual trial-by-trial torsion&perception correlation
dataAllTrial = trialDataBoth;

for tw = 1:3
   figure
    for t = 1:size(names, 2)
        tempI = find(dataAllTrial.timeWindow==tw-2 & dataAllTrial.sub==t);
        dataT = dataAllTrial(tempI, :);
%         [tbtCorrVRho(t, tw) tbtCorrVpval(t, tw)] = corr(dataT.perceptualError, dataT.torsionVelTMerged);
%         [tbtCorrARho(t, tw) tbtCorrApval(t, tw)] = corr(dataT.perceptualError, dataT.torsionAngleMerged);
        subplot(2, 5, t)
        scatter(dataT.perceptualError, dataT.torsionVelT.*dataT.afterReversalD)
        
        % partial correlation... no reason to do this...
        [rho pval] = partialcorr([dataT.perceptualError, dataT.torsionVelT.*dataT.afterReversalD], dataT.rotationSpeed);
        tbtCorrVRho(t, tw) = rho(1, 2);
        tbtCorrVpval(t, tw) = pval(1, 2);
%         [rho pval] = partialcorr([dataT.perceptualError, dataT.torsionAngleMerged], dataT.rotationSpeed);
%         tbtCorrARho(t, tw) = rho(1, 2);
%         tbtCorrApval(t, tw) = pval(1, 2);
    end
end

tempI = find(tbtCorrVpval(:, 1)<0.05);
Vr1N = length(tempI)
meanVr1 = mean(tbtCorrVRho(tempI, 1))
stdVr1 = std(tbtCorrVRho(tempI, 1))

tempI = find(tbtCorrVpval(:, 2)<0.05);
Vr2N = length(tempI)
meanVr2 = mean(tbtCorrVRho(tempI, 2))
stdVr2 = std(tbtCorrVRho(tempI, 2))

tempI = find(tbtCorrVpval(:, 3)<0.05);
Vr3N = length(tempI)
meanVr3 = mean(tbtCorrVRho(tempI, 3))
stdVr3 = std(tbtCorrVRho(tempI, 3))