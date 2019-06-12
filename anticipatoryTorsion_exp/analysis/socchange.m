function [pursuit] = socchange(trial)

%% SETTINGS
settings.lengthOfPursuitInterval = ms2frames(300);

% SOCCHANGE
% routine to detect a direction change in the x/y pursuit trace
% calls function changeDetect
% changeDetect requires input x and y, where x is time and y are the data

% file checked and corrected on 02/23/09

% Feb 27, 2009:
% I'm currently not using X-/Y_filt with replaced saccades, because this
% only makes sense for the velocity trace. socchange and socposerr are
% based on position data, and therefore on X-/Y_sacc.

% this file needs changeDetect.m and evalPWL.m in the same folder!

%% x-value: TIME

startTime = trial.stim_onset-ms2frames(100); %Jolande: 260
endTime = min([trial.stim_onset+ms2frames(200) trial.saccades.firstSaccadeOnset]);
%Jolande: 80


if endTime-startTime < 10
    
    pursuit.onset = trial.saccades.firstSaccadeOffset;
    
else
    
    time = startTime:endTime;  % this leaves 300 ms for pursuit to start after stimulus onset (for shortest presentation duration, this means 200 ms after stimulus offset, for medium it means until stimulus offset)
    
    
    %% y-values: 2D position
    % 1. calculate mean fixation position in interval 100 ms before target
    % motion onset
    % fix_x = mean( DX(stim_onset-10:stim_onset) );
    % fix_y = mean( DY(stim_onset-10:stim_onset) );
    fix_x = mean( trial.frames.X_filt(trial.stim_onset-ms2frames(180):trial.stim_onset) );
    fix_y = mean( trial.frames.Y_filt(trial.stim_onset-ms2frames(180):trial.stim_onset) );
    
    % 2. calculate 2D vector relative to fixation position
    % dataxy_tmp = sqrt( (DX-fix_x).^2 + (DY-fix_y).^2 );
    dataxy_tmp = sqrt( (trial.frames.X_filt-fix_x).^2 + (trial.frames.Y_filt-fix_y).^2 );
    XY = dataxy_tmp(time);
    
    %% run it
    [cx,cy,ly,ry] = changeDetect(time,XY);
    
    %     slope_1 = ( (cy-ly)/(cx-time(1)) );
    %     slope_2 = ( (ry-cy)/(time(end)-cx) );
    %slope_diff = abs(slope_2 - slope_1);
    
    % new criterion, changed on Aug 4, 2009: mean eye velocity after onset has
    % to be larger than 5°/s
    % also, make sure that onset doesn't lie directly on saccade
    %if mean(DX_filt(round(cx):round(cx)+25)) >= 1 && ~isnan(X_saccmarker(round(cx))) && ~isnan(Y_saccmarker(round(cx)));
    % if isempty(TRUE_ONSET_X(stim_onset:stim_onset+20))
    pursuit.onset = round(cx); % cx is time
    % else
    %     OF_LAT(trial) = NaN;
    % end
    
    
    %     LAT = OF_LAT-trial.stim_onset; % LAT is in sample time from stim_onset


end