% plot velocity traces, generate csv file for plotting in R, Exp3 head
% tilted
clear all; close all; clc

names = {'tJF' 'AD'};
% t2CW only have available data for the first two secs...
conditions = [200];
sampleRate = 200;
eyeName = {'L' 'R'};
dirCons = [-1 1]; % -1 = ccw; 1 = cw
headCons = [-1 0 1]; % head tilt direction
headNames = {'CCW' 'Up' 'CW'};
folder = pwd;
colorPlot = [232 71 12; 12 76 150; 2 255 44; 140 0 255; 255 212 13]/255;

%% Experimental trials, directions not merged, generate csv files for R plotting
% consistent reversal duration and duration after for all participants
for eye = 2:2
    cd(folder)
    if eye==1
        load('eyeDataAll_L.mat');
    else
        load('eyeDataAll_R.mat');
    end
    
    reversalFrames = eyeTrialData.stim.reversalOffset(1, 1)-eyeTrialData.stim.reversalOnset(1, 1);
    afterFrames = eyeTrialData.stim.afterFrames(1, 1);
    % initialize frames
    for headI = 1:size(headCons, 2)
        frames{headI} = cell(size(names, 2), 2);
    end
    
    for subN = 1:size(names, 2)
        maxBeforeFrames = max(eyeTrialData.stim.beforeFrames(subN, :));
        frameLength(subN) = maxBeforeFrames+reversalFrames+afterFrames;
        headSub = unique(eyeTrialData.headTilt(subN, :));
        for headISub = 1:size(headSub, 2)
            headI = find(headCons==headSub(headISub));
            for dirI = 1:size(dirCons, 2)
                validI = find(eyeTrialData.errorStatus(subN, :)==0 & eyeTrialData.rotationSpeed(subN, :)~=0 ...
                    & eyeTrialData.headTilt(subN, :)==headSub(headISub) & eyeTrialData.afterReversalD(subN, :)==dirCons(dirI));
                frames{headI}{subN, dirI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
                % rows are trials, columns are frames
                
                % fill in the velocity trace of each frame
                % interpolate NaN points for a better velocity trace
                for validTrialN = 1:length(validI)
                    startI = eyeTrialData.stim.onset(subN, validI(validTrialN));
                    endI = eyeTrialData.stim.offset(subN, validI(validTrialN));
                    startIF = maxBeforeFrames-eyeTrialData.stim.beforeFrames(subN, validI(validTrialN))+1;
                    endIF = maxBeforeFrames+reversalFrames+eyeTrialData.stim.afterFrames(subN, validI(validTrialN));
                    frames{headI}{subN, dirI}(validTrialN, startIF:endIF) = eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI);
                end
            end
        end
    end
    maxFrameLength = max(frameLength);
    minFrameLength = min(frameLength);
    
    % for each head tilt condition and each direction, draw the mean filtered and unfiltered
    % velocity trace
    for headI = 1:size(headCons, 2)
        for dirI = 1:size(dirCons, 2)
            velTAverage{headI, dirI} = NaN(length(names), maxFrameLength);
            velTStd{headI, dirI} = NaN(length(names), maxFrameLength);
            
            for subN = 1:size(names, 2)
                if ~isempty(frames{headI}{subN, dirI})
                    tempStartI = maxFrameLength-frameLength(subN)+1;
                    velTAverage{headI, dirI}(subN, tempStartI:end) = nanmean(frames{headI}{subN, dirI});
                    velTStd{headI, dirI}(subN, tempStartI:end) = nanstd(frames{headI}{subN, dirI});
                end
            end
            velTmean{headI, dirI} = nanmean(velTAverage{headI, dirI}(:, (maxFrameLength-minFrameLength+1):end));
        end
    end
    % plotting parameters
    beforeFrames = minFrameLength-reversalFrames-afterFrames;
    framePerSec = 1/sampleRate;
    timePReversal = [0:(reversalFrames-1)]*framePerSec*1000;
    timePBeforeReversal = timePReversal(1)-(beforeFrames+1-[1:beforeFrames])*framePerSec*1000;
    timePAfterReversal = timePReversal(end)+[1:afterFrames]*framePerSec*1000;
    timePoints = [timePBeforeReversal timePReversal timePAfterReversal]; % align at the reversal and after...
    % reversal onset is 0
    
    figure % plot individual traces in different figures
    for subN = 1:size(names, 2)
        headSub = unique(eyeTrialData.headTilt(subN, :));
        headI(1) = find(headCons==headSub(1));
        headI(2) = find(headCons==headSub(2));
        for dirI = 1:size(dirCons, 2)
            % filtered mean velocity trace
            plot(timePoints, velTAverage{headI(1), dirI}(subN, (maxFrameLength-minFrameLength+1):end), '--', 'color', colorPlot(subN, :))
            hold on
            plot(timePoints, velTAverage{headI(2), dirI}(subN, (maxFrameLength-minFrameLength+1):end), '-', 'color', colorPlot(subN, :))
        end
        legend({['head' headNames{headI(1)} '-motionCCW'], ['head' headNames{headI(2)} '-motionCCW'], ...
            ['head' headNames{headI(1)} '-motionCW'], ['head' headNames{headI(2)} '-motionCW']}, ...
            'location', 'northwest')
        %         title([eyeName{eye}, ' rotational speed ', num2str(conditions(headI))])
        xlabel('Time (ms)')
        ylabel('Torsional velocity (deg/s)')
        % ylim([-0.5 0.5])
    end
    saveas(gca, ['velocityTracesSub_', names{subN}, '.pdf'])
    
    %     % generate csv files, each file for one speed condition
    %     % each row is the mean velocity trace of one participant
    %     % use the min frame length--the lengeth where all participants have
    %     % valid data points
    %     for headI = 1:size(conditions, 2)
    %         idxN = [];
    %         % find the min frame length in each condition
    %         for subN = 1:size(names, 2)
    %             tempI = find(~isnan(velTAverage{headI}(subN, :)));
    %             idxN(subN) = tempI(1);
    %         end
    %         startIdx(headI) = max(idxN);
    %     end
    %
    %     startI = max(startIdx);
    %     velTAverageSub = [];
    %     cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1stYear\TorsionPerception\analysis')
    %     for headI = 1:size(conditions, 2)
    %         for subN = 1:size(names, 2)
    %             velTAverageSub(subN, :) = velTAverage{headI}(subN, startI:end);
    %         end
    % %         csvwrite(['velocityTraceExp2_', eyeName{eye}, '_', num2str(conditions(speedI)), '.csv'], velTAverageSub)
    %     end
end
% % just use the mean latency from Exp1
% cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1stYear\TorsionPerception\analysis')
% load('torsionLatencyExp1.mat')
% meanLatency = mean(latency);
% meanLatencyB = mean(latencyB);
% cd(folder)
% save('meanLatencyExp1', 'meanLatency', 'meanLatencyB')

%% baseline, directions not merged
for eye = 2:2
    cd(folder)
    if eye==1
        load('eyeDataAllBase_L.mat');
    else
        load('eyeDataAllBase_R.mat');
    end
    
    reversalFrames = eyeTrialDataBase.stim.reversalOffset(1, 1)-eyeTrialDataBase.stim.reversalOnset(1, 1);
    afterFrames = eyeTrialDataBase.stim.afterFrames(1, 1);
    % initialize frames
    for headI = 1:size(headCons, 2)
        frames{headI} = cell(size(names, 2), 2);
    end
    
    for subN = 1:size(names, 2)
        maxBeforeFrames = max(eyeTrialDataBase.stim.beforeFrames(subN, :));
        frameLength(subN) = maxBeforeFrames+reversalFrames+afterFrames;
        headSub = unique(eyeTrialDataBase.headTilt(subN, :));
        for headISub = 1:size(headSub, 2)
            headI = find(headCons==headSub(headISub));
            for dirI = 1:size(dirCons, 2)
                validI = find(eyeTrialDataBase.errorStatus(subN, :)==0 & eyeTrialDataBase.rotationSpeed(subN, :)~=0 ...
                    & eyeTrialDataBase.headTilt(subN, :)==headSub(headISub) & eyeTrialDataBase.afterReversalD(subN, :)==dirCons(dirI));
                frames{headI}{subN, dirI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
                % rows are trials, columns are frames
                
                % fill in the velocity trace of each frame
                % interpolate NaN points for a better velocity trace
                for validTrialN = 1:length(validI)
                    startI = eyeTrialDataBase.stim.onset(subN, validI(validTrialN));
                    endI = eyeTrialDataBase.stim.offset(subN, validI(validTrialN));
                    startIF = maxBeforeFrames-eyeTrialDataBase.stim.beforeFrames(subN, validI(validTrialN))+1;
                    endIF = maxBeforeFrames+reversalFrames+eyeTrialDataBase.stim.afterFrames(subN, validI(validTrialN));
                    frames{headI}{subN, dirI}(validTrialN, startIF:endIF) = eyeTrialDataBase.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI);
                end
            end
        end
    end
    maxFrameLength = max(frameLength);
    minFrameLength = min(frameLength);
    
    % for each head tilt condition and each direction, draw the mean filtered and unfiltered
    % velocity trace
    for headI = 1:size(headCons, 2)
        for dirI = 1:size(dirCons, 2)
            velTAverage{headI, dirI} = NaN(length(names), maxFrameLength);
            velTStd{headI, dirI} = NaN(length(names), maxFrameLength);
            
            for subN = 1:size(names, 2)
                if ~isempty(frames{headI}{subN, dirI})
                    tempStartI = maxFrameLength-frameLength(subN)+1;
                    velTAverage{headI, dirI}(subN, tempStartI:end) = nanmean(frames{headI}{subN, dirI});
                    velTStd{headI, dirI}(subN, tempStartI:end) = nanstd(frames{headI}{subN, dirI});
                end
            end
            velTmean{headI, dirI} = nanmean(velTAverage{headI, dirI}(:, (maxFrameLength-minFrameLength+1):end));
        end
    end
    % plotting parameters
    beforeFrames = minFrameLength-reversalFrames-afterFrames;
    framePerSec = 1/sampleRate;
    timePReversal = [0:(reversalFrames-1)]*framePerSec*1000;
    timePBeforeReversal = timePReversal(1)-(beforeFrames+1-[1:beforeFrames])*framePerSec*1000;
    timePAfterReversal = timePReversal(end)+[1:afterFrames]*framePerSec*1000;
    timePoints = [timePBeforeReversal timePReversal timePAfterReversal]; % align at the reversal and after...
    % reversal onset is 0
    
    figure % plot individual traces in different figures
    for subN = 1:size(names, 2)
        headSub = unique(eyeTrialDataBase.headTilt(subN, :));
        headI(1) = find(headCons==headSub(1));
        headI(2) = find(headCons==headSub(2));
        for dirI = 1:size(dirCons, 2)
            % filtered mean velocity trace
            plot(timePoints, velTAverage{headI(1), dirI}(subN, (maxFrameLength-minFrameLength+1):end), '--', 'color', colorPlot(subN, :))
            hold on
            plot(timePoints, velTAverage{headI(2), dirI}(subN, (maxFrameLength-minFrameLength+1):end), '-', 'color', colorPlot(subN, :))
        end
        legend({['head' headNames{headI(1)} '-motionCCW'], ['head' headNames{headI(2)} '-motionCCW'], ...
            ['head' headNames{headI(1)} '-motionCW'], ['head' headNames{headI(2)} '-motionCW']}, ...
            'location', 'northwest')
        %         title([eyeName{eye}, ' rotational speed ', num2str(conditions(headI))])
        xlabel('Time (ms)')
        ylabel('Torsional velocity (deg/s)')
        ylim([-3 3])
    end
    saveas(gca, ['velocityTracesBaseSub_', names{subN}, '.pdf'])
end

%     % generate csv files, each file for one speed condition
%     % each row is the mean velocity trace of one participant
%     % use the min frame length--the lengeth where all participants have
%     % valid data points
%     for speedI = 1:size(conditions, 2)
%         idxN = [];
%         % find the min frame length in each condition
%         for subN = 1:size(names, 2)
%             tempI = find(~isnan(velTAverage{speedI}(subN, :)));
%             idxN(subN) = tempI(1);
%         end
%         startIdx(speedI) = max(idxN);
%     end
%
%     startI = max(startIdx);
%     velTAverageSub = [];
%     cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1stYear\TorsionPerception\analysis')
%     for speedI = 1:size(conditions, 2)
%         for subN = 1:size(names, 2)
%             velTAverageSub(subN, :) = velTAverage{speedI}(subN, startI:end);
%         end
%         csvwrite(['velocityTraceExp2_base_', eyeName{eye}, '_', num2str(conditions(speedI)), '.csv'], velTAverageSub)
%     end
% end