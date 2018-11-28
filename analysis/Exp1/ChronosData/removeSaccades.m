function [trial] = removeSaccades(trial)

trial.frames.X_noSac = trial.frames.X_filt;
trial.frames.Y_noSac = trial.frames.Y_filt;
trial.frames.DX_noSac = trial.frames.DX_filt;
trial.frames.DY_noSac = trial.frames.DY_filt;
trial.frames.DT_noSac = trial.frames.DT_filt;
trial.frames.DTUnfilt_noSac = trial.frames.DT;
trial.quickphaseFrames = false(trial.length,1);


for i = 1:length(trial.saccades.X.onsets)
    
    trial.frames.X_noSac(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i)) = NaN;
    trial.frames.Y_noSac(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i)) = NaN;
    trial.frames.DX_noSac(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i)) = NaN;
    trial.frames.DY_noSac(trial.saccades.X.onsets(i):trial.saccades.X.offsets(i)) = NaN;
    
end

for i = 1:length(trial.saccades.Y.onsets)
    
    trial.frames.X_noSac(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i)) = NaN;
    trial.frames.Y_noSac(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i)) = NaN;
    trial.frames.DX_noSac(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i)) = NaN;
    trial.frames.DY_noSac(trial.saccades.Y.onsets(i):trial.saccades.Y.offsets(i)) = NaN;
    
end

for i = 1:length(trial.saccades.T.onsets)
    
    trial.frames.DT_noSac(trial.saccades.T.onsets(i):trial.saccades.T.offsets(i)) = NaN;
    trial.frames.DTUnfilt_noSac(trial.saccades.T.onsets(i):trial.saccades.T.offsets(i)) = NaN;
    trial.quickphaseFrames(trial.saccades.T.onsets(i):trial.saccades.T.offsets(i)) = 1; % 1 for each frame that is a quickphase, 0 otherwise
    
end


end
