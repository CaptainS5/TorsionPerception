function [trial, saccades] = analyzeSaccades(trial, saccades)

%% split torsional saccades in CW and CCW
saccades.T_CCW.onsets = saccades.T.onsets(saccades.T.isMax);
saccades.T_CCW.offsets = saccades.T.offsets(saccades.T.isMax);
saccades.T_CW.onsets = saccades.T.onsets(~saccades.T.isMax);
saccades.T_CW.offsets = saccades.T.offsets(~saccades.T.isMax);

%% get first onsets and offsets
trial.saccades.X.firstOnset = min(saccades.X.onsets(saccades.X.onsets > trial.stim_onset));
trial.saccades.X.firstOffset = min(saccades.X.offsets(saccades.X.offsets > trial.stim_onset));

trial.saccades.Y.firstOnset = min(saccades.Y.onsets(saccades.Y.onsets > trial.stim_onset));
trial.saccades.Y.firstOffset = min(saccades.Y.offsets(saccades.Y.offsets > trial.stim_onset));

trial.saccades.T.firstOnset = min(saccades.T.onsets(saccades.T.onsets > trial.stim_onset));
trial.saccades.T.firstOffset = min(saccades.T.offsets(saccades.T.offsets > trial.stim_onset));

trial.saccades.firstSaccadeOnset = min([trial.saccades.X.firstOnset trial.saccades.Y.firstOnset]) - trial.stim_onset;
trial.saccades.firstSaccadeOffset = min([trial.saccades.X.firstOffset trial.saccades.Y.firstOffset]) - trial.stim_onset;

%% calculate saccade amplitudes
trial.saccades.X.amplitudes = abs(trial.frames.X_filt(saccades.X.offsets) - trial.frames.X_filt(saccades.X.onsets));
trial.saccades.Y.amplitudes = abs(trial.frames.Y_filt(saccades.Y.offsets) - trial.frames.Y_filt(saccades.Y.onsets));

trial.saccades.T_CCW.amplitudes = abs(trial.frames.T_filt(saccades.T_CCW.offsets) - trial.frames.T_filt(saccades.T_CCW.onsets));
trial.saccades.T_CW.amplitudes = abs(trial.frames.T_filt(saccades.T_CW.offsets) - trial.frames.T_filt(saccades.T_CW.onsets));

%% calculate saccades number
trial.saccades.X.number = length(saccades.X.onsets);
trial.saccades.Y.number = length(saccades.Y.onsets);
trial.saccades.T_CCW.number = length(saccades.T_CCW.onsets);
trial.saccades.T_CW.number = length(saccades.T_CW.onsets);
trial.saccades.T.number = trial.saccades.T_CCW.number + trial.saccades.T_CW.number;

%% calculate saccades sum (amplitudes)
trial.saccades.X.sum = sum(trial.saccades.X.amplitudes);
trial.saccades.Y.sum = sum(trial.saccades.Y.amplitudes);
trial.saccades.T_CCW.sum = sum(trial.saccades.T_CCW.amplitudes);
trial.saccades.T_CW.sum = sum(trial.saccades.T_CW.amplitudes);
trial.saccades.T.sum = trial.saccades.T_CCW.sum + trial.saccades.T_CW.sum;

%% caluclate mean amplitude
trial.saccades.X.meanAmplitude = mean(trial.saccades.X.amplitudes);
trial.saccades.Y.meanAmplitude = mean(trial.saccades.Y.amplitudes);
trial.saccades.T_CCW.meanAmplitude = mean(trial.saccades.T_CCW.amplitudes);
trial.saccades.T_CW.meanAmplitude = mean(trial.saccades.T_CW.amplitudes);
trial.saccades.T.meanAmplitude = mean([trial.saccades.T_CCW.amplitudes; trial.saccades.T_CW.amplitudes]);

%% calculate max amplitude
trial.saccades.X.maxAmplitude = max(trial.saccades.X.amplitudes);
trial.saccades.Y.maxAmplitude = max(trial.saccades.Y.amplitudes);
trial.saccades.T_CCW.maxAmplitude = max(trial.saccades.T_CCW.amplitudes);
trial.saccades.T_CW.maxAmplitude = max(trial.saccades.T_CW.amplitudes);
trial.saccades.T.maxAmplitude = max([trial.saccades.T_CCW.amplitudes; trial.saccades.T_CW.amplitudes]);

%% calculate mean duration
trial.saccades.X.meanDuration = mean(saccades.X.offsets - saccades.X.onsets);
trial.saccades.Y.meanDuration = mean(saccades.Y.offsets - saccades.Y.onsets);
trial.saccades.T_CCW.meanDuration = mean(saccades.T_CCW.offsets - saccades.T_CCW.onsets);
trial.saccades.T_CW.meanDuration = mean(saccades.T_CW.offsets - saccades.T_CW.onsets);
trial.saccades.T.meanDuration = mean(saccades.T.offsets - saccades.T.onsets);

%% calculate mean and peak velocity
trial.saccades.X.peakVelocity = [];
trial.saccades.Y.peakVelocity = [];
trial.saccades.T_CCW.peakVelocity = [];
trial.saccades.T_CW.peakVelocity = [];
trial.saccades.T.peakVelocity = [];

trial.saccades.X.meanVelocity = [];
trial.saccades.Y.meanVelocity = [];
trial.saccades.T_CCW.meanVelocity = [];
trial.saccades.T_CW.meanVelocity = [];
trial.saccades.T.meanVelocity = [];

for i = 1:length(saccades.X.onsets)
   trial.saccades.X.peakVelocity(i) = max(abs(trial.frames.DX_filt(saccades.X.onsets(i):saccades.X.offsets(i))));
   trial.saccades.X.meanVelocity(i) = nanmean(abs(trial.frames.X_filt(saccades.X.onsets(i):saccades.X.offsets(i)))); 
end

for i = 1:length(saccades.Y.onsets)
   trial.saccades.Y.peakVelocity(i) = max(abs(trial.frames.DY_filt(saccades.Y.onsets(i):saccades.Y.offsets(i))));
   trial.saccades.Y.meanVelocity(i) = nanmean(abs(trial.frames.DY_filt(saccades.Y.onsets(i):saccades.Y.offsets(i)))); 
end

for i = 1:length(saccades.T_CCW.onsets)
   trial.saccades.T_CCW.peakVelocity(i) = max(abs(trial.frames.DT_filt(saccades.T_CCW.onsets(i):saccades.T_CCW.offsets(i))));
   trial.saccades.T_CCW.meanVelocity(i) = nanmean(abs(trial.frames.DT_filt(saccades.T_CCW.onsets(i):saccades.T_CCW.offsets(i)))); 
end

for i = 1:length(saccades.T_CW.onsets)
   trial.saccades.T_CW.peakVelocity(i) = max(abs(trial.frames.DT_filt(saccades.T_CW.onsets(i):saccades.T_CW.offsets(i))));
   trial.saccades.T_CW.meanVelocity(i) = nanmean(abs(trial.frames.DT_filt(saccades.T_CW.onsets(i):saccades.T_CW.offsets(i)))); 
end

for i = 1:length(saccades.T.onsets)
   trial.saccades.T.peakVelocity(i) = max(abs(trial.frames.DT_filt(saccades.T.onsets(i):saccades.T.offsets(i))));
   trial.saccades.T.meanVelocity(i) = nanmean(abs(trial.frames.DT_filt(saccades.T.onsets(i):saccades.T.offsets(i)))); 
end

%% finally store saccades in trial information
trial.saccades.X.onsets = saccades.X.onsets;
trial.saccades.X.offsets = saccades.X.offsets;
trial.saccades.X.isMax = saccades.X.isMax;

trial.saccades.Y.onsets = saccades.Y.onsets;
trial.saccades.Y.offsets = saccades.Y.offsets;
trial.saccades.Y.isMax = saccades.Y.isMax;

trial.saccades.T.onsets = saccades.T.onsets;
trial.saccades.T.offsets = saccades.T.offsets;
trial.saccades.T.isMax = saccades.T.isMax;

trial.saccades.T_CCW.onsets = saccades.T_CCW.onsets;
trial.saccades.T_CCW.offsets = saccades.T_CCW.offsets;

trial.saccades.T_CW.onsets = saccades.T_CW.onsets;
trial.saccades.T_CW.offsets = saccades.T_CW.offsets;

end
