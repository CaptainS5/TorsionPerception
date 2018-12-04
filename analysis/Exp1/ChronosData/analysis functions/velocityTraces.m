% plot velocity traces, generate csv file for plotting in R, Exp1
clear all; close all; clc

names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
conditions = [25 50 100 200 400];
sampleRate = 200; 

load('eyeDataAll.mat')

%% directions merged, generate csv files for R plotting
% consistent reversal duration and duration after for all participants
reversalFrames = eyeTrialData.stim.reversalOffset(10, 1)-eyeTrialData.stim.reversalOnset(10, 1);
afterFrames = eyeTrialData.stim.afterFrames(10, 1);
for subN = 1:size(names, 2)
    maxBeforeFrames = max(eyeTrialData.stim.beforeFrames(subN, :));
    frameLength(subN) = maxBeforeFrames+reversalFrames+afterFrames;
    for speedI = 1:size(conditions, 2)
        validI = find(eyeTrialData.errorStatusR(subN, :)==0 & eyeTrialData.rotationSpeed(subN, :)==conditions(speedI)); 
        frames{subN, speedI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
        % rows are trials, columns are frames
        framesUnfilt{subN, speedI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
        % rows are trials, columns are frames
        
        % fill in the velocity trace of each frame
        % interpolate NaN points for a better velocity trace
        for validTrialN = 1:length(validI)
            startI = eyeTrialData.stim.onset(subN, validI(validTrialN));
            endI = eyeTrialData.stim.offset(subN, validI(validTrialN));
            startIF = maxBeforeFrames-eyeTrialData.stim.beforeFrames(subN, validI(validTrialN))+1;
            endIF = maxBeforeFrames+reversalFrames+eyeTrialData.stim.afterFrames(subN, validI(validTrialN));
            frames{subN, speedI}(validTrialN, startIF:endIF) = eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI)*eyeTrialData.afterReversalD(subN, validI(validTrialN)); % flip directions
            framesUnfilt{subN, speedI}(validTrialN, startIF:endIF) = eyeTrialData.frames{subN, validI(validTrialN)}.DTUnfilt_noSac(startI:endI)*eyeTrialData.afterReversalD(subN, validI(validTrialN)); % flip directions
        end
    end
end
maxFrameLength = max(frameLength);

% for each rotational speed, draw the mean filtered and unfiltered
% velocity trace
for speedI = 1:size(conditions, 2)
    velTAverage{speedI} = NaN(length(names), maxFrameLength);
    velTStd{speedI} = NaN(length(names), maxFrameLength);
    velTUnfiltAverage{speedI} = NaN(length(names), maxFrameLength);
    velTUnfiltStd{speedI} = NaN(length(names), maxFrameLength);
    
    for subN = 1:size(names, 2)
        tempStartI = maxFrameLength-frameLength(subN)+1;
        velTAverage{speedI}(subN, tempStartI:end) = nanmean(frames{subN, speedI});
        velTStd{speedI}(subN, tempStartI:end) = nanstd(frames{subN, speedI});
        velTUnfiltAverage{speedI}(subN, tempStartI:end) = nanmean(framesUnfilt{subN, speedI});
        velTUnfiltStd{speedI}(subN, tempStartI:end) = nanstd(framesUnfilt{subN, speedI});
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
    velTmean{speedI} = nanmean(velTAverage{speedI}(:, (maxFrameLength-minFrameLength+1):end));
    % need to plot ste? confidence interval...?
    
    figure
    % filtered mean velocity trace
    subplot(2, 1, 1)
    plot(timePoints, velTmean{speedI})
    % hold on
    % patch(timePoints, )
    title(['rotational speed ', num2str(conditions(speedI))])
    xlabel('Time (ms)')
    ylabel('Torsional velocity (deg/s)')
    % ylim([-0.5 0.5])
    
    % unfiltered mean velocity trace
    subplot(2, 1, 2)
    plot(timePoints, nanmean(velTUnfiltAverage{speedI}(:, (maxFrameLength-minFrameLength+1):end)))
    title(['rotational speed ', num2str(conditions(speedI))])
    xlabel('Time (ms)')
    ylabel('Torsional velocity_unfiltered (deg/s)')
    ylim([-2 2])
    
    % saveas(gca, ['velocityTraces_', num2str(conditions(speedI)), '.pdf'])
end

% generate csv files, each file for one speed condition
% each row is the mean velocity trace of one participant
% use the min frame length--the lengeth where all participants have
% valid data points
for speedI = 1:size(conditions, 2)
    idxN = [];
    % find the min frame length in each condition
    for subN = 1:size(names, 2)
        tempI = find(~isnan(velTAverage{speedI}(subN, :)));
        idxN(subN) = tempI(1);
    end
    startIdx(speedI) = max(idxN);
end

startI = max(startIdx);
velTAverageSub = [];
cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\TorsionPerception\analysis')
for speedI = 1:size(conditions, 2)
    for subN = 1:size(names, 2)
        velTAverageSub(subN, :) = velTAverage{speedI}(subN, startI:end);
    end
    csvwrite(['velocityTraceExp1_', num2str(conditions(speedI)), '.csv'], velTAverageSub)
end

%% velocity traces for CW and CCW directions, and calculate latency
% for each participant in each rotational speed, draw the mean
% not enough trials even for this calculation... just give up = =