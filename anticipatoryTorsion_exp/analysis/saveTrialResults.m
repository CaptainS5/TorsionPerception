function [results] = saveTrialResults(results, trial, torsion, pursuit)

sampleRate = evalin('base','sampleRate');

%convert numbers from frames to milliseconds
if pursuit.onsetOnSaccade
    pursuit.onset = NaN;
else
    pursuit.onset = (pursuit.onset - trial.stim_onset) * (1000/sampleRate);
end

trial.saccades.firstSaccadeOnset = (trial.saccades.firstSaccadeOnset - trial.stim_onset) * (1000/sampleRate);


values = {...
    double(trial.log.experiment),...
    double(trial.log.block),...
    double(trial.number),...
    double(trial.log.subject),...
    double(trial.log.eye),...
    double(trial.log.translationalDirection),...
    double(trial.log.rotationalDirection),...
    double(trial.log.rotationalSpeed),...
    double(trial.log.diameter),... %new
    double(trial.log.natural),...
    double(trial.log.decision),...
    double(torsion.slowPhases.totalAngleCW),...
    double(torsion.slowPhases.totalAngleCCW),...
    double(torsion.slowPhases.meanSpeed),...
    double(torsion.slowPhases.meanSpeedAbsolute),...
    double(torsion.slowPhases.meanSpeedCorrect),...
    double(torsion.slowPhases.peakVelocity),...
    double(torsion.slowPhases.quality),...
    double(double(torsion.gain)),...
    double(trial.saccades.T.number),...
    double(trial.saccades.T.meanAmplitude),...
    double(trial.saccades.T.maxAmplitude),...
    double(trial.saccades.T.meanAmplitude * trial.saccades.T.number),...
    double(trial.saccades.T.meanDuration),...
    double(trial.saccades.X.number),...
    double(trial.saccades.X.meanAmplitude),...
    double(trial.saccades.firstSaccadeOnset),...
    double(pursuit.onset),...
    double(pursuit.initialMeanAcceleration),...
    double(pursuit.initialPeakVelocity),...
    double(pursuit.gain),...
    double(pursuit.positionError),...
    double(pursuit.velocityError)};



currentResults = [];

currentResults(1,~cellfun(@isempty,values)) = [values{~cellfun(@isempty,values)}];
currentResults(1,cellfun(@isempty,values)) = NaN;

results.trial = [results.trial; currentResults];


end





