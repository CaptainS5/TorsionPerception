% plot velocity traces
clear all; close all; clc

names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
conditions = [25 50 100 200 400];
sampleRate = 200; 

load('eyeDataAll.mat')

% for each rotational speed, draw the mean filtered and unfiltered
% velocity trace
% consistent reversal duration and duration after for all participants
reversalFrames = eyeTrialData.stim.reversalOffset(1, 1)-eyeTrialData.stim.reversalOnset(1, 1);
afterFrames = eyeTrialData.stim.afterFrames(1, 1);
for subN = 1:size(names, 2)
    validI = find(eyeTrialData.errorStatusR(subN, :)==0);
    maxBeforeFrames = max(eyeTrialData.stim.beforeFrames(subN, :));
    frameLength(subN) = maxBeforeFrames+reversalFrames+afterFrames;
    frames{subN} = NaN(length(validI), maxBeforeFrames+reversalFrames+afterFrames); % align the reversal; filled with NaN
    % rows are trials, columns are frames
    framesUnfilt{subN} = NaN(length(validI), maxBeforeFrames+reversalFrames+afterFrames); % align the reversal; filled with NaN
    % rows are trials, columns are frames
    
    % fill in the velocity trace of each frame
    % interpolate NaN points for a better velocity trace
    for validTrialN = 1:length(validI)
        startI = eyeTrialData.stim.onset(subN, validI(validTrialN));
        endI = eyeTrialData.stim.offset(subN, validI(validTrialN));
        startIF = maxBeforeFrames-eyeTrialData.stim.beforeFrames(subN, validI(validTrialN))+1;
        endIF = maxBeforeFrames+reversalFrames+eyeTrialData.stim.afterFrames(subN, validI(validTrialN));
        frames{subN}(validTrialN, startIF:endIF) = eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI)*eyeTrialData.afterReversalD(subN, validI(validTrialN)); % flip directions
        framesUnfilt{subN}(validTrialN, startIF:endIF) = eyeTrialData.frames{subN, validI(validTrialN)}.DTUnfilt_noSac(startI:endI)*eyeTrialData.afterReversalD(subN, validI(validTrialN)); % flip directions
    end
end
maxFrameLength = max(frameLength);

velTAverage = NaN(length(names), maxFrameLength);
velTStd = NaN(length(names), maxFrameLength);
velTUnfiltAverage = NaN(length(names), maxFrameLength);
velTUnfiltStd = NaN(length(names), maxFrameLength);

for subN = 1:size(names, 2)
    tempStartI = maxFrameLength-frameLength(subN)+1;
    velTAverage(subN, tempStartI:end) = nanmean(frames{subN});
    velTStd(subN, tempStartI:end) = nanstd(frames{subN});
    velTUnfiltAverage(subN, tempStartI:end) = nanmean(framesUnfilt{subN});
    velTUnfiltStd(subN, tempStartI:end) = nanstd(framesUnfilt{subN});
end

% plotting parameters
minFrameLength = min(frameLength);
beforeFrames = minFrameLength-reversalFrames-afterFrames;
framePerSec = 1/sampleRate;
timePReversal = [0:(reversalFrames-1)]*framePerSec*1000;
timePBeforeReversal = timePReversal(1)-(beforeFrames+1-[1:beforeFrames])*framePerSec*1000;
timePAfterReversal = timePReversal(end)+[1:afterFrames]*framePerSec*1000;
timePoints = [timePBeforeReversal timePReversal timePAfterReversal]; % align at the reversal and after...
% reversal onset is 0
velTmean = nanmean(velTAverage(:, (maxFrameLength-minFrameLength+1):end));
% need to plot ste? confidence interval...?

figure
% filtered mean velocity trace
subplot(2, 1, 1)
plot(timePoints, velTmean)
% hold on
% patch(timePoints, )
xlabel('Time (ms)')
ylabel('Torsional velocity (deg/s)')
% ylim([-0.5 0.5])

% unfiltered mean velocity trace
subplot(2, 1, 2)
plot(timePoints, nanmean(velTUnfiltAverage(:, (maxFrameLength-minFrameLength+1):end)))
xlabel('Time (ms)')
ylabel('Torsional velocity_unfiltered (deg/s)')
ylim([-2 2])

% saveas(gca, 'velocityTraces.pdf')