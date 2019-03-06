%% make sure that the trial number is not out of bound
% if currentTrial > header.trialsPerBlock
%     currentTrial = header.trialsPerBlock;
% elseif currentTrial < 1
%     currentTrial = 1;
% end

%% skip invalid trials
% if logData.choice==0
%     trial.valid = 0;
%     return
% end

%% setup trial
trial = setupTrial(data, header, logData, currentTrial);

find saccades;
[saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DX_filt, trial.frames.DDX_filt, 20, 0);
% [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, trial.stimulusMeanVelocity);
[saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
[saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset-40, min(trial.length, trial.stim_offset+40), trial.frames.DT_filt, trial.frames.DDT_filt, 8, 0);

% analyze saccades
[trial] = analyzeSaccades(trial, saccades);
clear saccades;
% %% find pursuit onset
% % pursuit = socchange(trial);
% 
% remove saccades
trial = removeSaccades(trial);

%% analyze pursuit
% pursuit = analyzePursuit(trial, pursuit);

%% analyze torsion
pursuit.onset = trial.stim_onset; % the frame to start torsion analysis
[torsion, trial] = analyzeTorsion(trial, pursuit);

% for i = 1:length(trial.saccades.T.onsets)
%     entry = [trial.frames.X_filt(trial.saccades.T.onsets(i)) trial.frames.S(trial.saccades.T.onsets(i))];
%     saccades.T_saccades = [saccades.T_saccades; entry];
% end

% for i = 1:length(trial.saccades.X.onsets)
%     xPosition = trial.frames.X_filt(trial.saccades.X.onsets(i));
%     yPosition = trial.frames.Y_filt(trial.saccades.X.onsets(i));
%     stimXPosition = trial.frames.S(trial.saccades.X.onsets(i));
%     stimYPosition = 0;
%     horizontalError = xPosition-stimXPosition;
%     verticalError = yPosition-stimYPosition;
%     posError = sqrt((horizontalError.^2 + verticalError.^2));
%     entry = [double(trial.log.subject)...
%         double(trial.log.eye)...
%         double(trial.log.block)...
%         double(trial.log.number)...
%         double(trial.log.natural)...
%         double(posError)];
%     positionError = [positionError; entry];
% end

%% analyze Listings Plane
% try
%     
%     %load(['LP_Exp' num2str(trial.log.experiment,'%.2d') '_Subj' num2str(trial.log.subject,'%.2d') '_Block' num2str(trial.log.block,'%.2d') '.mat']);
%     load('LP_Exp12_Subj02_Block01.mat');
%     listingsPlane = n;
%     trial.LP = trial.startFrame:trial.endFrame;
%     for i = trial.startFrame:trial.endFrame
%        trial.LP(i) = ListingTorsion([trial.frames.X_filt(i) trial.frames.Y_filt(i) trial.frames.T_filt(i)], listingsPlane(trial.log.eye+1,:));
%     end
%     
% 
% catch
%    disp('There is no ListingsPlane calculated for this block'); 
% end
