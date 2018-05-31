% sort baseline data
% Xiuyun Wu, 04/29/2018
clear all; close all; clc

global trial

names = {'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
conditions = [25 50 100 200 400];
startT = 1;
loadData = 0;
individualPlots = 1;
merged = 1;
torsionThreshold = [10 10 13 8 13 10 10];
torsionFrames = [5 3 3 3 3 3 3];
direction = [-1 1]; % rotation direction
trialPerCon = 10; % for each flash onset, all directions together though...
% eyeName = {'L' 'R'};
eyeName = {'R'};
% change both paramters below, as well as time window in the loop
% around line 100
% checkAngle = -1; % 1-for direction after reversal, -1 for direction before reversal
% for the endName, also change around line70 for the time window used
% endName = '120msToReversal';
% endName = '120msAroundReversal';
% endName = '120msToEnd';
endName = 'baseline';

if merged==0
    mergeName = 'notMerged';
else
    mergeName = 'merged';
end

cd ..
analysisF = pwd;
folder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\Torsion&perception\data'};

trialData = table(); % organize into long format
conData = table();
countLt = 1; % for trialData
countLc = 1; % for conData

if loadData==0
    for subj = 1:length(names)
        cd(analysisF)
        
        for eye = 1:size(eyeName, 2)
            % Subject details
            subject = names{subj};
            
            counts = {zeros(size(conditions)) zeros(size(conditions))};
            
            for block = 1:1 % only one block now
                % read in data and socscalexy
                filename = ['session_' num2str(block,'%.2i') '_' eyeName{eye} '.dat'];
                data = readDataFile(filename, [folder{:} '\' subject '\baselineTorsion']);
                data = socscalexy(data);
                [header, logData] = readLogFile(block, ['response' num2str(block,'%.2i') '_' subject] , [folder{:} '\' subject]);
                sampleRate = 200;
                header.trialsPerBlock = 50;
                
                % load raw perception data for trial exclusion
                dataFile = dir([folder{:} '\' subject '\baselineTorsion\response' num2str(block) '_*.mat']);
                load([folder{:} '\' subject '\baselineTorsion\' dataFile.name]) % resp is the response data for the current block
                
                % get mean velocities for each eye
                errors = load(['Errorfiles\Exp0_Subject' num2str(subj+8,'%.2i') '_Block' num2str(block,'%.2i') '_' eyeName{eye} '_errorFile.mat']);
                
                for t = 1:size(resp, 1) % trial number
                    if errors.errorStatus(t)==0 % valid trial
                        currentTrial = t;
                        
                        %                     %% analyzeTrial for excluding trials with unexpected torsion direction
                        %                     % setup trial
                        %                     trial = setupTrial(data, header, logData, currentTrial);
                        %
                        %                     trial.stim_onset = trial.stim_reversal + ms2frames((0.12)*1000);
                        %                     trial.stim_offset = trial.stim_onset + ms2frames((logData.durationAfter(currentTrial)-0.12)*1000); % end of display
                        %                     trial.torsionFrames = torsionFrames(subj);
                        %
                        %                     find saccades;
                        %                     [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                        %                     [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                        %                     [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subj), 0);
                        %
                        %                     % analyze saccades
                        %                     [trial] = analyzeSaccades(trial, saccades);
                        %                     clear saccades;
                        %
                        %                     % remove saccades
                        %                     trial = removeSaccades(trial);
                        %
                        %                     % analyze torsion
                        %                     pursuit.onset = trial.stim_onset; % the frame to start torsion analysis
                        %                     [torsion, trial] = analyzeTorsion(trial, pursuit);
                        %                     %% end of analyzeTrial for excluding trials with unexpected torsion direction
                        %
                        %                     if nanmean(trial.frames.DT_filt(trial.stim_onset:trial.stim_offset))*(-resp.initialDirection(t))>0 % not including trials with unexpected torsion direction
                        % analyzeTrial
                        % setup trial
                        trial = setupTrial(data, header, logData, currentTrial);
                        trial.torsionFrames = torsionFrames(subj);
                        
                        %% change the time window here
                        %                     trial.stim_onset = ms2frames(logData.fixationDuration(currentTrial)*1000+120); % 120ms latency
                        %                     trial.stim_offset = trial.stim_reversal; % reversal
                        %                     trial.stim_onset = trial.stim_reversal - ms2frames((0.12)*1000); % 120ms before reversal
                        %                     trial.stim_offset = trial.stim_reversal + ms2frames((0.12)*1000); % 120ms after reversal
                        trial.stim_onset = trial.stim_reversal - ms2frames((logData.durationBefore(currentTrial)-0.12)*1000); % latency after onset
                        trial.stim_offset = trial.stim_reversal + ms2frames(logData.durationAfter(currentTrial)*1000); % end of display
                        
                        find saccades;
                        [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
                        % [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, trial.stimulusMeanVelocity);
                        [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                        [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DT_filt, trial.frames.DDT_filt, torsionThreshold(subj), 0);
                        
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
                        if strcmp(eyeName{eye}, 'L')
                            trialData.eye(countLt, 1) = 1; % 1-left,
                        elseif strcmp(eyeName{eye}, 'R')
                            trialData.eye(countLt, 1) = 2; % 2-right
                        end
                        
                        dirIdx = find(direction==resp.initialDirection(t)); % 1-clockwise, 2-counterclockwise
                        conIdx = find(conditions==resp.rotationSpeed(t));
                        
                        trialData.rotationSpeed(countLt, 1) = resp.rotationSpeed(t);
                        trialData.afterReversalD(countLt, 1) = -direction(dirIdx); % 1-clockwise, -1 counterclockwise
                        % in the exp code, used the after reversal direction for rotation; so this is the
                        % rotation direction in each trial in baseline
                        
                        startFrame = trial.stim_onset;
                        endFrame = trial.stim_offset;
                        
                        %% torsion velocity
                        trialData.torsionVelT(countLt, 1) = torsion.slowPhases.meanSpeed;
                        
                        %% torsion velocity gain
                        trialData.torsionVGain(countLt, 1) = torsion.slowPhases.meanSpeed/conditions(conIdx);
                        
                        %% torsion magnitude
                        trialData.torsionAngleTotal(countLt, 1) = torsion.slowPhases.totalAngle;
                        trialData.torsionAngleCW(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        trialData.torsionAngleCCW(countLt, 1) = torsion.slowPhases.totalAngleCCW;
                        % just take the one that is not zero
                        if torsion.slowPhases.totalAngleCW==0
                            trialData.torsionAngle(countLt, 1) = -torsion.slowPhases.totalAngleCCW;
                        elseif torsion.slowPhases.totalAngleCCW==0
                            trialData.torsionAngle(countLt, 1) = torsion.slowPhases.totalAngleCW;
                        end
                        
                        %% saccade numbers
                        trialData.sacNumT(countLt, 1) = trial.saccades.T.number;
                        
                        %% saccade sum amplitudes
                        trialData.sacAmpSumT(countLt, 1) = trial.saccades.T.sum;
                        
                        %% saccade mean amplitudes
                        trialData.sacAmpMeanT(countLt, 1) = trial.saccades.T.meanAmplitude;
                        
                        countLt = countLt+1;
                        %                     end
                    end
                end
            end
        end
        
        %%
        for ii = 1:2 % two directions
            for eye = 1:size(eyeName, 2)
                for conI = 1:size(conditions, 2)
                    conData.sub(countLc, 1) = subj;
                    if strcmp(eyeName{eye}, 'L')
                        conData.eye(countLc, 1) = 1; % 1-left,
                    elseif strcmp(eyeName{eye}, 'R')
                        conData.eye(countLc, 1) = 2; % 2-right
                    end
                    conData.rotationSpeed(countLc, 1) = conditions(conI);
                    conData.afterReversalD(countLc, 1) = direction(ii); % 1-clockwise, -1 counterclockwise, direction after reversal
                    
                    tempI = find(all(trialData{:, 1:4}==repmat(conData{countLc, 1:4}, [size(trialData, 1) 1]), 2));
                    
                    conData.torsionVelTMean(countLc, 1) = nanmean(trialData.torsionVelT(tempI, 1));
                    conData.torsionVelTStd(countLc, 1) = nanstd(trialData.torsionVelT(tempI, 1));
                    
                    conData.torsionVelTGainMean(countLc, 1) = nanmean(trialData.torsionVGain(tempI, 1));
                    conData.torsionVelTGainStd(countLc, 1) = nanstd(trialData.torsionVGain(tempI, 1));
                    
                    conData.torsionAngleMean(countLc, 1) = nanmean(trialData.torsionAngle(tempI, 1));
                    conData.torsionAngleStd(countLc, 1) = nanstd(trialData.torsionAngle(tempI, 1));
                    
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
        for eye = 1:size(eyeName, 2)
            for ii = 1:size(conditions, 2)
                conData.sub(countLc, 1) = subj;
                if strcmp(eyeName{eye}, 'L')
                    conData.eye(countLc, 1) = 1; % 1-left,
                elseif strcmp(eyeName{eye}, 'R')
                    conData.eye(countLc, 1) = 2; % 2-right
                end
                conData.rotationSpeed(countLc, 1) = conditions(ii);
                conData.afterReversalD(countLc, 1) = 0; % direction after reversal merged
                
                tempI = find(all(trialData{:, 1:3}==repmat(conData{countLc, 1:3}, [size(trialData, 1) 1]), 2));
                
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
                
                conData.nonErrorTrialN(countLc, 1) = length(tempI);
                
                countLc = countLc+1;
            end
        end
    end
    
    % normalization
    for ii = 1:size(conData, 1)
        if conData.afterReversalD(ii, 1)==0
            arr = find(all(trialData{:, 1:3}==repmat(conData{ii, 1:3}, [size(trialData, 1) 1]), 2));
            trialData.torsionVelTMergedNorm(arr, 1) = (trialData.torsionVelTMerged(arr, 1)-conData.torsionVelTMean(ii, 1))./conData.torsionVelTStd(ii, 1);
        else
            arr = find(all(trialData{:, 1:4}==repmat(conData{ii, 1:4}, [size(trialData, 1) 1]), 2));
            trialData.torsionVelTNorm(arr, 1) = (trialData.torsionVelT(arr, 1)-conData.torsionVelTMean(ii, 1))./conData.torsionVelTStd(ii, 1);
        end
    end
    save(['dataBaseLong', endName, '.mat'], 'trialData', 'conData');
else
    cd([analysisF '\analysis functions'])
    load(['dataBaseLong', endName, '.mat']);
end

%% plots of individual data
if individualPlots==1
    for t = startT:size(names, 2)
        cd([analysisF '\baselinePlots'])
        % torsion velocity
        figure
        for eye = 1:size(eyeName, 2)
            subplot(1, size(eyeName, 2), eye)
            if strcmp(eyeName{eye}, 'L')
                eyeN = 1; % 1-left,
            elseif strcmp(eyeName{eye}, 'R')
                eyeN = 2; % 2-right
            end
            if merged==0
                tempIc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==1); % clockwise
                tempIcc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==-1); % counterclockwise
                [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
                [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
                tempDc = conData(tempIc, :);
                tempDcc = conData(tempIcc, :);
                
                errorbar(conditions, tempDc.torsionVelTMean(sortIc, 1), tempDc.torsionVelTStd(sortIc, 1), 'LineWidth', 1.5)
                hold on
                errorbar(conditions, tempDcc.torsionVelTMean(sortIcc, 1), tempDcc.torsionVelTStd(sortIcc, 1), 'LineWidth', 1.5)
                legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
                    ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
                    'box', 'off', 'FontSize', 10)
            else
                tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged
                [B sortI] = sort(conData.rotationSpeed(tempI));
                tempD = conData(tempI, :);
                
                errorbar(conditions, tempD.torsionVelTMean(sortI, 1), tempD.torsionVelTStd(sortI, 1), 'LineWidth', 1.5)
            end
            xlabel('Rotation speed (deg/s)')
            ylabel('Torsion velocity (deg/s)')
            set(gca, 'FontSize', 15, 'box', 'off')
            %             xlim([0 420])
            %             ylim([-2 2])
            if merged==0
                title([eyeName{eye}, ' eye']);
            else
                title([eyeName{eye}, ' eye, ', num2str(mean(tempD.nonErrorTrialN(sortI, 1))), ' trials'])
            end
        end
            saveas(gca, ['torsionVelocity_' names{t} '_' endName '_' mergeName '.pdf'])
        
        % torsion angle
        figure
        for eye = 1:size(eyeName, 2)
            subplot(1, size(eyeName, 2), eye)
            if strcmp(eyeName{eye}, 'L')
                eyeN = 1; % 1-left,
            elseif strcmp(eyeName{eye}, 'R')
                eyeN = 2; % 2-right
            end
            if merged==0
                tempIc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==1); % clockwise
                tempIcc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==-1); % counterclockwise
                [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
                [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
                tempDc = conData(tempIc, :);
                tempDcc = conData(tempIcc, :);
                
                errorbar(conditions, tempDc.torsionAngleMean(sortIc, 1), tempDc.torsionAngleStd(sortIc, 1), 'LineWidth', 1.5)
                hold on
                errorbar(conditions, tempDcc.torsionAngleMean(sortIcc, 1), tempDcc.torsionAngleStd(sortIcc, 1), 'LineWidth', 1.5)
                legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
                    ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
                    'box', 'off', 'FontSize', 10)
            else
                tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged
                [B sortI] = sort(conData.rotationSpeed(tempI));
                tempD = conData(tempI, :);
                
                errorbar(conditions, tempD.torsionAngleMean(sortI, 1), tempD.torsionAngleStd(sortI, 1), 'LineWidth', 1.5)
            end
            xlabel('Rotation speed (deg/s)')
            ylabel('Torsion angle (deg)')
            set(gca, 'FontSize', 15, 'box', 'off')
            %             xlim([0 420])
            %             ylim([-2 2])
            if merged==0
                title([eyeName{eye}, ' eye']);
            else
                title([eyeName{eye}, ' eye, ', num2str(mean(tempD.nonErrorTrialN(sortI, 1))), ' trials'])
            end
        end
        saveas(gca, ['torsionAngle_' names{t} '_' endName '_' mergeName '.pdf'])
        
        % saccade number
        figure
        for eye = 1:size(eyeName, 2)
            subplot(1, size(eyeName, 2), eye)
            if strcmp(eyeName{eye}, 'L')
                eyeN = 1; % 1-left,
            elseif strcmp(eyeName{eye}, 'R')
                eyeN = 2; % 2-right
            end
            if merged==0
                tempIc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==1); % clockwise
                tempIcc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==-1); % counterclockwise
                [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
                [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
                tempDc = conData(tempIc, :);
                tempDcc = conData(tempIcc, :);
                
                errorbar(conditions, tempDc.sacNumTMean(sortIc, 1), tempDc.sacNumTStd(sortIc, 1), 'LineWidth', 1.5)
                hold on
                errorbar(conditions, tempDcc.sacNumTMean(sortIcc, 1), tempDcc.sacNumTStd(sortIcc, 1), 'LineWidth', 1.5)
                legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
                    ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
                    'box', 'off', 'FontSize', 10, 'Location', 'northwest')
            else
                tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged
                [B sortI] = sort(conData.rotationSpeed(tempI));
                tempD = conData(tempI, :);
                
                errorbar(conditions, tempD.sacNumTMean(sortI, 1), tempD.sacNumTStd(sortI, 1), 'LineWidth', 1.5)
            end
            
            xlabel('Rotation speed (deg/s)')
            ylabel('Saccade number')
            if merged==0
                title([eyeName{eye}, ' eye']);
            else
                title([eyeName{eye}, ' eye, ', num2str(mean(tempD.nonErrorTrialN(sortI, 1))), ' trials'])
            end
        end
        saveas(gca, ['saccadeNumber_' names{t} '_' endName '_' mergeName '.pdf'])
        
        % saccade sum amplitude
        figure
        for eye = 1:size(eyeName, 2)
            subplot(1, size(eyeName, 2), eye)
            if strcmp(eyeName{eye}, 'L')
                eyeN = 1; % 1-left,
            elseif strcmp(eyeName{eye}, 'R')
                eyeN = 2; % 2-right
            end
            if merged==0
                tempIc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==1); % clockwise
                tempIcc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==-1); % counterclockwise
                [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
                [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
                tempDc = conData(tempIc, :);
                tempDcc = conData(tempIcc, :);
                
                errorbar(conditions, tempDc.sacAmpSumTMean(sortIc, 1), tempDc.sacAmpSumTStd(sortIc, 1), 'LineWidth', 1.5)
                hold on
                errorbar(conditions, tempDcc.sacAmpSumTMean(sortIcc, 1), tempDcc.sacAmpSumTStd(sortIcc, 1), 'LineWidth', 1.5)
                legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
                    ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
                    'box', 'off', 'FontSize', 10, 'Location', 'northwest')
            else
                tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged
                [Bc sortI] = sort(conData.rotationSpeed(tempI));
                tempD = conData(tempI, :);
                
                errorbar(conditions, tempD.sacAmpSumTMean(sortI, 1), tempD.sacAmpSumTStd(sortI, 1), 'LineWidth', 1.5)
            end
            
            xlabel('Rotation speed (deg/s)')
            ylabel('Saccade sum amplitude (deg)')
            if merged==0
                title([eyeName{eye}, ' eye']);
            else
                title([eyeName{eye}, ' eye, ', num2str(mean(tempD.nonErrorTrialN(sortI, 1))), ' trials'])
            end
        end
        saveas(gca, ['saccadeSumAmplitude_' names{t} '_' endName '_' mergeName '.pdf'])
        
        close all
    end
end

% % averaged plots
% if averagedPlots==1
%     cd([analysisF '\summaryPlots'])
%     %     % torsionV/perceptual error/torsionVGain vs. speed, scatter
% %     markerC = [77 255 202; 70 95 232; 232 123 70; 255 231 108; 255 90 255; 100 178 42]/255;
% %
% %         figure
% %         for eye = 1:size(eyeName, 2)
% %             subplot(1, size(eyeName, 2), eye);
% % if strcmp(eyeName{eye}, 'L')
% %                         eyeN = 1; % 1-left,
% %                     elseif strcmp(eyeName{eye}, 'R')
% %                         eyeN = 2; % 2-right
% %                     end
% %             for t = 1:size(names, 2)
% %                 tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
% %                 errorbar(conData.rotationSpeed(tempI), conData.torsionVelTMean(tempI), ...
% %                     conData.torsionVelTStd(tempI), 'LineStyle', 'None', ...
% %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
% %                 hold on
% %             end
% %             legend(names, 'box', 'off', 'Location', 'SouthWest')
% %             xlabel('Rotation speed(deg/s)')
% %             ylabel('Torsional velocity (deg/s)')
% %             xlim([0 420])
% %     %         ylim([-2 2])
% %             set(gca, 'FontSize', 15, 'box', 'off')
% %             title([eyeName{eye}, ' eye'])
% %         end
% %         saveas(gca, ['speedTorsion_' endName '_' mergeName '.pdf'])
% % %
% % %         figure
% % %         for eye = 1:size(eyeName, 2)
% % %             subplot(1, size(eyeName, 2), eye);
% % % if strcmp(eyeName{eye}, 'L')
% % %                         eyeN = 1; % 1-left,
% % %                     elseif strcmp(eyeName{eye}, 'R')
% % %                         eyeN = 2; % 2-right
% % %                     end
% % %             for t = 1:size(names, 2)
% % %                 tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
% % %                 errorbar(conData.rotationSpeed(tempI), conData.torsionVelTGainMean(tempI), ...
% % %                     conData.torsionVelTGainStd(tempI), 'LineStyle', 'None', ...
% % %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
% % %                 hold on
% % %             end
% % %             xlabel('Rotation speed(deg/s)')
% % %             ylabel('Torsional velocity gain')
% % %             xlim([0 420])
% % %     %         ylim([-0.03 0.08])
% % %             set(gca, 'FontSize', 15, 'box', 'off')
% % %             title([eyeName{eye}, ' eye'])
% % %         end
% % %         saveas(gca, ['speedTorsionGain_' endName '_' mergeName '.pdf'])
% %
% %     % torsion angle
% %     figure
% %     for eye = 1:size(eyeName, 2)
% %         subplot(1, size(eyeName, 2), eye);
% %         if strcmp(eyeName{eye}, 'L')
% %                         eyeN = 1; % 1-left,
% %                     elseif strcmp(eyeName{eye}, 'R')
% %                         eyeN = 2; % 2-right
% %                     end
% %         for t = 1:size(names, 2)
% %             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
% %             errorbar(conData.rotationSpeed(tempI), conData.torsionAngleMean(tempI), ...
% %                 conData.torsionAngleStd(tempI), 'LineStyle', 'None', ...
% %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
% %             hold on
% %         end
% %         xlabel('Rotation speed(deg/s)')
% %         ylabel('Torsion angle (deg)')
% %         xlim([0 420])
% % %         ylim([-1.5 3.5])
% %         set(gca, 'FontSize', 15, 'box', 'off')
% %         title([eyeName{eye}, ' eye'])
% %     end
% %     saveas(gca, ['speedTorsionAngle_' endName '_' mergeName '.pdf'])
%
%     % saccade vs. speed
%     % saccade sum amplitude
%     figure
%     for eye = 1:size(eyeName, 2)
%         subplot(1, size(eyeName, 2), eye);
% if strcmp(eyeName{eye}, 'L')
%                         eyeN = 1; % 1-left,
%                     elseif strcmp(eyeName{eye}, 'R')
%                         eyeN = 2; % 2-right
%                     end
%         for t = 1:size(names, 2)
%             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
%             errorbar(conData.rotationSpeed(tempI), conData.sacAmpSumTMean(tempI), ...
%                 conData.sacAmpSumTStd(tempI), 'LineStyle', 'None', ...
%                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
%             hold on
%         end
%         xlabel('Rotation speed(deg/s)')
%         ylabel('Saccade amplitude sum (deg)')
%         xlim([0 420])
% %         ylim([-1.5 3.5])
%         set(gca, 'FontSize', 15, 'box', 'off')
%         title([eyeName{eye}, ' eye'])
%     end
%     saveas(gca, ['speedSacAmpSum_' endName '_' mergeName '.pdf'])
%     % saccade number
%     figure
%     for eye = 1:size(eyeName, 2)
%         subplot(1, size(eyeName, 2), eye);
% if strcmp(eyeName{eye}, 'L')
%                         eyeN = 1; % 1-left,
%                     elseif strcmp(eyeName{eye}, 'R')
%                         eyeN = 2; % 2-right
%                     end
%         for t = 1:size(names, 2)
%             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
%             errorbar(conData.rotationSpeed(tempI), conData.sacNumTMean(tempI), ...
%                 conData.sacNumTStd(tempI), 'LineStyle', 'None', ...
%                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
%             hold on
%         end
%         xlabel('Rotation speed(deg/s)')
%         ylabel('Saccade number')
%         xlim([0 420])
% %         ylim([-1.5 3.5])
%         set(gca, 'FontSize', 15, 'box', 'off')
%         title([eyeName{eye}, ' eye'])
%     end
%     saveas(gca, ['speedSacNum_' endName '_' mergeName '.pdf'])
%     % saccade mean amplitude
%     figure
%     for eye = 1:size(eyeName, 2)
%         subplot(1, size(eyeName, 2), eye);
% if strcmp(eyeName{eye}, 'L')
%                         eyeN = 1; % 1-left,
%                     elseif strcmp(eyeName{eye}, 'R')
%                         eyeN = 2; % 2-right
%                     end
%         for t = 1:size(names, 2)
%             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
%             errorbar(conData.rotationSpeed(tempI), conData.sacAmpMeanTMean(tempI), ...
%                 conData.sacAmpMeanTStd(tempI), 'LineStyle', 'None', ...
%                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
%             hold on
%         end
%         xlabel('Rotation speed(deg/s)')
%         ylabel('Saccade amplitude mean (deg)')
%         xlim([0 420])
% %         ylim([-1.5 3.5])
%         set(gca, 'FontSize', 15, 'box', 'off')
%         title([eyeName{eye}, ' eye'])
%     end
%     saveas(gca, ['speedSacAmpMean_' endName '_' mergeName '.pdf'])
%
% %     close all
% end
