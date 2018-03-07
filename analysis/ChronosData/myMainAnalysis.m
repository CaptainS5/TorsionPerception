%% Get mean torsional velocity across all subjects, draw plots
% Xiuyun Wu, 11/26/2017
clear all; close all; clc

names = {'XWb'};
folder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\Torsion&perception\data'};
conditions = [40 80 120 160 200];
direction = [-1 1];
trialPerCon = 60; % for each flash onset, all directions together though...
eyeName = {'L' 'R'};

% first row is clockwise, second row is counterclockwise
% first column is left eye, second column is right eye
torsionVelT{1, 1} = nan(trialPerCon, length(conditions), length(names));
torsionVelT{1, 2} = torsionVelT{1, 1};
torsionVelT{2, 1} = torsionVelT{1, 1};
torsionVelT{2, 2} = torsionVelT{1, 1};
sacNumT = torsionVelT;
sacAmpSumT = torsionVelT;
sacAmpMeanT = torsionVelT;
% torsionAnt = nan(200,3,length(names));
% horizontalAnt = nan(200,3,length(names));
% torsionPursuit = nan(200,3,length(names));
% horizontalPursuit = nan(200,3,length(names));
numNonError{1} = zeros(length(names), length(conditions));
numNonError{2} = numNonError{1};

for subj = 1:length(names)
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
            errors = load([folder{:} '\' subject '\chronos\Exp' num2str(block) '_Subject' num2str(subj,'%.2i') '_Block' num2str(block,'%.2i') '_' eyeName{eye} '_errorFile.mat']);
            
            for t = 1:size(resp, 1) % trial number
                if errors.errorStatus(t)==0 % valid trial
                    currentTrial = t;
                    analyzeTrial;
                    
                    dirIdx = find(direction==resp.initialDirection(t)); % 1-clockwise, 2-counterclockwise
                    
                    conIdx = find(conditions==resp.rotationSpeed(t));
                    counts{dirIdx}(conIdx) = counts{dirIdx}(conIdx)+1;
                    
                    startFrame = trial.stim_onset; % onset of rotation
                    endFrame = trial.stim_offset; % offset of flash & rotation
                    
                    %% torsion velocity
                    tempI = find(isnan(torsionVelT{dirIdx}(:, conIdx, subj)), 1, 'first');                    
                    torsionVelT{dirIdx, eye}(tempI, conIdx, subj) = nanmean(trial.frames.DT_filt(startFrame:endFrame));
                    
                    %% saccade numbers
                    tempI = find(isnan(sacNumT{dirIdx}(:, conIdx, subj)), 1, 'first');
                    sacNumT{dirIdx, eye}(tempI, conIdx, subj) = trial.saccades.T.number;
                    
                    %% saccade sum amplitudes
                    tempI = find(isnan(sacAmpSumT{dirIdx}(:, conIdx, subj)), 1, 'first');
                    sacAmpSumT{dirIdx, eye}(tempI, conIdx, subj) = trial.saccades.T.sum;
                    
                    %% saccade mean amplitudes
                    tempI = find(isnan(sacAmpMeanT{dirIdx}(:, conIdx, subj)), 1, 'first');
                    sacAmpMeanT{dirIdx, eye}(tempI, conIdx, subj) = trial.saccades.T.meanAmplitude;
                    
                end
            end
            
            numNonError{eye}(subj, :, 1) = counts{1}; % clockwise
            numNonError{eye}(subj, :, 2) = counts{2}; % counterclockwise
            end
        end
    
    %%
    for ii = 1:2 % two directions
        for eye = 1:2
            torsionVelMean{ii, eye} = mean(nanmean(torsionVelT{ii, eye}), 3);
            torsionVelStd{ii, eye} = std(nanmean(torsionVelT{ii, eye}),[],3);
            
            sacNumMean{ii, eye} = mean(nanmean(sacNumT{ii, eye}), 3);
            sacNumStd{ii, eye} = std(nanmean(sacNumT{ii, eye}),[],3);
            
            sacAmpSumMean{ii, eye} = mean(nanmean(sacAmpSumT{ii, eye}), 3);
            sacAmpSumStd{ii, eye} = std(nanmean(sacAmpSumT{ii, eye}),[],3);
            
            sacAmpMeanMean{ii, eye} = mean(nanmean(sacAmpMeanT{ii, eye}), 3);
            sacAmpMeanStd{ii, eye} = std(nanmean(sacAmpMeanT{ii, eye}),[],3);
        end
    end
    
    %% plot
    % torsion velocity
    figure
    for eye = 1:2
        subplot(1, 2, eye)
        errorbar(conditions, torsionVelMean{1, eye}, torsionVelStd{1, eye})
        hold on
        errorbar(conditions, torsionVelMean{2, eye}, torsionVelStd{2, eye})
        legend({['Clockwise(' num2str(mean(numNonError{eye}(subj, :, 1))) ')'] ...
            ['Counterclockwise(' num2str(mean(numNonError{eye}(subj, :, 2))) ')']}, ...
            'box', 'off')
        xlabel('Rotation speed (deg/s)')
        ylabel('Torsion velocity (deg/s)')
        title([eyeName{eye}, ' eye'])
    end
    
    saveas(gca, ['torsionVelocity_' names{subj} '.pdf'])
    
    % saccade number
    figure
    for eye = 1:2
        subplot(1, 2, eye)
        errorbar(conditions, sacNumMean{1, eye}, sacNumStd{1, eye})
        hold on
        errorbar(conditions, sacNumMean{2, eye}, sacNumStd{2, eye})
        legend({['Clockwise(' num2str(mean(numNonError{eye}(subj, :, 1))) ')'] ...
            ['Counterclockwise(' num2str(mean(numNonError{eye}(subj, :, 2))) ')']}, ...
            'box', 'off')
        xlabel('Rotation speed (deg/s)')
        ylabel('Saccade number')
        title([eyeName{eye}, ' eye'])
    end
    
    saveas(gca, ['saccadeNumber_' names{subj} '.pdf'])
    
    % saccade sum amplitude
    figure
    for eye = 1:2
        subplot(1, 2, eye)
        errorbar(conditions, sacAmpSumMean{1, eye}, sacAmpSumStd{1, eye})
        hold on
        errorbar(conditions, sacAmpSumMean{2, eye}, sacAmpSumStd{2, eye})
        legend({['Clockwise(' num2str(mean(numNonError{eye}(subj, :, 1))) ')'] ...
            ['Counterclockwise(' num2str(mean(numNonError{eye}(subj, :, 2))) ')']}, ...
            'box', 'off')
        xlabel('Rotation speed (deg/s)')
        ylabel('Saccade sum amplitude (deg)')
        title([eyeName{eye}, ' eye'])
    end
    
    saveas(gca, ['saccadeSumAmplitude_' names{subj} '.pdf'])
    
%     % saccade mean amplitude 
%     figure
%     for eye = 1:2
%         subplot(1, 2, eye)
%         errorbar(conditions, sacAmpMeanMean{1, eye}, sacAmpMeanStd{1, eye})
%         hold on
%         errorbar(conditions, sacAmpMeanMean{2, eye}, sacAmpMeanStd{2, eye})
%         legend({['Clockwise(' num2str(mean(numNonError{eye}(subj, :, 1))) ')'] ...
%             ['Counterclockwise(' num2str(mean(numNonError{eye}(subj, :, 2))) ')']}, ...
%             'box', 'off')
%         xlabel('Flash onset (s)')
%         ylabel('Saccade mean amplitude (deg)')
%         title([eyeName{eye}, ' eye'])
%     end
%     
%     % saveas(gca, ['saccadeMeanAmplitude_' names{subj} '.pdf'])
    
end