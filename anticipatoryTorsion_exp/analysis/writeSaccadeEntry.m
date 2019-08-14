function [entry] = writeSaccadeEntry(type, onset, offset, trial)


entry = {...
    
%setup standard quickphase numbers
double(trial.log.experiment),...
double(trial.number),...
double(trial.log.subject),...
double(trial.log.block),...
double(trial.log.eye),...
double(trial.log.translationalDirection),...
double(trial.log.rotationalDirection),...
double(trial.log.rotationalSpeed),...
double(trial.log.diameter),...
double(type),...
double(onset*5),...
double(offset*5),...
double(trial.frames.X_filt(onset)),...
double(trial.frames.X_filt(offset)),...
double(trial.frames.Y_filt(onset)),...
double(trial.frames.Y_filt(offset)),...
double(trial.frames.T_filt(onset)),...
double(trial.frames.T_filt(offset))};

end