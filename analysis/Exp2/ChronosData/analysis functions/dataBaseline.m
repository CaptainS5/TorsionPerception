% sort baseline data
% Xiuyun Wu, 10/23/2018
% direction separated by side--left eye corresponds to stimulus on the
% left, right eye corresponding to the stimulus on the right...
clear all; close all; clc

global trial

% names = {'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
% names = {'XWcontrolTest' 'XWcontrolTest2' 'XWcontrolTest3'};
% conditions = [25 50 100 200 400];
names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol' 'FScontrol' 'XWcontrol' 'SCcontrol' 'JFcontrol'};
conditions = [25 50 100 200];
torsionThreshold = 8*ones(size(names));
torsionFrames = 3*ones(size(names));
direction = [-1 1]; % rotation direction
trialPerCon = 12; % for each rotation speed, all directions together though...
eyeName = {'L' 'R'};
load('meanLatencyExp1')

cd ..
analysisF = pwd;
folder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\TorsionPerception\data'};

trialData = table(); % organize into long format
trialDeleted = zeros(1, length(names));

for subj = 1:length(names)
    cd(analysisF)    
    % Subject details
    subject = names{subj};
    counts = {zeros(size(conditions)) zeros(size(conditions))};
    
    countLt = 1;
    dataTemp = table();
    for block = 1:1 % only one block now
        errorsL = load(['Errorfiles\Exp0_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_L_errorFile.mat']);
        errorsR = load(['Errorfiles\Exp0_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_R_errorFile.mat']);
        
        % load response data for trial information
        dataFile = dir([folder{:} '\' subject '\baselineTorsion\response' num2str(block) '_*.mat']);
        load([folder{:} '\' subject '\baselineTorsion\' dataFile.name]) % resp is the response data for the current block
        
        for t = 1:size(resp, 1) % trial number
            if errorsL.errorStatus(t)==0 || errorsR.errorStatus(t)==0
                if countLt>1
                    dataTemp{countLt, :} = NaN;
                end
                dataTemp.sub(countLt, 1) = subj;
                conIdx = find(conditions==resp.rotationSpeed(t));
                dataTemp.rotationSpeed(countLt, 1) = resp.rotationSpeed(t);
                currentTrial = t;
                
                if errorsL.errorStatus(t)==0 % valid trial                    
                    eye = 1;
                    % read in data and socscalexy
                    filename = ['session_' num2str(block,'%.2i') '_' eyeName{eye} '.dat'];
                    data = readDataFile(filename, [folder{:} '\' subject '\baselineTorsion']);
                    data = socscalexy(data);
                    [header, logData] = readLogFile(block, ['response' num2str(block,'%.2i') '_' subject] , [folder{:} '\' subject '\baselineTorsion']);
                    sampleRate = 200;
                    header.trialsPerBlock = 60;
                    
                    % get mean velocities
                    % setup trial
                    trial = setupTrial(data, header, logData, currentTrial);
                    trial.torsionFrames = torsionFrames(subj);
                    
                    %% choose the time window here
                    tempLatency = meanLatency(conIdx);
                    trial.stim_onset = trial.stim_reversalOnset - ms2frames((logData.durationBefore(currentTrial)-tempLatency)*1000); % latency after onset
                    trial.stim_offset = trial.stim_reversalOffset + ms2frames(logData.durationAfter(currentTrial)*1000); % end of display
                    
                    find saccades;
                    [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                    % [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, trial.stimulusMeanVelocity);
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

                    dirIdx = find(direction==resp.initialDirection(t)); % 1-clockwise, 2-counterclockwise

                    % this is the direction of the stimulus on the same side as the eye
                    if resp.targetSide(t)==-1 % same side
                        dataTemp.LsameSideAfterReversalD(countLt, 1) = -direction(dirIdx); % 1-clockwise, -1 counterclockwise
                    else % different side
                        dataTemp.LsameSideAfterReversalD(countLt, 1) = direction(dirIdx); % 1-clockwise, -1 counterclockwise
                    end
                    % in the exp code, used the after reversal direction for rotation; so this is the
                    % rotation direction in each trial in baseline
                    
                    startFrame = trial.stim_onset;
                    endFrame = trial.stim_offset;
                    
                    if abs(torsion.slowPhases.meanSpeed)<30
                        %% torsion velocity
                        dataTemp.LtorsionVelT(countLt, 1) = torsion.slowPhases.meanSpeed;
                        
                        %% torsion velocity gain
                        dataTemp.LtorsionVGain(countLt, 1) = torsion.slowPhases.meanSpeed/conditions(conIdx);
                        
                        %% torsion magnitude
                        dataTemp.LtorsionAngleTotal(countLt, 1) = torsion.slowPhases.totalAngle;
                        dataTemp.LtorsionAngleCW(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        dataTemp.LtorsionAngleCCW(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        
                        %% saccade numbers
                        dataTemp.LsacNumT(countLt, 1) = trial.saccades.T.number;
                        
                        %% saccade sum amplitudes
                        dataTemp.LsacAmpSumT(countLt, 1) = trial.saccades.T.sum;
                        
                        %% saccade mean amplitudes
                        dataTemp.LsacAmpMeanT(countLt, 1) = trial.saccades.T.meanAmplitude;
                        
                    end
                end
                if errorsR.errorStatus(t)==0 % valid trial
                    eye = 2;
                    % read in data and socscalexy
                    filename = ['session_' num2str(block,'%.2i') '_' eyeName{eye} '.dat'];
                    data = readDataFile(filename, [folder{:} '\' subject '\baselineTorsion']);
                    data = socscalexy(data);
                    [header, logData] = readLogFile(block, ['response' num2str(block,'%.2i') '_' subject] , [folder{:} '\' subject '\baselineTorsion']);
                    sampleRate = 200;
                    header.trialsPerBlock = 60;
                    
                    % get mean velocities for each eye
                    % setup trial
                    trial = setupTrial(data, header, logData, currentTrial);
                    trial.torsionFrames = torsionFrames(subj);
                    
                    %% change the time window here
                    tempLatency = meanLatency(conIdx);
                    trial.stim_onset = trial.stim_reversalOnset - ms2frames((logData.durationBefore(currentTrial)-tempLatency)*1000); % latency after onset
                    trial.stim_offset = trial.stim_reversalOffset + ms2frames(logData.durationAfter(currentTrial)*1000); % end of display
                    
                    find saccades;
                    [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                    % [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, trial.stimulusMeanVelocity);
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
                                        
                    dirIdx = find(direction==resp.initialDirection(t)); % 1-clockwise, 2-counterclockwise

                    % this is the direction of the stimulus on the same side as the eye
                    if resp.targetSide(t)==1 % same side
                        dataTemp.RsameSideAfterReversalD(countLt, 1) = -direction(dirIdx); % 1-clockwise, -1 counterclockwise
                    else % different side
                        dataTemp.RsameSideAfterReversalD(countLt, 1) = direction(dirIdx); % 1-clockwise, -1 counterclockwise
                    end
                    % in the exp code, used the after reversal direction for rotation; so this is the
                    % rotation direction in each trial in baseline
                    
                    startFrame = trial.stim_onset;
                    endFrame = trial.stim_offset;
                    
%                     if abs(torsion.slowPhases.meanSpeed)<30
                        %% torsion velocity
                        dataTemp.RtorsionVelT(countLt, 1) = torsion.slowPhases.meanSpeed;
                        
                        %% torsion velocity gain
                        dataTemp.RtorsionVGain(countLt, 1) = torsion.slowPhases.meanSpeed/conditions(conIdx);
                        
                        %% torsion magnitude
                        dataTemp.RtorsionAngleTotal(countLt, 1) = torsion.slowPhases.totalAngle;
                        dataTemp.RtorsionAngleCW(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        dataTemp.RtorsionAngleCCW(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        
                        %% saccade numbers
                        dataTemp.RsacNumT(countLt, 1) = trial.saccades.T.number;
                        
                        %% saccade sum amplitudes
                        dataTemp.RsacAmpSumT(countLt, 1) = trial.saccades.T.sum;
                        
                        %% saccade mean amplitudes
                        dataTemp.RsacAmpMeanT(countLt, 1) = trial.saccades.T.meanAmplitude;
%                     end
                end
                countLt = countLt+1;
            end
        end
    end
%     [dataTempL, trialDeletedTL, idxL] = cleanData(dataTemp, 'LtorsionVelT');
%     [dataTempR, trialDeletedTR, idxR] = cleanData(dataTemp, 'RtorsionVelT');
%     idxD = unique([idxL; idxR]);
%     dataTemp(idxD, :) = [];
%     trialDeleted(subj) = length(idxD);
    trialData = [trialData; dataTemp];
end
cd([analysisF '\analysis functions'])
save(['dataBaseLong.mat'], 'trialData'); %, 'trialDeleted');