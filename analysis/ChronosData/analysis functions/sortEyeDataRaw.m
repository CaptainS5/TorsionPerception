% Xiuyun Wu, 12/03/2018, Exp2
% getting the raw processed eye data... will be much more convenient for
% later analysis; from stimulus onset to stimulus offset
% need to correctly mark the time points! also whether the trial is
% valid
clear all; close all; clc

global trial

% names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol' 'FScontrol' 'XWcontrol' 'SCcontrol' 'JFcontrol'};
% conditions = [25 50 100 200];
names = {'test' 'test2'};
conditions = [50 200];
cd ..
analysisF = pwd;
dataFolder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1stYear\TorsionPerception\data'};
trialPerCon = 72; % for each rotation speed, all directions together though...
totalBlocks = 6; % how many blocks in total
% eye data processing parameters
torsionThreshold = 8*ones(size(names));
% tSacRemoveFrames = 3*ones(size(names));
% threshold for reverse saccade, exceeding how many consecutive frames
eyeName = {'R'};

%% Experiment trials
% count = 1;
% for eye = 1:2
%     eyeTrialData = [];
%     for subN = 1:length(names)
%         cd(analysisF)
%         % Subject details
%         subject = names{subN};
%         trialN = 1; % label the trial number so it would be easier to correspond perceptual, left eye, and right eye data
%         
%         for blockN = 1:totalBlocks
%             if eye==1
%                 errors = load(['Errorfiles\Exp' num2str(blockN) '_Subject' num2str(subN,'%.2i') '_Block' num2str(blockN,'%.2i') '_L_errorFile.mat']);
%             else
%                 errors = load(['Errorfiles\Exp' num2str(blockN) '_Subject' num2str(subN,'%.2i') '_Block' num2str(blockN,'%.2i') '_R_errorFile.mat']);
%             end
%             % load response data for trial information
%             dataFile = dir([dataFolder{:} '\' subject '\response' num2str(blockN) '_*.mat']);
%             load([dataFolder{:} '\' subject '\' dataFile.name]) % resp is the response data for the current block
%             
%             for t = 1:size(resp, 1) % trial number
%                 eyeTrialData.sub(subN, trialN) = subN;
%                 eyeTrialData.trial(subN, trialN) = trialN;
%                 eyeTrialData.eye(subN, trialN) = eye;
%                 eyeTrialData.rotationSpeed(subN, trialN) = resp.rotationSpeed(t);
%                 eyeTrialData.afterReversalD(subN, trialN) = -resp.initialDirection(t); % 1=clockwise, -1=counterclockwise
%                 eyeTrialData.targetSide(subN, trialN) = resp.targetSide(t);
%                 eyeTrialData.errorStatus(subN, trialN) = errors.errorStatus(t);
%                 
%                 % read in data and socscalexy
%                 filename = ['session_' num2str(blockN,'%.2i') '_' eyeName{eye} '.dat'];
%                 data = readDataFile(filename, [dataFolder{:} '\' subject '\chronos']);
%                 data = socscalexy(data);
%                 [header, logData] = readLogFile(blockN, ['response' num2str(blockN,'%.2i') '_' subject] , [dataFolder{:} '\' subject]);
%                 sampleRate = 200;
%                 
%                 % setup trial
%                 trial = setupTrial(data, header, logData, t);
%                 
%                 find saccades;
%                 [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
%                 [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
%                 [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subN), 0);
%                 
%                 % analyze saccades
%                 [trial] = analyzeSaccades(trial, saccades);
%                 clear saccades;
%                 
%                 % remove saccades
%                 trial = removeSaccades(trial);
%                 % end of setting up trial
%                 
%                 eyeTrialData.stim.onset(subN, trialN) = trial.stim_onset;
%                 eyeTrialData.stim.reversalOnset(subN, trialN) = trial.stim_reversalOnset;
%                 eyeTrialData.stim.reversalOffset(subN, trialN) = trial.stim_reversalOffset;
%                 eyeTrialData.stim.offset(subN, trialN) = trial.stim_offset;
%                 eyeTrialData.stim.beforeFrames(subN, trialN) = trial.stim_reversalOnset-trial.stim_onset; % for later alignment of velocity traces
%                 eyeTrialData.stim.afterFrames(subN, trialN) = trial.stim_offset-trial.stim_reversalOffset+1; % for later alignment of velocity traces
%                 eyeTrialData.frameLog.startFrame(subN, trialN) = trial.startFrame;
%                 eyeTrialData.frameLog.endFrame(subN, trialN) = trial.endFrame;
%                 eyeTrialData.frameLog.length(subN, trialN) = trial.length;
%                 eyeTrialData.frameLog.lostXframes{subN, trialN} = trial.lostXframes;
%                 eyeTrialData.frameLog.lostYframes{subN, trialN} = trial.lostYframes;
%                 eyeTrialData.frameLog.lostTframes{subN, trialN} = trial.lostTframes;
%                 eyeTrialData.frameLog.quickphaseFrames{subN, trialN} = trial.quickphaseFrames;
%                 eyeTrialData.saccades{subN, trialN} = trial.saccades;
%                 eyeTrialData.frames{subN, trialN} = trial.frames;
%                 
%                 trialN = trialN+1;
%                 %                 count = count+1;
%             end
%         end
%     end
%     cd([analysisF '\analysis functions'])
%     save(['eyeDataAll_', eyeName{eye}, '.mat'], 'eyeTrialData');
% end

%% Baseline trials
for eye = 1:1
    eyeTrialDataBase = [];
    for subN = 1:length(names)
        cd(analysisF)
        % Subject details
        subject = names{subN};
        trialN = 1; % label the trial number so it would be easier to correspond perceptual, left eye, and right eye data
        
        for blockN = 1:1
%             if eye==1
%                 errors = load(['Errorfiles\Exp0_Subject' num2str(subN,'%.2i') '_Block' num2str(blockN,'%.2i') '_L_errorFile.mat']);
%             else
                errors = load(['Errorfiles\Exp0_Subject' num2str(subN,'%.2i') '_Block' num2str(blockN,'%.2i') '_R_errorFile.mat']);
%             end
            % load response data for trial information
            dataFile = dir([dataFolder{:} '\' subject '\baselineTorsion\response' num2str(blockN) '_*.mat']);
            load([dataFolder{:} '\' subject '\baselineTorsion\' dataFile.name]) % resp is the response data for the current block
            
            for t = 1:size(resp, 1) % trial number
                eyeTrialDataBase.sub(subN, trialN) = subN;
                eyeTrialDataBase.trial(subN, trialN) = trialN;
                eyeTrialDataBase.eye(subN, trialN) = eye;
                eyeTrialDataBase.rotationSpeed(subN, trialN) = resp.rotationSpeed(t);
                eyeTrialDataBase.afterReversalD(subN, trialN) = -resp.initialDirection(t); % 1=clockwise, -1=counterclockwise
                eyeTrialDataBase.targetSide(subN, trialN) = resp.targetSide(t);
                eyeTrialDataBase.errorStatus(subN, trialN) = errors.errorStatus(t);
                
                % read in data and socscalexy
                filename = ['session_' num2str(blockN,'%.2i') '_' eyeName{eye} '.dat'];
                data = readDataFile(filename, [dataFolder{:} '\' subject '\baselineTorsion']);
                data = socscalexy(data);
                [header, logData] = readLogFile(blockN, ['response' num2str(blockN,'%.2i') '_' subject] , [dataFolder{:} '\' subject '\baselineTorsion']);
                sampleRate = 200;
                
                % setup trial
                trial = setupTrial(data, header, logData, t);
                
                find saccades;
                [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subN), 0);
                
                % analyze saccades
                [trial] = analyzeSaccades(trial, saccades);
                clear saccades;
                
                % remove saccades
                trial = removeSaccades(trial);
                % end of setting up trial
                
                eyeTrialDataBase.stim.onset(subN, trialN) = trial.stim_onset;
                eyeTrialDataBase.stim.reversalOnset(subN, trialN) = trial.stim_reversalOnset;
                eyeTrialDataBase.stim.reversalOffset(subN, trialN) = trial.stim_reversalOffset;
                eyeTrialDataBase.stim.offset(subN, trialN) = trial.stim_offset;
                eyeTrialDataBase.stim.beforeFrames(subN, trialN) = trial.stim_reversalOnset-trial.stim_onset; % for later alignment of velocity traces
                eyeTrialDataBase.stim.afterFrames(subN, trialN) = trial.stim_offset-trial.stim_reversalOffset+1; % for later alignment of velocity traces
                eyeTrialDataBase.frameLog.startFrame(subN, trialN) = trial.startFrame;
                eyeTrialDataBase.frameLog.endFrame(subN, trialN) = trial.endFrame;
                eyeTrialDataBase.frameLog.length(subN, trialN) = trial.length;
                eyeTrialDataBase.frameLog.lostXframes{subN, trialN} = trial.lostXframes;
                eyeTrialDataBase.frameLog.lostYframes{subN, trialN} = trial.lostYframes;
                eyeTrialDataBase.frameLog.lostTframes{subN, trialN} = trial.lostTframes;
                eyeTrialDataBase.frameLog.quickphaseFrames{subN, trialN} = trial.quickphaseFrames;
                eyeTrialDataBase.saccades{subN, trialN} = trial.saccades;
                eyeTrialDataBase.frames{subN, trialN} = trial.frames;
                
                trialN = trialN+1;
                %                 count = count+1;
            end
        end
    end
    cd([analysisF '\analysis functions'])
    save(['eyeDataAllBase_', eyeName{eye}, '.mat'], 'eyeTrialDataBase');
end