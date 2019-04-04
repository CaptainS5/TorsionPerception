% Xiuyun Wu, 03/08/2019
% Exp3, head tilt condition and different afterReversalD are critical
clear all; close all; clc

global trial

names = {'XW3' 'DC3' 'AR3' 'JF3' 'PK3' 'AD3' 'PH3'};
conditions = [200]; % rotationSpeed
% load('meanLatencyExp1')
cd ..
analysisF = pwd;
folder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1stYear\TorsionPerception\data'};
% folder = {'E:\XiuyunWu\Torsion-FDE\data'};
dirCons = [-1 1]; % initial direction; in the plot shows the direction after reversal
headCons = [-1 0 1]; % head tilt direction
headNames = {'CCW' 'Up' 'CW'};
trialPerCon = 20; % for each head tilt, directions separated
torsionThreshold = 6*ones(size(names));
torsionFrames = 3*ones(size(names));
eyeName = {'L' 'R'};
endNames = {'BeforeReversal' 'AfterReversal'};

cd ..
% load(['dataBase_all', num2str(size(names, 2)), '.mat'])
%% Experimental trials
for endN = 1:2
    if endN<=1 % before reversal
        checkAngle = -1;
    else % after reversal
        checkAngle = 1;
    end
    endName = endNames{endN};
    trialData = table(); % organize into long format
    trialPos = struct;
    countPos = 1;
    %     trialDeleted = zeros(1, length(names));
    for subj = 1:length(names)
        cd(analysisF)
        % Subject details
        subject = names{subj};
        counts = {zeros(size(conditions)) zeros(size(conditions))};
        
        countLt = 1;
        dataTemp = table();
        for block = 1:2
            %             errorsL = load(['Errorfiles\Exp' num2str(block) '_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_L_errorFile.mat']);
            errorsR = load(['Errorfiles\Exp3_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_R_errorFile.mat']);
            
            % load response data for trial information
            dataFile = dir([folder{:} '\' subject '\response' num2str(block) '_*.mat']);
            load([folder{:} '\' subject '\' dataFile.name]) % resp is the response data for the current block
            
            for t = 1:size(resp, 1) % trial number
                if errorsR.errorStatus(t)==0 && resp.rotationSpeed(t)~=0
                    eye = 2;
                    if countLt>1
                        dataTemp{countLt, :} = NaN;
                    end
                    dataTemp.sub(countLt, 1) = subj;
                    
                    dataTemp.rotationSpeed(countLt, 1) = resp.rotationSpeed(t);
                    dataTemp.afterReversalD(countLt, 1) = -resp.initialDirection(t); % 1-clockwise, -1 counterclockwise
                    dataTemp.headTilt(countLt, 1) = resp.headTilt(t);
                    
                    %% perceptual error
                    resp.reportAngle(t) = resp.reportAngle(t)-90;
                    if resp.reportAngle(t) < 0
                        resp.reportAngle(t) = resp.reportAngle(t)+180;
                    end
                    resp.reversalAngle(t) = resp.reversalAngle(t)-90;
                    if resp.reversalAngle(t) < 0
                        resp.reversalAngle(t) = resp.reversalAngle(t)+180;
                    end
                    %                     idxBase = find(dataBase.sub==subj & dataBase.headTilt==resp.headTilt(t));
                    %                     baseAngle = dataBase.baseMeanAngle(idxBase, 1);
                    
                    dataTemp.perceptualError(countLt, 1) = -(resp.reportAngle(t)-resp.reversalAngle(t))*resp.initialDirection(t);
                    
                    currentTrial = t;
                    eye = 2;
                    % read in data and socscalexy
                    filename = ['session_' num2str(block,'%.2i') '_' eyeName{eye} '.dat'];
                    data = readDataFile(filename, [folder{:} '\' subject]);
                    data = socscalexy(data);
                    [header, logData] = readLogFile(block, ['response' num2str(block,'%.2i') '_' subject] , [folder{:} '\' subject]);
                    sampleRate = 200;
                    
                    % get mean velocities
                    % setup trial
                    trial = setupTrial(data, header, logData, currentTrial);
                    trial.torsionFrames = torsionFrames(subj);
                    
                    %% choose the time window here
                    tempLatency = 0.15;% meanLatency(conIdx);
                    if strcmp(endName, 'AtReversal') % at reversal
                        trial.stim_onset = trial.stim_reversalOnset; % reversal
                        trial.stim_offset = trial.stim_reversalOnset + ms2frames(tempLatency*1000); % reversal
                    elseif strcmp(endName, 'BeforeReversal')
                        trial.stim_onset = ms2frames((logData.fixationDuration(currentTrial)+tempLatency)*1000); % 120ms latency
                        trial.stim_offset = trial.stim_reversalOnset; % reversal
                    elseif strcmp(endName, 'AfterReversal')
                        trial.stim_onset = trial.stim_reversalOnset + ms2frames(tempLatency*1000);
                        trial.stim_offset = trial.stim_reversalOffset + ms2frames(logData.durationAfter(currentTrial)*1000-50); % end of display
                    end
                    
                    find saccades;
                    [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                    [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                    [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subj), 0);
                    
                    % analyze saccades
                    [trial] = analyzeSaccades(trial, saccades);
                    clear saccades;
                    
                    % remove saccades
                    trial = removeSaccades(trial);
                    
                    %% analyze torsion
                    pursuit.onset = trial.stim_onset; % the frame to start torsion analysis
                    [torsion, trial] = analyzeTorsion(trial, pursuit);
                    % end of analyzeTrial
                    
                    startFrame = trial.stim_onset;
                    endFrame = trial.stim_offset;
                    
                    %                             if abs(torsion.slowPhases.meanSpeed)<20
                    
                    %% retinal torsion angle
                    dataTemp.torsionPosition(countLt, 1) = nanmean(trial.frames.T_filt(trial.stim_reversalOffset:(trial.stim_reversalOffset+8)))-nanmean(trial.frames.T_filt((trial.stim_onset-20):trial.stim_onset));
                    
                    %% torsion velocity
                    dataTemp.torsionVelT(countLt, 1) = torsion.slowPhases.meanSpeed;
                    
                    %% torsion magnitude
                    dataTemp.torsionAngleTotal(countLt, 1) = torsion.slowPhases.totalAngle;
                    dataTemp.torsionAngleCW(countLt, 1) = torsion.slowPhases.totalAngleCW;
                    dataTemp.torsionAngleCCW(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                    % just take the one that is not zero, if both
                    % not zero, take the expected direction
                    if torsion.slowPhases.totalAngleCW==0
                        dataTemp.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                    elseif torsion.slowPhases.totalAngleCCW==0
                        dataTemp.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                    elseif dataTemp.afterReversalD(countLt, 1)*checkAngle==1
                        dataTemp.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                    elseif dataTemp.afterReversalD(countLt, 1)*checkAngle==-1
                        dataTemp.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                    end
                    
                    %% saccade numbers
                    dataTemp.sacNumT(countLt, 1) = trial.saccades.T.number;
                    dataTemp.sacNumTCW(countLt, 1) = trial.saccades.T_CW.number;
                    dataTemp.sacNumTCCW(countLt, 1) = trial.saccades.T_CCW.number;
                    
                    %% saccade sum amplitudes
                    dataTemp.sacAmpSumT(countLt, 1) = trial.saccades.T.sum;
                    dataTemp.sacAmpSumTCW(countLt, 1) = trial.saccades.T_CW.sum;
                    dataTemp.sacAmpSumTCCW(countLt, 1) = trial.saccades.T_CCW.sum;
                    
                    %% saccade mean amplitudes
                    dataTemp.sacAmpMeanT(countLt, 1) = trial.saccades.T.meanAmplitude;
                    dataTemp.sacAmpMeanTCW(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                    dataTemp.sacAmpMeanTCCW(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
                    %                             end
                    countLt = countLt+1;
                elseif errorsR.errorStatus(t)==0 && resp.rotationSpeed(t)==0
                    trialPos.sub(countPos, 1) = subj; % currently just get all position data... to see for later
                    trialPos.rotationSpeed(countPos, 1) = resp.rotationSpeed(t);
                    trialPos.afterReversalD(countPos, 1) = -resp.initialDirection(t); % 1-clockwise, -1 counterclockwise
                    trialPos.headTilt(countPos, 1) = resp.headTilt(t);
                    trialPos.stim.onset(countPos, 1) = trial.stim_onset;
                    trialPos.stim.offset(countPos, 1) = trial.stim_offset;
                    trialPos.frameLog.startFrame(countPos, 1) = trial.startFrame;
                    trialPos.frameLog.endFrame(countPos, 1) = trial.endFrame;
                    trialPos.frameLog.length(countPos, 1) = trial.length;
                    trialPos.frames{countPos, 1} = trial.frames;
                    countPos = countPos + 1;
                end
            end
        end
        trialData = [trialData; dataTemp];
    end
    % end
    cd([analysisF '\analysis functions'])
    save(['dataLong', endName, '.mat'], 'trialData', 'trialPos'); %, 'trialDeleted');
end

%% Baseline
trialDataBase = table(); % organize into long format
trialPosBase = struct;
countPos = 1;
%     trialDeleted = zeros(1, length(names));
for subj = 1:length(names)
    cd(analysisF)
    % Subject details
    subject = names{subj};
    counts = {zeros(size(conditions)) zeros(size(conditions))};
    
    countLt = 1;
    dataTemp = table();
    for block = 1:2
        %             errorsL = load(['Errorfiles\Exp' num2str(block) '_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_L_errorFile.mat']);
        errorsR = load(['Errorfiles\Exp0_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_R_errorFile.mat']);
        
        % load response data for trial information
        dataFile = dir([folder{:} '\' subject '\baselineTorsion\response' num2str(block) '_*.mat']);
        load([folder{:} '\' subject '\baselineTorsion\' dataFile.name]) % resp is the response data for the current block
        
        for t = 1:size(resp, 1)-1 % trial number
            if errorsR.errorStatus(t)==0 && resp.rotationSpeed(t)~=0
                eye = 2;
                if countLt>1
                    dataTemp{countLt, :} = NaN;
                end
                dataTemp.sub(countLt, 1) = subj;
                
                dataTemp.rotationSpeed(countLt, 1) = resp.rotationSpeed(t);
                dataTemp.afterReversalD(countLt, 1) = -resp.initialDirection(t); % 1-clockwise, -1 counterclockwise
                dataTemp.headTilt(countLt, 1) = resp.headTilt(t);
                
                currentTrial = t;
                eye = 2;
                % read in data and socscalexy
                filename = ['session_' num2str(block,'%.2i') '_' eyeName{eye} '.dat'];
                data = readDataFile(filename, [folder{:} '\' subject '\baselineTorsion']);
                data = socscalexy(data);
                [header, logData] = readLogFile(block, ['response' num2str(block,'%.2i') '_' subject] , [folder{:} '\' subject '\baselineTorsion']);
                sampleRate = 200;
                
                % get mean velocities
                % setup trial
                trial = setupTrial(data, header, logData, currentTrial);
                trial.torsionFrames = torsionFrames(subj);
                
                %% choose the time window here
                tempLatency = 0.15;% meanLatency(conIdx);
                
                trial.stim_onset = ms2frames(tempLatency*1000); % 120ms latency
                trial.stim_offset = trial.stim_onset + ms2frames(2.5*1000); % end of display
                
                find saccades;
                [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, min(trial.length, trial.stim_offset+40), trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset, min(trial.length, trial.stim_offset+40), trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset, min(trial.length, trial.stim_offset+40), trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subj), 0);
                
                % analyze saccades
                [trial] = analyzeSaccades(trial, saccades);
                clear saccades;
                
                % remove saccades
                trial = removeSaccades(trial);
                
                %% analyze torsion
                pursuit.onset = trial.stim_onset; % the frame to start torsion analysis
                [torsion, trial] = analyzeTorsion(trial, pursuit);
                % end of analyzeTrial
                
                startFrame = trial.stim_onset;
                endFrame = trial.stim_offset-ms2frames(50);
                
                %                             if abs(torsion.slowPhases.meanSpeed)<20
                
                %                 %% retinal torsion angle during flash presentation
                %                 dataTemp.torsionPosition(countLt, 1) = nanmean(trial.frames.T_filt(trial.stim_reversalOnset:trial.stim_reversalOffset));
                
                %% torsion velocity
                dataTemp.torsionVelT(countLt, 1) = torsion.slowPhases.meanSpeed;
                
                %% torsion magnitude
                dataTemp.torsionAngleTotal(countLt, 1) = torsion.slowPhases.totalAngle;
                dataTemp.torsionAngleCW(countLt, 1) = torsion.slowPhases.totalAngleCW;
                dataTemp.torsionAngleCCW(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                % just take the one that is not zero, if both
                % not zero, take the expected direction
                if torsion.slowPhases.totalAngleCW==0
                    dataTemp.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                elseif torsion.slowPhases.totalAngleCCW==0
                    dataTemp.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                elseif dataTemp.afterReversalD(countLt, 1)==1
                    dataTemp.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                elseif dataTemp.afterReversalD(countLt, 1)==-1
                    dataTemp.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                end
                
                %% saccade numbers
                dataTemp.sacNumT(countLt, 1) = trial.saccades.T.number;
                dataTemp.sacNumTCW(countLt, 1) = trial.saccades.T_CW.number;
                dataTemp.sacNumTCCW(countLt, 1) = trial.saccades.T_CCW.number;
                
                %% saccade sum amplitudes
                dataTemp.sacAmpSumT(countLt, 1) = trial.saccades.T.sum;
                dataTemp.sacAmpSumTCW(countLt, 1) = trial.saccades.T_CW.sum;
                dataTemp.sacAmpSumTCCW(countLt, 1) = trial.saccades.T_CCW.sum;
                
                %% saccade mean amplitudes
                dataTemp.sacAmpMeanT(countLt, 1) = trial.saccades.T.meanAmplitude;
                dataTemp.sacAmpMeanTCW(countLt, 1) = trial.saccades.T_CW.meanAmplitude;
                dataTemp.sacAmpMeanTCCW(countLt, 1) = trial.saccades.T_CCW.meanAmplitude;
                %                             end
                countLt = countLt+1;
            elseif errorsR.errorStatus(t)==0 && resp.rotationSpeed(t)==0
                trialPosBase.sub(countPos, 1) = subj; % currently just get all position data... to see for later
                trialPosBase.rotationSpeed(countPos, 1) = resp.rotationSpeed(t);
                trialPosBase.afterReversalD(countPos, 1) = -resp.initialDirection(t); % 1-clockwise, -1 counterclockwise
                trialPosBase.headTilt(countPos, 1) = resp.headTilt(t);
                trialPosBase.stim.onset(countPos, 1) = trial.stim_onset;
                trialPosBase.stim.offset(countPos, 1) = trial.stim_offset;
                trialPosBase.frameLog.startFrame(countPos, 1) = trial.startFrame;
                trialPosBase.frameLog.endFrame(countPos, 1) = trial.endFrame;
                trialPosBase.frameLog.length(countPos, 1) = trial.length;
                trialPosBase.frames{countPos, 1} = trial.frames;
                countPos = countPos + 1;
            end
        end
    end
    trialDataBase = [trialDataBase; dataTemp];
end
% end
cd([analysisF '\analysis functions'])
save(['dataLongBase.mat'], 'trialDataBase', 'trialPosBase'); %, 'trialDeleted');