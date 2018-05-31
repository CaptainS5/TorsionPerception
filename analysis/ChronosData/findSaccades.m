function [onsets, offsets, isMax] = findSaccades(stim_onset, stim_offset, speed, acceleration, threshold, stimulusSpeed)
%% How this algorithm works:

% % debug
% stim_onset = trial.stim_onset;
% stim_offset = trial.stim_offset;
% speed = trial.frames.DX_filt;
% acceleration = trial.frames.DDX_filt;
% threshold = 20;
% stimulusSpeed = 0;

global trial
%% set up
startFrame = stim_onset;
endFrame = stim_offset;

upperThreshold = stimulusSpeed + threshold;
lowerThreshold = stimulusSpeed - threshold;

speed = speed(startFrame:endFrame);
acceleration = acceleration(startFrame:endFrame);

%% speed
middle = speed<lowerThreshold | speed>upperThreshold;
predecessor = [middle(2:end); 0];
successor = [0; middle(1:end-1)];
relevantFrames = middle+predecessor+successor == 3;

% % uncomment if you want to use 5 instead of 3 consecutive frames
% %****
% % only for sortData.m
% if ~isfield(trial, 'torsionFrames')
%     if trial.torsionFrames>3
%         prepredecessor = [predecessor(2:end); 0];
%         sucsuccessor = [0; successor(1:end-1)];
%         relevantFrames = middle+predecessor+successor+sucsuccessor+prepredecessor == trial.torsionFrames;
%     end
% elseif isfield(trial, 'torsionFrames')
%     prepredecessor = [predecessor(2:end); 0];
%     sucsuccessor = [0; successor(1:end-1)];
%     relevantFrames = middle+predecessor+successor+sucsuccessor+prepredecessor == 5;
% end
% %****

relevantFramesDiff = diff(relevantFrames);
relevantFramesOnsets = [relevantFramesDiff; 0];
relevantFramesOffsets = [0; relevantFramesDiff];

speedOnsets = relevantFramesOnsets == 1;
speedOffsets = relevantFramesOffsets == -1;

speedOnsets = find(speedOnsets);
speedOffsets = find(speedOffsets);

%% acceleration
middle = acceleration/1000;
predecessor = [middle(2:end); 0];
signSwitches = find((middle .* predecessor) < 0)+1;

onsets = NaN(1,length(speedOnsets));
offsets = NaN(1,length(speedOnsets));
isMax = NaN(1,length(speedOnsets));

%% find onsets and offsets
for i = 1:length(speedOnsets)
    
    % make sure, that there is always both, an onset and an offset
    % otherwise, skip this saccade
    if speedOnsets(i) < min(signSwitches) || speedOffsets(i) > max(signSwitches)
        continue
    end
    
    onsets(i) = max(signSwitches(signSwitches <= speedOnsets(i)));
    offsets(i) = min(signSwitches(signSwitches >= speedOffsets(i))-1); %the -1 is a subjective adjustment
    isMax(i) = speed(speedOnsets(i)) > 0;
    
end

%% trim to delete NaNs
onsets = onsets(~isnan(onsets))+startFrame;
offsets = offsets(~isnan(offsets))+startFrame;
isMax = isMax(~isnan(isMax));
isMax = logical(isMax);

%% make sure that saccades don't overlap. This is, find overlapping saccades and delete intermediate onset/offset
earlyOnsets = find(diff(reshape([onsets;offsets],1,[]))<0)/2+1;
previousOffsets = earlyOnsets - 1;
onsets(earlyOnsets) = [];
offsets(previousOffsets) = [];
isMax(earlyOnsets) = [];



% end