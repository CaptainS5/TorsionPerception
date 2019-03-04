function [trial] = removeSaccades(trial)

trial.frames.X_noSac = trial.frames.X_filt;
trial.frames.Y_noSac = trial.frames.X_filt;
trial.frames.DX_noSac = trial.frames.DX_filt;
trial.frames.DY_noSac = trial.frames.DY_filt;
trial.frames.DT_noSac = trial.frames.DT_filt;
trial.quickphaseFrames = false(trial.length,1);


for i = 1:length(trial.saccades.X.onsets)
    
    trial.frames.X_noSac(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i)) = NaN;
    trial.frames.Y_noSac(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i)) = NaN;
    trial.frames.DX_noSac(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i)) = NaN;
    trial.frames.DY_noSac(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i)) = NaN;
    
    % first we calculate the slope between the eye position at saccade on-
    % to saccade offset
    lengthSacX = trial.saccades.X.offsets(i) - trial.saccades.X.onsets(i);
    slopeX = (trial.frames.X_filt(trial.saccades.X.offsets(i))-trial.frames.X_filt(trial.saccades.X.onsets(i)))./lengthSacX;
    slopeDX = (trial.frames.DX_filt(trial.saccades.X.offsets(i))-trial.frames.DX_filt(trial.saccades.X.onsets(i)))./lengthSacX;
    slopeY = (trial.frames.Y_filt(trial.saccades.X.offsets(i))-trial.frames.Y_filt(trial.saccades.X.onsets(i)))./lengthSacX;
    slopeDY = (trial.frames.DY_filt(trial.saccades.X.offsets(i))-trial.frames.DY_filt(trial.saccades.X.onsets(i)))./lengthSacX;
    % and finally interpolate the eye position if we later want to plot
    % smooth eye movement traces
    for j = 1:lengthSacX+1
        trial.frames.X_interpolSac(trial.saccades.X.onsets(i)-1+j) = trial.frames.X_filt(trial.saccades.X.onsets(i)) + slopeX*j;
        trial.frames.Y_interpolSac(trial.saccades.X.onsets(i)-1+j) = trial.frames.Y_filt(trial.saccades.X.onsets(i)) + slopeY*j;
        trial.frames.DX_interpolSac(trial.saccades.X.onsets(i)-1+j) = trial.frames.DX_filt(trial.saccades.X.onsets(i)) + slopeDX*j;
        trial.frames.DY_interpolSac(trial.saccades.X.onsets(i)-1+j) = trial.frames.DY_filt(trial.saccades.X.onsets(i)) + slopeDY*j;
    end    
end

for i = 1:length(trial.saccades.Y.onsets)
    
    trial.frames.X_noSac(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i)) = NaN;
    trial.frames.Y_noSac(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i)) = NaN;
    trial.frames.DX_noSac(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i)) = NaN;
    trial.frames.DY_noSac(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i)) = NaN;
    
    % first we calculate the slope between the eye position at saccade on-
    % to saccade offset
    lengthSacY = trial.saccades.Y.offsets(i) - trial.saccades.Y.onsets(i);
    slopeX = (trial.frames.X_filt(trial.saccades.Y.offsets(i))-trial.frames.X_filt(trial.saccades.Y.onsets(i)))./lengthSacY;
    slopeDX = (trial.frames.DX_filt(trial.saccades.Y.offsets(i))-trial.frames.DX_filt(trial.saccades.Y.onsets(i)))./lengthSacY;
    slopeY = (trial.frames.Y_filt(trial.saccades.Y.offsets(i))-trial.frames.Y_filt(trial.saccades.Y.onsets(i)))./lengthSacY;
    slopeDY = (trial.frames.DY_filt(trial.saccades.Y.offsets(i))-trial.frames.DY_filt(trial.saccades.Y.onsets(i)))./lengthSacY;
    % and finally interpolate the eye position if we later want to plot
    % smooth eye movement traces
    for j = 1:lengthSacY+1
        trial.frames.X_interpolSac(trial.saccades.Y.onsets(i)-1+j) = trial.frames.X_filt(trial.saccades.Y.onsets(i)) + slopeX*j;
        trial.frames.Y_interpolSac(trial.saccades.Y.onsets(i)-1+j) = trial.frames.Y_filt(trial.saccades.Y.onsets(i)) + slopeY*j;
        trial.frames.DX_interpolSac(trial.saccades.Y.onsets(i)-1+j) = trial.frames.DX_filt(trial.saccades.Y.onsets(i)) + slopeDX*j;
        trial.frames.DY_interpolSac(trial.saccades.Y.onsets(i)-1+j) = trial.frames.DY_filt(trial.saccades.Y.onsets(i)) + slopeDY*j;
    end
end

for i = 1:length(trial.saccades.T.onsets)
    
    trial.frames.DT_noSac(trial.saccades.T.onsets(i):trial.saccades.T.offsets(i)) = NaN;
    trial.quickphaseFrames(trial.saccades.T.onsets(i):trial.saccades.T.offsets(i)) = 1; % 1 for each frame that is a quickphase, 0 otherwise
    
    % first we calculate the slope between the eye position at saccade on-
    % to saccade offset
    lengthSacT = trial.saccades.T.offsets(i) - trial.saccades.T.onsets(i);
%     slopeT = (trial.frames.T_filt(trial.saccades.T.offsets(i))-trial.frames.T_filt(trial.saccades.T.onsets(i)))./lengthSacT;
    slopeDT = (trial.frames.DT_filt(trial.saccades.T.offsets(i))-trial.frames.DT_filt(trial.saccades.T.onsets(i)))./lengthSacT;
    % and finally interpolate the eye position if we later want to plot
    % smooth eye movement traces
    for j = 1:lengthSacT+1
%         trial.frames.T_interpolSac(trial.saccades.T.onsets(i)-1+j) = trial.frames.T_filt(trial.saccades.T.onsets(i)) + slopeT*j;
        trial.frames.DT_interpolSac(trial.saccades.T.onsets(i)-1+j) = trial.frames.DT_filt(trial.saccades.T.onsets(i)) + slopeDT*j;
    end
end


end
