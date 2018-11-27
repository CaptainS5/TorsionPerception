% Xiuyun Wu, 11/26/2018
% getting the raw processed eye data... will be much more convenient for
% later analysis; from stimulus onset to stimulus offset
% need to correctly mark the time points! also whether the trial is
% valid
clear all; close all; clc

global trial

names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol' 'FScontrol' 'XWcontrol' 'SCcontrol' 'JFcontrol'};
conditions = [25 50 100 200];
cd ..
analysisF = pwd;
dataFolder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\TorsionPerception\data'};
trialPerCon = 72; % for each rotation speed, all directions together though...
totalBlocks = 6; % how many blocks in total
% eye data processing parameters
torsionThreshold = 8*ones(size(names));
tSacRemoveFrames = 3*ones(size(names)); 
% threshold for reverse saccade, exceeding how many frames before? and
% after?... check the code
eyeName = {'L' 'R'};

count = 1;
for subN = 1:length(names)
    cd(analysisF)
    % Subject details
    subject = names{subN};
    trialN = 1; % label the trial number so it would be easier to correspond perceptual, left eye, and right eye data
    
    for blockN = 1:totalBlocks
        errorsL = load(['Errorfiles\Exp' num2str(blockN) '_Subject' num2str(subN,'%.2i') '_Block' num2str(blockN,'%.2i') '_L_errorFile.mat']);
        errorsR = load(['Errorfiles\Exp' num2str(blockN) '_Subject' num2str(subN,'%.2i') '_Block' num2str(blockN,'%.2i') '_R_errorFile.mat']);
        % load response data for trial information
        dataFile = dir([dataFolder{:} '\' subject '\response' num2str(blockN) '_*.mat']);
        load([dataFolder{:} '\' subject '\' dataFile.name]) % resp is the response data for the current block
        
        for t = 1:size(resp, 1) % trial number
            eyeTrialData.sub(count, 1) = subN;
            eyeTrialData.trial(count, 1) = trialN;
            eyeTrialData.rotationSpeed(count, 1) = resp.rotationSpeed(t);
            eyeTrialData.afterReversalD(count, 1) = -resp.initialDirection(t); % 1=clockwise, -1=counterclockwise
            eyeTrialData.targetSide(count, 1) = resp.targetSide(t);
            
            %% left eye
            eye = 1;
            % read in data and socscalexy
            filename = ['session_' num2str(blockN,'%.2i') '_' eyeName{eye} '.dat'];
            data = readDataFile(filename, [dataFolder{:} '\' subject '\chronos']);
            data = socscalexy(data);
            [header, logData] = readLogFile(blockN, ['response' num2str(blockN,'%.2i') '_' subject] , [dataFolder{:} '\' subject]);
            sampleRate = 200;
            
            % setup trial
            trial = setupTrial(data, header, logData, t);
            trial.torsionFrames = tSacRemoveFrames(subN);
            
            find saccades;
            [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
            [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
            [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subN), 0);
            
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
            
            
            %% retinal torsion angle
            dataTemp.LtorsionPosition(count, 1) = nanmean(torsion.slowPhases.onsetPosition);
            
            %% torsion velocity
            dataTemp.LtorsionVelT(count, 1) = torsion.slowPhases.meanSpeed;
            
            %% torsion magnitude
            dataTemp.LtorsionAngleTotal(count, 1) = torsion.slowPhases.totalAngle;
            dataTemp.LtorsionAngleCW(count, 1) = torsion.slowPhases.totalAngleCW;
            dataTemp.LtorsionAngleCCW(count, 1) = -torsion.slowPhases.totalAngleCCW;
            
            %% saccade numbers
            dataTemp.LsacNumT(count, 1) = trial.saccades.T.number;
            dataTemp.LsacNumTCW(count, 1) = trial.saccades.T_CW.number;
            dataTemp.LsacNumTCCW(count, 1) = trial.saccades.T_CCW.number;
            
            %% saccade sum amplitudes
            dataTemp.LsacAmpSumT(count, 1) = trial.saccades.T.sum;
            dataTemp.LsacAmpSumTCW(count, 1) = trial.saccades.T_CW.sum;
            dataTemp.LsacAmpSumTCCW(count, 1) = trial.saccades.T_CCW.sum;
            
            %% saccade mean amplitudes
            dataTemp.LsacAmpMeanT(count, 1) = trial.saccades.T.meanAmplitude;
            dataTemp.LsacAmpMeanTCW(count, 1) = trial.saccades.T_CW.meanAmplitude;
            dataTemp.LsacAmpMeanTCCW(count, 1) = trial.saccades.T_CCW.meanAmplitude;
            
            %% right eye
            eye = 2;
            % read in data and socscalexy
            filename = ['session_' num2str(blockN,'%.2i') '_' eyeName{eye} '.dat'];
            data = readDataFile(filename, [dataFolder{:} '\' subject '\chronos']);
            data = socscalexy(data);
            [header, logData] = readLogFile(blockN, ['response' num2str(blockN,'%.2i') '_' subject] , [dataFolder{:} '\' subject]);
            sampleRate = 200;
            
            % get mean velocities
            % setup trial
            trial = setupTrial(data, header, logData, t);
            trial.torsionFrames = tSacRemoveFrames(subN);
            
            %% choose the time window here
            if strcmp(endName, 'atReversal') % at reversal
                trial.stim_onset = trial.stim_reversal; % reversal
                trial.stim_offset = trial.stim_reversal+ms2frames(40+120); % reversal
            elseif strcmp(endName, '120msToReversal')% 120ms to reversal
                trial.stim_onset = ms2frames(logData.fixationDuration(currentTrial)*1000+120); % 120ms latency
                trial.stim_offset = trial.stim_reversal; % reversal
            elseif strcmp(endName, '120msToEnd') % 120ms to end
                trial.stim_onset = trial.stim_reversal + ms2frames((0.12+0.04)*1000);
                trial.stim_offset = trial.stim_onset + ms2frames((logData.durationAfter(currentTrial)-0.12)*1000); % end of display
            end
            
            find saccades;
            [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
            [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
            [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subN), 0);
            
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
            
            
            %% retinal torsion angle
            dataTemp.RtorsionPosition(count, 1) = nanmean(torsion.slowPhases.onsetPosition);
            
            %% torsion velocity
            dataTemp.RtorsionVelT(count, 1) = torsion.slowPhases.meanSpeed;
            
            %% torsion magnitude
            dataTemp.RtorsionAngleTotal(count, 1) = torsion.slowPhases.totalAngle;
            dataTemp.RtorsionAngleCW(count, 1) = torsion.slowPhases.totalAngleCW;
            dataTemp.RtorsionAngleCCW(count, 1) = -torsion.slowPhases.totalAngleCCW;
            
            %% saccade numbers
            dataTemp.RsacNumT(count, 1) = trial.saccades.T.number;
            dataTemp.RsacNumTCW(count, 1) = trial.saccades.T_CW.number;
            dataTemp.RsacNumTCCW(count, 1) = trial.saccades.T_CCW.number;
            
            %% saccade sum amplitudes
            dataTemp.RsacAmpSumT(count, 1) = trial.saccades.T.sum;
            dataTemp.RsacAmpSumTCW(count, 1) = trial.saccades.T_CW.sum;
            dataTemp.RsacAmpSumTCCW(count, 1) = trial.saccades.T_CCW.sum;
            
            %% saccade mean amplitudes
            dataTemp.RsacAmpMeanT(count, 1) = trial.saccades.T.meanAmplitude;
            dataTemp.RsacAmpMeanTCW(count, 1) = trial.saccades.T_CW.meanAmplitude;
            dataTemp.RsacAmpMeanTCCW(count, 1) = trial.saccades.T_CCW.meanAmplitude;
            
            trialN = trialN+1;
            count = count+1;
        end
    end
end
cd([analysisF '\analysis functions'])
%     save(['eyeData.mat'], 'eyeTrialData');
