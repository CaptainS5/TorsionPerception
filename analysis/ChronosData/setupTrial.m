function [trial] = setupTrial(data, header, logData, currentTrial)

trial.number = currentTrial;
trial.valid = 1; % whether this is a valid trial

%% get start and end frame
trial.startFrame = data.startFrames(trial.number)+1;
trial.endFrame = data.endFrames(trial.number)+1;

%% get data for this trial
trial.frames.X_filt = data.X_filt(trial.startFrame:trial.endFrame);
trial.frames.Y_filt = data.Y_filt(trial.startFrame:trial.endFrame);
trial.frames.T_filt = data.T_filt(trial.startFrame:trial.endFrame);

trial.frames.DX_filt = data.DX_filt(trial.startFrame:trial.endFrame);
trial.frames.DY_filt = data.DY_filt(trial.startFrame:trial.endFrame);
trial.frames.DT_filt = data.DT_filt(trial.startFrame:trial.endFrame);

trial.frames.DDX_filt = data.DDX_filt(trial.startFrame:trial.endFrame);
trial.frames.DDY_filt = data.DDY_filt(trial.startFrame:trial.endFrame);
trial.frames.DDT_filt = data.DDT_filt(trial.startFrame:trial.endFrame);

trial.frames.DDDX = data.DDDX(trial.startFrame:trial.endFrame);
trial.frames.DDDY = data.DDDY(trial.startFrame:trial.endFrame);
trial.frames.DDDT = data.DDDT(trial.startFrame:trial.endFrame);

%% read lost frames
trial.lostXframes = data.lostXframes(trial.startFrame:trial.endFrame);
trial.lostYframes = data.lostYframes(trial.startFrame:trial.endFrame);
trial.lostTframes = data.lostTframes(trial.startFrame:trial.endFrame);

%% calculate stim_onset and stim_offset
% 
trial.stim_start = ms2frames(logData.fixationDuration(currentTrial)*1000);
trial.stim_onset = ms2frames(logData.fixationDuration(currentTrial)*1000);
trial.stim_reversal = ms2frames((logData.fixationDuration(currentTrial)+logData.durationBefore(currentTrial))*1000);
% trial.stim_onset = ms2frames((logData.fixationDuration(currentTrial)+logData.durationBefore(currentTrial)+0.12)*1000);                          
trial.stim_offset = trial.stim_onset + ms2frames((logData.durationBefore(currentTrial)+logData.durationAfter(currentTrial))*1000);

trial.length = length(trial.startFrame:trial.endFrame);

%% read log data
trial.log.experiment = header.experiment;
trial.log.subject = header.subjectID;
trial.log.block = logData.block;
trial.log.eye = data.eye;
% trial.log.number = logData.trial(currentTrial);
trial.log.rotationalDirection = logData.initialDirection(currentTrial);
trial.log.rotationalSpeed = logData.rotationSpeed(currentTrial);
% trial.log.translationalDirection = logData.translationalDirection(currentTrial);
% trial.log.rotationalDirection = logData.rotationalDirection(currentTrial);
% trial.log.rotationalSpeed = ((double(logData.randomSpeed(currentTrial))+100)/100)*logData.rotationalSpeed(currentTrial);
% trial.log.natural = logData.natural(currentTrial);
% trial.log.diameter = logData.circleDiameter(currentTrial);
% trial.log.decision = logData.decision(currentTrial);

%% get stimulus position
% startPosition = 8;
% endPosition = -8;
% stimulusRange = endPosition - startPosition;
% timeRange = length(trial.stim_onset:trial.stim_offset);
% stepSize = stimulusRange/(timeRange-1);
% 
% trial.frames.S(1:trial.stim_onset) = startPosition;
% trial.frames.S(trial.stim_onset:trial.stim_offset) = (startPosition:stepSize:endPosition)';
% trial.frames.S(trial.stim_offset:trial.length) = endPosition;
% trial.frames.S = trial.frames.S';
% 
% if  trial.log.translationalDirection %direction == 1 means toLeft
%     trial.frames.S = -trial.frames.S;
% end

%% calculate stimulus velocity
% sampleRate = evalin('base','sampleRate');
% trial.frames.DS = diff(trial.frames.S)*sampleRate;
% trial.frames.DS = [trial.frames.DS; NaN];
% 
% trial.stimulusMeanVelocity = nanmean(trial.frames.DS(trial.stim_onset:trial.stim_offset));
%% set start and end frame to 1:length
trial.startFrame = 1;
trial.endFrame = trial.length;