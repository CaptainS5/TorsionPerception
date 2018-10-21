function [ torsion, trial ] = analyzeTorsion(trial, pursuit)

startFrame = pursuit.onset;
endFrame = trial.stim_offset; % - ms2frames(60);

%% mark slowPhases (1 if slowphase, 0 otherwise)
% trial.quickphaseFrames = false(trial.length,1); % defined in removeSaccade.m
slowPhases = ~trial.quickphaseFrames; %
slowPhases(1:startFrame) = 0;
slowPhases(endFrame+1:end) = 0;

%% find slowphase onsets/offsets and direction
temp = diff(slowPhases);
torsion.slowPhases.onsets = find(temp == 1);
torsion.slowPhases.offsets = find(temp == -1);
torsion.slowPhases.direction = trial.frames.T_filt(torsion.slowPhases.onsets) > trial.frames.T_filt(torsion.slowPhases.offsets);

%% get quickPhase speed
trial.frames.DT_quickphases = trial.frames.DT_filt;
trial.frames.DT_quickphases(~trial.quickphaseFrames) = NaN;

%% get slow phase speed and mean speed
trial.frames.DT_slowphases = trial.frames.DT_filt;
trial.frames.DT_slowphases(~slowPhases) = NaN;

%% find slowphase frames rotating in correct direction
torsion.slowPhases.correctFrames = double(trial.frames.DT_slowphases > 0 == ~trial.log.rotationalDirection);
torsion.slowPhases.correctFrames(~slowPhases) = NaN;
torsion.slowPhases.quality = nanmean(torsion.slowPhases.correctFrames);

%% calculate mean speeds and max speed
trial.quickphases.meanSpeed = nanmean(trial.frames.DT_quickphases);
torsion.slowPhases.meanSpeed = nanmean(trial.frames.DT_slowphases);
torsion.slowPhases.meanSpeedAbsolute = nanmean(abs(trial.frames.DT_slowphases));
torsion.slowPhases.meanSpeedCorrect = nanmean(abs(trial.frames.DT_slowphases(torsion.slowPhases.correctFrames == 1)));
torsion.slowPhases.peakVelocity = nanmax(abs(trial.frames.DT_slowphases(torsion.slowPhases.correctFrames == 1)));

%% calculate torsion gain
torsion.gain = abs(nanmean(trial.frames.DT_slowphases)/double(trial.log.rotationalSpeed));

%% calculate slow phase parameters (angles, duration, speed)
% for retinal image angle
torsion.slowPhases.onsetPosition = trial.frames.T_filt(torsion.slowPhases.onsets);

torsion.slowPhases.angle = trial.frames.T_filt(torsion.slowPhases.offsets) - trial.frames.T_filt(torsion.slowPhases.onsets);
torsion.slowPhases.angleCW = torsion.slowPhases.angle(torsion.slowPhases.angle > 0);
torsion.slowPhases.angleCCW = torsion.slowPhases.angle(torsion.slowPhases.angle <= 0);
torsion.slowPhases.duration = torsion.slowPhases.offsets - torsion.slowPhases.onsets;

torsion.slowPhases.speed = NaN(1,length(torsion.slowPhases.onsets));
for i = 1:length(torsion.slowPhases.onsets)
    torsion.slowPhases.speed(i) = nanmean(abs(trial.frames.DT_filt(torsion.slowPhases.onsets(i):torsion.slowPhases.offsets(i))));
end

torsion.slowPhases.totalAngle = sum(abs(torsion.slowPhases.angle));
torsion.slowPhases.totalAngleCW = sum(abs(torsion.slowPhases.angleCW));
torsion.slowPhases.totalAngleCCW = sum(abs(torsion.slowPhases.angleCCW));

%% calculate torsional position at onset and offset of each torsional saccade (quickphase)
trial.saccades.T.onsetPositions = trial.frames.T_filt(trial.saccades.T.onsets)';
trial.saccades.T.offsetPositions = trial.frames.T_filt(trial.saccades.T.offsets)';

trial.saccades.T_CCW.onsetPositions = trial.frames.T_filt(trial.saccades.T_CCW.onsets)';
trial.saccades.T_CCW.offsetPositions = trial.frames.T_filt(trial.saccades.T_CCW.offsets)';

trial.saccades.T_CW.onsetPositions = trial.frames.T_filt(trial.saccades.T_CW.onsets)';
trial.saccades.T_CW.offsetPositions = trial.frames.T_filt(trial.saccades.T_CW.offsets)';


% end

