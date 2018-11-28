% plot velocity traces
clear all; close all; clc

names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
conditions = [25 50 100 200 400];

load('temp.mat')

% for each rotational speed, draw the mean filtered and unfiltered
% velocity trace
for subN = 1:size(names, 2)
    validI = find(eyeTrialData.errorStatusR(subN, :)==0);
    maxBeforeFrames = max(eyeTrialData.stim.beforeFrames);
    maxAfterFrames = max(eyeTrialData.stim.afterFrames);
    reversalFrames = eyeTrialData.stim.reversalOffset(1, 1)-eyeTrialData.stim.reversalOnset(1, 1);
    frameLength(subN) = maxBeforeFrames+reversalFrames+maxAfterFrames;
    frames = NaN(length(validI), maxBeforeFrames+reversalFrames+maxAfterFrames); % align the reversal; filled with NaN
    % rows are trials, columns are frames
    framesUnfilt = NaN(length(validI), maxBeforeFrames+reversalFrames+maxAfterFrames); % align the reversal; filled with NaN
    % rows are trials, columns are frames
    
    % fill in the velocity trace of each frame
    for validTrialN = 1:length(validI)
        startI = eyeTrialData.stim.onset(subN, validI(validTrialN));
        endI = eyeTrialData.stim.offset(subN, validI(validTrialN));
        startIF = maxBeforeFrames-eyeTrialData.stim.beforeFrames(subN, validI(validTrialN))+1;
        endIF = maxBeforeFrames+reversalFrames+eyeTrialData.stim.afterFrames(subN, validI(validTrialN));
        frames{subN}(validTrialN, startIF:endIF) = eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI);
        framesUnfitl{subN}(validTrialN, startIF:endIF) = eyeTrialData.frames{subN, validI(validTrialN)}.DTUnfilt_noSac(startI:endI);
    end
end
maxFrameLength = max(frameLength);

velTAverage = NaN(length(names), maxFrameLength);
velTStd = NaN(length(names), maxFrameLength);
velTUnfiltAverage = NaN(length(names), maxFrameLength);
velTUnfiltStd = NaN(length(names), maxFrameLength);

velTAverage = nanmean;
velTStd = ;
velTUnfiltAverage = ;
velTUnfiltStd = ;

figure
subplot(2, 1, 1)
