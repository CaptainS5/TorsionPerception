 % Xiuyun Wu, 07/15/2019, anticipatory torsion control
% getting the raw processed eye data... will be much more convenient for
% later analysis; from stimulus onset to stimulus offset
clear all; close all; clc

global trial

names = {'p1' 'p3' 'p4' 'p5' 'p7'};
cd ..
analysisFolder = pwd;
cd ..
cd('data')
dataFolder = pwd;

%% all trials
for subN = 1:length(names)
    % skip p2 for now
    if subN>=2 && subN<5
        subNtemp = subN+1;
    elseif subN==5
        subNtemp = 7;
    else
        subNtemp = subN;
    end
    cd(analysisFolder)
    % Subject details
    subject = names{subN};
    
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
            countTemp = 200*(block-1)+trialN;
            % trial info
            eyeTrialData.sub(subN, countTemp) = subN;
            eyeTrialData.trial(subN, countTemp) = trialN;
            eyeTrialData.trialType(subN, countTemp) = block-1; % 0=baseline, 1=experimental trials
            eyeTrialData.eye(subN, countTemp) = 2; % right eye
            eyeTrialData.rotationSpeed(subN, countTemp) = logData.rotationalSpeed(trialN)*(1+logData.randomSpeed(trialN)/100); % the actual rotational speed after calculation
            eyeTrialData.translationalSpeed(subN, countTemp) = logData.translationalSpeed(trialN);
            eyeTrialData.slopeAngle(subN, countTemp) = logData.slopeAngle(trialN);
            eyeTrialData.errorStatus(subN, countTemp) = errors.errorStatus(trialN);
            eyeTrialData.translationalDirection(subN, countTemp) = logData.translationalDirection(trialN); % 1=right, -1=left
            eyeTrialData.rotationalDirection(subN, countTemp) = logData.rotationalDirection(trialN); % 1=clockwise, -1=counterclockwise
            eyeTrialData.choice(subN, countTemp) = logData.decision(trialN); % 1=faster, 0=slower
            
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
                
                % eye data
                eyeTrialData.frameLog.stimOnset(subN, countTemp) = trial.stim_onset; % RDP onset
                eyeTrialData.frameLog.stimOffset(subN, countTemp) = trial.stim_offset; % RDP offset
                eyeTrialData.frameLog.startFrame(subN, countTemp) = trial.startFrame; % start from fixation, -500 ms from RDP onset
                eyeTrialData.frameLog.endFrame(subN, countTemp) = trial.endFrame;
                eyeTrialData.frameLog.length(subN, countTemp) = trial.length;
                eyeTrialData.frameLog.lostXframes{subN, countTemp} = trial.lostXframes;
                eyeTrialData.frameLog.lostYframes{subN, countTemp} = trial.lostYframes;
                eyeTrialData.frameLog.lostTframes{subN, countTemp} = trial.lostTframes;
                eyeTrialData.saccades{subN, countTemp} = trial.saccades;
                eyeTrialData.pursuit{subN, countTemp} = pursuit;
                eyeTrialData.torsion{subN, countTemp} = torsion;
                eyeTrialData.frames{subN, countTemp} = trial.frames;
            end
        end
    end
end

cd([analysisFolder '\eyeAnalysis'])
save(['eyeTrialDataAll_R.mat'], 'eyeTrialData');