% Xiuyun Wu, 03/25/2018
clear all; close all; clc

% names = {'XWc' 'PHc' 'ARc' 'SMc' 'JFc' 'MSc'};
% conditions0 = [40 80 120 160 200];
% conditions1 = [20 40 80 140 200];
% conditions2 = [25 50 100 150 200];
% conditions3 = [25 50 100 200 400];
names = {'JL' 'RD' 'KK'};
conditions = [25 50 100 200 400];
cd ..
analysisF = pwd;
folder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\Torsion&perception\data'};
direction = [-1 1]; % initial direction; in the plot shows the direction after reversal
trialPerCon = 60; % for each flash onset, all directions together though...
eyeName = {'L' 'R'};
% change both paramters below, as well as time window in the loop
checkAngle = -1; % 1-for direction after reversal, -1 for direction before reversal
% for the endName, also change around line70 for the time window used
endName = '120msToReversal';
% endName = '120msAroundReversal';
% endName = '120msToEnd';

trialData = table(); % organize into long format
conData = table();
countLt = 1; % for trialData
countLc = 1; % for conData

for subj = 1:length(names)
    cd(analysisF)
%     if subj <=2
%         conditions = conditions0;
%     elseif subj<=3
%         conditions = conditions1;
%     elseif subj<=5
%         conditions = conditions2;
%     else
%         conditions = conditions3;
%     end
    for eye = 1:2
        % Subject details
        subject = names{subj};
        
        counts = {zeros(size(conditions)) zeros(size(conditions))};
        
        for block = 1:5
            % read in data and socscalexy
            filename = ['session_' num2str(block,'%.2i') '_' eyeName{eye} '.dat'];
            data = readDataFile(filename, [folder{:} '\' subject '\chronos']);
            data = socscalexy(data);
            [header, logData] = readLogFile(block, ['response' num2str(block,'%.2i') '_' subject] , [folder{:} '\' subject]);
            sampleRate = 200;
            
            % load raw perception data for trial exclusion
            dataFile = dir([folder{:} '\' subject '\response' num2str(block) '_*.mat']);
            load([folder{:} '\' subject '\' dataFile.name]) % resp is the response data for the current block
            
            % get mean velocities for each eye
            errors = load(['Errorfiles\Exp' num2str(block) '_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_' eyeName{eye} '_errorFile.mat']);
            
            for t = 1:size(resp, 1) % trial number
                if errors.errorStatus(t)==0 % valid trial
                    currentTrial = t;
                    % analyzeTrial
                    % setup trial
                    trial = setupTrial(data, header, logData, currentTrial);
                    %% change the time window here
                    trial.stim_onset = ms2frames(logData.fixationDuration(currentTrial)*1000+0.12); % 120ms latency
                    trial.stim_offset = trial.stim_onset + ms2frames((logData.durationBefore(currentTrial)-0.12)*1000); % reversal
%                     trial.stim_onset = trial.stim_reversal - ms2frames((0.12)*1000); % 120ms before reversal
%                     trial.stim_offset = trial.stim_reversal + ms2frames((0.12)*1000); % 120ms after reversal
%                     trial.stim_onset = trial.stim_reversal + ms2frames((0.12)*1000);
%                     trial.stim_offset = trial.stim_onset + ms2frames((logData.durationAfter(currentTrial)-0.12)*1000); % end of display
                    
                    find saccades;
                    [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                    % [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, trial.stimulusMeanVelocity);
                    [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                    [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DT_filt, trial.frames.DDT_filt, 10, 0);
                    
                    % analyze saccades
                    [trial] = analyzeSaccades(trial, saccades);
                    clear saccades;
                    
                    % remove saccades
                    trial = removeSaccades(trial);
                    
                    %% analyze torsion
                    pursuit.onset = trial.stim_onset; % the frame to start torsion analysis
                    [torsion, trial] = analyzeTorsion(trial, pursuit);
                    % end of analyzeTrial
                    
                    trialData.sub(countLt, 1) = subj;
                    trialData.eye(countLt, 1) = eye; % 1-left, 2-right
                    
                    dirIdx = find(direction==resp.initialDirection(t)); % 1-clockwise, 2-counterclockwise
                    conIdx = find(conditions==resp.rotationSpeed(t));
                    
                    trialData.rotationSpeed(countLt, 1) = resp.rotationSpeed(t);
                    trialData.afterReversalD(countLt, 1) = -direction(dirIdx); % 1-clockwise, -1 counterclockwise
                    
                    startFrame = trial.stim_onset;
                    endFrame = trial.stim_offset;
                    
                    %% perceptual error
                    resp.reportAngle(t) = resp.reportAngle(t)-90;
                    if resp.reportAngle(t) < 0
                        resp.reportAngle(t) = resp.reportAngle(t)+180;
                    end
                    resp.reversalAngle(t) = resp.reversalAngle(t)-90;
                    if resp.reversalAngle(t) < 0
                        resp.reversalAngle(t) = resp.reversalAngle(t)+180;
                    end
                    trialData.perceptualError(countLt, 1) = -(resp.reportAngle(t)-resp.reversalAngle(t))*resp.initialDirection(t);
                    
                    %% torsion velocity
                    trialData.torsionVelT(countLt, 1) = nanmean(trial.frames.DT_filt(startFrame:endFrame));
                    
                    %% torsion velocity gain
                    trialData.torsionVGain(countLt, 1) = nanmean(trial.frames.DT_filt(startFrame:endFrame))/conditions(conIdx);
                    
                    %% torsion magnitude
                    trialData.torsionAngleTotal(countLt, 1) = torsion.slowPhases.totalAngle;
                    trialData.torsionAngleCW(countLt, 1) = torsion.slowPhases.totalAngleCW;
                    trialData.torsionAngleCCW(countLt, 1) = torsion.slowPhases.totalAngleCCW;
                    if checkAngle == -1 % the same as direction before reversal
                        if trialData.afterReversalD(countLt, 1)==1 % direction after reversal is CW
                            trialData.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        else
                            trialData.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        end
                    elseif checkAngle == 1 % the same as direction after reversal
                        if trialData.afterReversalD(countLt, 1)==1 % direction after reversal is CW
                            trialData.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        else
                            trialData.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        end
                    end
                    
                    %% saccade numbers
                    trialData.sacNumT(countLt, 1) = trial.saccades.T.number;
                    
                    %% saccade sum amplitudes
                    trialData.sacAmpSumT(countLt, 1) = trial.saccades.T.sum;
                    
                    %% saccade mean amplitudes
                    trialData.sacAmpMeanT(countLt, 1) = trial.saccades.T.meanAmplitude;
                    
                    countLt = countLt+1;
                end
            end
        end
    end
    
    %%
    for ii = 1:2 % two directions
        for eye = 1:2
            for conI = 1:size(conditions, 2)
                conData.sub(countLc, 1) = subj;
                conData.eye(countLc, 1) = eye; % 1-left, 2-right
                conData.rotationSpeed(countLc, 1) = conditions(conI);
                conData.afterReversalD(countLc, 1) = -direction(ii); % 1-clockwise, -1 counterclockwise, direction after reversal
                
                tempI = find(all(trialData{:, 1:4}==repmat(conData{countLc, 1:4}, [size(trialData, 1) 1]), 2));
                
                conData.perceptualErrorMean(countLc, 1) = nanmean(trialData.perceptualError(tempI, 1));
                conData.perceptualErrorStd(countLc, 1) = nanstd(trialData.perceptualError(tempI, 1));
                
                conData.torsionVelTMean(countLc, 1) = nanmean(trialData.torsionVelT(tempI, 1));
                conData.torsionVelTStd(countLc, 1) = nanstd(trialData.torsionVelT(tempI, 1));
                
                conData.torsionVelTGainMean(countLc, 1) = nanmean(trialData.torsionVGain(tempI, 1));
                conData.torsionVelTGainStd(countLc, 1) = nanstd(trialData.torsionVGain(tempI, 1));
                
                conData.torsionAngleMean(countLc, 1) = nanmean(trialData.torsionAngle(tempI, 1));
                conData.torsionAngleStd(countLc, 1) = nanstd(trialData.torsionAngle(tempI, 1));
                
%                 conData.torsionAngleCWMean(countLc, 1) = nanmean(trialData.torsionAngleCW(tempI, 1));
%                 conData.torsionAngleCWStd(countLc, 1) = nanstd(trialData.torsionAngleCW(tempI, 1));
%                 
%                 conData.torsionAngleCCWMean(countLc, 1) = nanmean(trialData.torsionAngleCCW(tempI, 1));
%                 conData.torsionAngleCCWStd(countLc, 1) = nanstd(trialData.torsionAngleCCW(tempI, 1));
                
                conData.sacNumTMean(countLc, 1) = nanmean(trialData.sacNumT(tempI, 1));
                conData.sacNumTStd(countLc, 1) = nanstd(trialData.sacNumT(tempI, 1));
                
                conData.sacAmpSumTMean(countLc, 1) = nanmean(trialData.sacAmpSumT(tempI, 1));
                conData.sacAmpSumTStd(countLc, 1) = nanstd(trialData.sacAmpSumT(tempI, 1));
                
                conData.sacAmpMeanTMean(countLc, 1) = nanmean(trialData.sacAmpMeanT(tempI, 1));
                conData.sacAmpMeanTStd(countLc, 1) = nanstd(trialData.sacAmpMeanT(tempI, 1));
                
                conData.nonErrorTrialN(countLc, 1) = length(tempI);
                
                countLc = countLc+1;
            end
        end
    end
    
end

cd([analysisF '\analysis functions'])
% merge directions, mark as 0
trialData.torsionVelTMerged = trialData.torsionVelT.*trialData.afterReversalD;
trialData.torsionVGainMerged = trialData.torsionVGain.*trialData.afterReversalD;
trialData.torsionAngleMerged = trialData.torsionAngle.*trialData.afterReversalD;
countLc = size(conData, 1)+1;
for subj=1:size(names, 2)
    if subj <=2
        conditions = conditions0;
    elseif subj<=3
        conditions = conditions1;
    elseif subj<=5
        conditions = conditions2;
    else
        conditions = conditions3;
    end
    for eye = 1:2
        for ii = 1:size(conditions, 2)
            conData.sub(countLc, 1) = subj;
            conData.eye(countLc, 1) = eye; % 1-left, 2-right
            conData.rotationSpeed(countLc, 1) = conditions(ii);
            conData.afterReversalD(countLc, 1) = 0; % direction after reversal merged
            
            tempI = find(all(trialData{:, 1:3}==repmat(conData{countLc, 1:3}, [size(trialData, 1) 1]), 2));
            
            conData.perceptualErrorMean(countLc, 1) = nanmean(trialData.perceptualError(tempI, 1));
            conData.perceptualErrorStd(countLc, 1) = nanstd(trialData.perceptualError(tempI, 1));
            
            conData.torsionVelTMean(countLc, 1) = nanmean(trialData.torsionVelTMerged(tempI, 1));
            conData.torsionVelTStd(countLc, 1) = nanstd(trialData.torsionVelTMerged(tempI, 1));
            
            conData.torsionVelTGainMean(countLc, 1) = nanmean(trialData.torsionVGainMerged(tempI, 1));
            conData.torsionVelTGainStd(countLc, 1) = nanstd(trialData.torsionVGainMerged(tempI, 1));
            
            conData.torsionAngleMean(countLc, 1) = nanmean(trialData.torsionAngleMerged(tempI, 1));
            conData.torsionAngleStd(countLc, 1) = nanstd(trialData.torsionAngleMerged(tempI, 1));
%             
%             conData.torsionAngleCWMean(countLc, 1) = nanmean(trialData.torsionAngleCWMerged(tempI, 1));
%             conData.torsionAngleCWStd(countLc, 1) = nanstd(trialData.torsionAngleCWMerged(tempI, 1));
%             
%             conData.torsionAngleCCWMean(countLc, 1) = nanmean(trialData.torsionAngleCCWMerged(tempI, 1));
%             conData.torsionAngleCCWStd(countLc, 1) = nanstd(trialData.torsionAngleCCWMerged(tempI, 1));
            
            conData.sacNumTMean(countLc, 1) = nanmean(trialData.sacNumT(tempI, 1));
            conData.sacNumTStd(countLc, 1) = nanstd(trialData.sacNumT(tempI, 1));
            
            conData.sacAmpSumTMean(countLc, 1) = nanmean(trialData.sacAmpSumT(tempI, 1));
            conData.sacAmpSumTStd(countLc, 1) = nanstd(trialData.sacAmpSumT(tempI, 1));
            
            conData.sacAmpMeanTMean(countLc, 1) = nanmean(trialData.sacAmpMeanT(tempI, 1));
            conData.sacAmpMeanTStd(countLc, 1) = nanstd(trialData.sacAmpMeanT(tempI, 1));
            
            countLc = countLc+1;
        end
    end
end

% normalization
for ii = 1:size(conData, 1)
    if conData.afterReversalD(ii, 1)==0
        arr = find(all(trialData{:, 1:3}==repmat(conData{ii, 1:3}, [size(trialData, 1) 1]), 2));
        trialData.perceptualErrMergedNorm(arr, 1) = (trialData.perceptualError(arr, 1)-conData.perceptualErrorMean(ii, 1))./conData.perceptualErrorStd(ii, 1);
        trialData.torsionVelTMergedNorm(arr, 1) = (trialData.torsionVelTMerged(arr, 1)-conData.torsionVelTMean(ii, 1))./conData.torsionVelTStd(ii, 1);
    else
        arr = find(all(trialData{:, 1:4}==repmat(conData{ii, 1:4}, [size(trialData, 1) 1]), 2));
        trialData.perceptualErrNorm(arr, 1) = (trialData.perceptualError(arr, 1)-conData.perceptualErrorMean(ii, 1))./conData.perceptualErrorStd(ii, 1);
        trialData.torsionVelTNorm(arr, 1) = (trialData.torsionVelT(arr, 1)-conData.torsionVelTMean(ii, 1))./conData.torsionVelTStd(ii, 1);
    end
end

save(['dataLong', endName, '.mat'], 'trialData', 'conData');
