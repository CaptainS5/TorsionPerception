%% Get mean torsional velocity across all subjects, draw plots
% Xiuyun Wu, 11/26/2017
clear all; close all; clc

names = {'XWc' 'PHc' 'ARc'};
analysisF = pwd;
folder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\Torsion&perception\data'};
conditions0 = [40 80 120 160 200];
conditions1 = [20 40 80 140 200];
direction = [-1 1]; % initial direction; in the plot shows the direction after reversal
trialPerCon = 60; % for each flash onset, all directions together though...
eyeName = {'L' 'R'};

% first row is clockwise, second row is counterclockwise
% first column is left eye, second column is right eye
torsionVelT{1, 1} = nan(trialPerCon, length(conditions0), length(names));
torsionVelT{1, 2} = torsionVelT{1, 1};
torsionVelT{2, 1} = torsionVelT{1, 1};
torsionVelT{2, 2} = torsionVelT{1, 1};
sacNumT = torsionVelT;
sacAmpSumT = torsionVelT;
sacAmpMeanT = torsionVelT;
perceptualError = torsionVelT;
torsionVGain = torsionVelT;
% torsionAnt = nan(200,3,length(names));
% horizontalAnt = nan(200,3,length(names));
% torsionPursuit = nan(200,3,length(names));
% horizontalPursuit = nan(200,3,length(names));
numNonError{1} = zeros(length(names), length(conditions0));
numNonError{2} = numNonError{1};
tG = {}; % torsion gain
pE = {}; % perceptual error

for subj = 1:length(names)
    cd(analysisF)
    if subj <=2
        conditions = conditions0;
    else
        conditions = conditions1;
    end
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
                    analyzeTrial;
                    
                    dirIdx = find(direction==resp.initialDirection(t)); % 1-clockwise, 2-counterclockwise
                    
                    conIdx = find(conditions==resp.rotationSpeed(t));
                    counts{dirIdx}(conIdx) = counts{dirIdx}(conIdx)+1;
                    
                    startFrame = trial.stim_onset; % onset of rotation
                    endFrame = trial.stim_offset; % offset of flash & rotation
                    
                    %% perceptual error
                    tempI = find(isnan(perceptualError{dirIdx, eye}(:, conIdx, subj)), 1, 'first');
                    resp.reportAngle(t) = resp.reportAngle(t)-90;
                    if resp.reportAngle(t) < 0
                        resp.reportAngle(t) = resp.reportAngle(t)+180;
                    end
                    resp.reversalAngle(t) = resp.reversalAngle(t)-90;
                    if resp.reversalAngle(t) < 0
                        resp.reversalAngle(t) = resp.reversalAngle(t)+180;
                    end
                    perceptualError{dirIdx, eye}(tempI, conIdx, subj) = -(resp.reportAngle(t)-resp.reversalAngle(t))*resp.initialDirection(t);
                    
                    %% torsion velocity
                    tempI = find(isnan(torsionVelT{dirIdx, eye}(:, conIdx, subj)), 1, 'first');                    
                    torsionVelT{dirIdx, eye}(tempI, conIdx, subj) = nanmean(trial.frames.DT_filt(startFrame:endFrame));
                    
                    %% torsion velocity gain
                    tempI = find(isnan(torsionVGain{dirIdx, eye}(:, conIdx, subj)), 1, 'first');                    
                    torsionVGain{dirIdx, eye}(tempI, conIdx, subj) = nanmean(trial.frames.DT_filt(startFrame:endFrame))/conditions(conIdx);
                    
                    %% saccade numbers
                    tempI = find(isnan(sacNumT{dirIdx, eye}(:, conIdx, subj)), 1, 'first');
                    sacNumT{dirIdx, eye}(tempI, conIdx, subj) = trial.saccades.T.number;
                    
                    %% saccade sum amplitudes
                    tempI = find(isnan(sacAmpSumT{dirIdx, eye}(:, conIdx, subj)), 1, 'first');
                    sacAmpSumT{dirIdx, eye}(tempI, conIdx, subj) = trial.saccades.T.sum;
                    
                    %% saccade mean amplitudes
                    tempI = find(isnan(sacAmpMeanT{dirIdx, eye}(:, conIdx, subj)), 1, 'first');
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
            torsionVelMean{ii, eye, subj} = mean(nanmean(torsionVelT{ii, eye}(:, :, subj)), 3);
            torsionVelStd{ii, eye, subj} = std(nanmean(torsionVelT{ii, eye}(:, :, subj)),[],3);
            
            sacNumMean{ii, eye, subj} = mean(nanmean(sacNumT{ii, eye}(:, :, subj)), 3);
            sacNumStd{ii, eye, subj} = std(nanmean(sacNumT{ii, eye}(:, :, subj)),[],3);
            
            sacAmpSumMean{ii, eye, subj} = mean(nanmean(sacAmpSumT{ii, eye}(:, :, subj)), 3);
            sacAmpSumStd{ii, eye, subj} = std(nanmean(sacAmpSumT{ii, eye}(:, :, subj)),[],3);
            
            sacAmpMeanMean{ii, eye, subj} = mean(nanmean(sacAmpMeanT{ii, eye}(:, :, subj)), 3);
            sacAmpMeanStd{ii, eye, subj} = std(nanmean(sacAmpMeanT{ii, eye}(:, :, subj)),[],3);
        end
    end
    
    %% plot
    cd([analysisF '\torsionPlots'])
    % scatter plot of torsional velocity and perceptual errors in each speed
    figure('Units', 'Normalized', 'Position', [0 0 1 1])
    for ii = 1:size(conditions, 2)
        subplot(5, 2, ii*2-1)
        title(['L, speed ', num2str(conditions(ii))])
        scatter(torsionVGain{1, 1}(:, ii, subj), perceptualError{1, 1}(:, ii, subj))
        hold on
        scatter(torsionVGain{2, 1}(:, ii, subj), perceptualError{2, 1}(:, ii, subj))
%         legend({'Clockwise' 'Counterclockwise'})
        xlabel('Torsional velocity gain (deg/s)')
        ylabel('Perceptual error (deg)')
        
        subplot(5, 2, ii*2)
        title(['R, speed ', num2str(conditions(ii))])
        scatter(torsionVGain{1, 2}(:, ii, subj), perceptualError{1, 2}(:, ii, subj))
        hold on
        scatter(torsionVGain{2, 2}(:, ii, subj), perceptualError{2, 2}(:, ii, subj))
%         legend({'Clockwise' 'Counterclockwise'})
        xlabel('Torsional velocity gain (deg/s)')
        ylabel('Perceptual error (deg)')
    end
    print(gcf, ['scatterGainPerSpeed_' names{subj}], '-dpdf', '-fillpage')
    
    % scatter plot of torsional gain and perceptual errors
    figure('Units', 'Normalized', 'Position', [0 0 1 1])
    for eye = 1:2
        for dirI = 1:2
            for ii = 1:size(conditions, 2)
                tempIG = ~isnan(torsionVGain{dirI, eye}(:, ii, subj));
                tempIE = ~isnan(perceptualError{dirI, eye}(:, ii, subj));
                if ii==1
                    tG{dirI, eye, subj} = torsionVGain{dirI, eye}(tempIG==1, ii, subj);
                    pE{dirI, eye, subj} = perceptualError{dirI, eye}(tempIE==1, ii, subj);
                else
                    tG{dirI, eye, subj} = [tG{dirI, eye, subj}; torsionVGain{dirI, eye}(tempIG==1, ii, subj)];
                    pE{dirI, eye, subj} = [pE{dirI, eye, subj}; perceptualError{dirI, eye}(tempIE==1, ii, subj)];
                end
            end
        end
    end
    subplot(2, 1, 1)
    title(['L eye'])
    scatter(tG{1, 1, subj}, pE{1, 1, subj})
    hold on
    scatter(tG{2, 1, subj}, pE{2, 1, subj})
    legend({'Clockwise' 'Counterclockwise'})
    xlabel('Torsional velocity gain')
    ylabel('Perceptual error (deg)')
    
    subplot(2, 1, 2)
    title(['R eye'])
    scatter(tG{1, 2, subj}, pE{1, 2, subj})
    hold on
    scatter(tG{2, 2, subj}, pE{2, 2, subj})
    legend({'Clockwise' 'Counterclockwise'})
    xlabel('Torsional velocity gain')
    ylabel('Perceptual error (deg)')
    print(gcf, ['scatterGain_' names{subj}], '-dpdf', '-fillpage')
    
    % torsion velocity
    figure
    for eye = 1:2
        subplot(1, 2, eye)
        errorbar(conditions, torsionVelMean{1, eye, subj}, torsionVelStd{1, eye, subj})
        hold on
        errorbar(conditions, torsionVelMean{2, eye, subj}, torsionVelStd{2, eye, subj})
        legend({['Clockwise(' num2str(mean(numNonError{eye}(subj, :, 1))) ')'] ...
            ['Counterclockwise(' num2str(mean(numNonError{eye}(subj, :, 2))) ')']}, ...
            'box', 'off')
        xlabel('Rotation speed (deg/s)')
        ylabel('Torsion velocity (deg/s)')
        title([eyeName{eye}, ' eye'])
    end
    
    saveas(gca, ['torsionVelocity_' names{subj} '.pdf'])
    
    cd([analysisF '\SaccadePlots'])
    % saccade number
    figure
    for eye = 1:2
        subplot(1, 2, eye)
        errorbar(conditions, sacNumMean{1, eye, subj}, sacNumStd{1, eye, subj})
        hold on
        errorbar(conditions, sacNumMean{2, eye, subj}, sacNumStd{2, eye, subj})
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
        errorbar(conditions, sacAmpSumMean{1, eye, subj}, sacAmpSumStd{1, eye, subj})
        hold on
        errorbar(conditions, sacAmpSumMean{2, eye, subj}, sacAmpSumStd{2, eye, subj})
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
%         errorbar(conditions, sacAmpMeanMean{1, eye, subj}, sacAmpMeanStd{1, eye, subj})
%         hold on
%         errorbar(conditions, sacAmpMeanMean{2, eye, subj}, sacAmpMeanStd{2, eye, subj})
%         legend({['Clockwise(' num2str(mean(numNonError{eye}(subj, :, 1))) ')'] ...
%             ['Counterclockwise(' num2str(mean(numNonError{eye}(subj, :, 2))) ')']}, ...
%             'box', 'off')
%         xlabel('Flash onset (s)')
%         ylabel('Saccade mean amplitude (deg)')
%         title([eyeName{eye}, ' eye'])
%     end
%     
%     % saveas(gca, ['saccadeMeanAmplitude_' names{subj} '.pdf'])
%     close all
end

% plots across subjects