% Xiuyun Wu, 07/15/2019, anticipatory torsion control
% Exp3, one block baseline--no rotation, one block with rotation
% each block 200 trials; 5 rotational speed: 166, 173, 180, 187, 194
clear all; close all; clc

global trial

names = {'p1' 'p3' 'p4' 'p5' 'p7'};
load(['eyeTrialDataAll_R.mat']);
cd ..
analysisFolder = pwd;
cd ..
cd('data')
dataFolder = pwd;

%% all trials
trialData = table(); % organize into long format
for subN = 1:length(names)
        cd(analysisFolder)
        % Subject details
        subject = names{subN};
        % skip p2 for now
        if subN>=2 && subN<5
            subNtemp = subN+1;
        elseif subN==5
            subNtemp = 7;
        else
            subNtemp = subN;
        end
        
        countTemp = 1;
        dataTemp = table();
        for block = 1:2
            % read in experimental and eye data
            filename = ['session_' num2str(block, '%.2i') '_R.dat'];
            filelocation = [dataFolder '\' subject];
            data = readDataFile(filename, filelocation);
            data = socscalexy(data);
            
            logFile = dir([dataFolder '\' subject '\01_' subject '_b' num2str(block) '_*.txt']);
            [header, logData] = readLogFile(block, logFile.name , [dataFolder '\' subject]);
            sampleRate = 200;
            
            % load error file
            errors = load([analysisFolder '\Errorfiles\Exp3_Subject' num2str(subNtemp,'%.2i') '_Block' num2str(block,'%.2i') '_R_errorFile.mat']);
            
            for trialN = 1:size(logData.trial, 1) % trial number
                if errors.errorStatus(trialN)==0 % valid eye data trial
                    %% analyzeTrial
                    currentTrial = trialN;
                    
                    % setup trial
                    trial = setupTrial(data, header, logData, currentTrial);
                    pSacThreshold = 20;
                    if trial.log.rotationalDirection==0
                        tSacThreshold = 5;
                    else
                        tSacThreshold = 8;
                    end
                    
                    % find saccades
                    [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.startFrame, trial.endFrame, trial.frames.DX_filt, trial.frames.DDX_filt, pSacThreshold, 0);
                    [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.startFrame, trial.endFrame, trial.frames.DY_filt, trial.frames.DDY_filt, pSacThreshold, 0);
                    [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.startFrame, trial.endFrame, trial.frames.DT_filt, trial.frames.DDT_filt, tSacThreshold, 0);
                    
                    % analyze saccades
                    [trial] = analyzeSaccades(trial, saccades);
                    clear saccades;
                    % find pursuit onset
                    pursuit = socchange(trial);
                    
                    % remove saccades
                    trial = removeSaccades(trial);
                    
                    % analyze pursuit
                    pursuit = analyzePursuit(trial, pursuit);
                    
                    % analyze torsion
                    [torsion, trial] = analyzeTorsion(trial, pursuit);
                    %%%%%%%% end of analyzeTrial
                    
                    %% trial info
                    % trial info
                    dataTemp.sub(countTemp, 1) = subN;
                    dataTemp.trial(countTemp, 1) = trialN;
                    dataTemp.trialType(countTemp, 1) = block-1; % 0=baseline, 1=experimental trials
                    dataTemp.eye(countTemp, 1) = 2; % right eye
                    dataTemp.rotationSpeed(countTemp, 1) = logData.rotationalSpeed(trialN)*(1+logData.randomSpeed(trialN)/100); % the actual rotational speed after calculation
                    dataTemp.translationalSpeed(countTemp, 1) = logData.translationalSpeed(trialN);
                    dataTemp.slopeAngle(countTemp, 1) = logData.slopeAngle(trialN);
                    dataTemp.errorStatus(countTemp, 1) = errors.errorStatus(trialN);
                    dataTemp.translationalDirection(countTemp, 1) = logData.translationalDirection(trialN); % 1=right, -1=left
                    dataTemp.rotationalDirection(countTemp, 1) = logData.rotationalDirection(trialN); % 1=clockwise, -1=counterclockwise
                    dataTemp.choice(countTemp, 1) = logData.decision(trialN); % 1=faster, 0=slower
                    
                    %% eye data
                    % anticipatory window
                    trialNAll = 200*(block-1)+trialN;
                    startI = eyeTrialData.frameLog.stimOnset(subN, trialNAll)-0.05*sampleRate+1;
                    endI = eyeTrialData.frameLog.stimOnset(subN, trialNAll)+0.05*sampleRate;
                    % torsion velocity
                    dataTemp.torsionVel(countTemp, 1) = torsion.slowPhases.meanSpeed;
                    % anticipatory torsion velocity
                    dataTemp.anticipatoryTorsionVel(countTemp, 1) = nanmean(eyeTrialData.frames{subN, trialNAll}.DT_noSac(startI:endI));
                    
                    % torsion velocity gain
                    dataTemp.torsionVelGain(countTemp, 1) = torsion.slowPhases.meanSpeed/dataTemp.rotationSpeed(countTemp, 1);
                    
                    % anticipatory pursuit velocity
                    dataTemp.anticipatoryPursuitHVel(countTemp, 1) = nanmean(eyeTrialData.frames{subN, trialNAll}.DX_noSac(startI:endI));
                    
                    % horizontal pursuit velocity gain
                    dataTemp.pursuitHVelGain(countTemp, 1) = pursuit.gain;
                    
                    % torsion angle
%                     dataTemp.torsionAngleTotal(countTemp, 1) = torsion.slowPhases.totalAngle;
%                     dataTemp.torsionAngleCW(countTemp, 1) = torsion.slowPhases.totalAngleCW;
%                     dataTemp.torsionAngleCCW(countTemp, 1) = torsion.slowPhases.totalAngleCCW;
%                     %                         if dataTemp.afterReversalD(countLt, 1)==-1
%                     %                             dataTemp.torsionAngleSame(countLt, 1) = torsion.slowPhases.totalAngleCCW; % same as afterReversal angle
%                     %                             dataTemp.torsionAngleAnti(countLt, 1) = torsion.slowPhases.totalAngleCW; % opposite to afterReversal angle
%                     %                         else
%                     %                             dataTemp.torsionAngleSame(countLt, 1) = torsion.slowPhases.totalAngleCW; % same as afterReversal angle
%                     %                             dataTemp.torsionAngleAnti(countLt, 1) = torsion.slowPhases.totalAngleCCW; % opposite to afterReversal angle
%                     %                         end
%                     % just take the one that is not zero, if both
%                     % not zero, take the expected direction
%                     if torsion.slowPhases.totalAngleCW==0
%                         dataTemp.torsionAngle(countTemp, 1) = -torsion.slowPhases.totalAngleCCW;
%                     elseif torsion.slowPhases.totalAngleCCW==0
%                         dataTemp.torsionAngle(countTemp, 1) = torsion.slowPhases.totalAngleCW;
%                     elseif dataTemp.afterReversalD(countTemp, 1)*checkAngle==1
%                         dataTemp.torsionAngle(countTemp, 1) = torsion.slowPhases.totalAngleCW;
%                     elseif dataTemp.afterReversalD(countTemp, 1)*checkAngle==-1
%                         dataTemp.torsionAngle(countTemp, 1) = -torsion.slowPhases.totalAngleCCW;
%                     end
%                     
%                     % saccade numbers
%                     dataTemp.sacNumT(countTemp, 1) = trial.saccades.T.number;
%                     
%                     % saccade sum amplitudes
%                     dataTemp.sacAmpSumT(countTemp, 1) = trial.saccades.T.sum;
%                     
%                     % saccade mean amplitudes
%                     dataTemp.sacAmpMeanT(countTemp, 1) = trial.saccades.T.meanAmplitude;
                    
                    countTemp = countTemp+1;
                end
            end
        end
        trialData = [trialData; dataTemp];
end
cd([analysisFolder '\eyeAnalysis'])
save(['dataLongAll.mat'], 'trialData');

% generate CSV file to use in R
cd([analysisFolder '\R'])
writetable(trialData, 'trialDataAll.csv')