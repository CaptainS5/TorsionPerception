% plot velocity traces, generate csv file for plotting in R, Exp2
clear all; close all; clc

names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol' 'FScontrol' 'XWcontrol' 'SCcontrol' 'JFcontrol'};
conditions = [25 50 100 200];
sampleRate = 200;
eyeName = {'L' 'R'};
folder = pwd;

%% directions not merged, generate csv files for R plotting
% consistent reversal duration and duration after for all participants
for eye = 1:2
    cd(folder)
    if eye==1
        load('eyeDataAll_L.mat');
    else
        load('eyeDataAll_R.mat');
    end
    reversalFrames = eyeTrialData.stim.reversalOffset(1, 1)-eyeTrialData.stim.reversalOnset(1, 1);
    afterFrames = eyeTrialData.stim.afterFrames(1, 1);
    for subN = 1:size(names, 2)
        maxBeforeFrames = max(eyeTrialData.stim.beforeFrames(subN, :));
        frameLength(subN) = maxBeforeFrames+reversalFrames+afterFrames;
        for speedI = 1:size(conditions, 2)
            validI = find(eyeTrialData.errorStatus(subN, :)==0 & eyeTrialData.rotationSpeed(subN, :)==conditions(speedI));
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
                frames{subN, speedI}(validTrialN, startIF:endIF) = eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI); % no flip directions
            end
        end
    end
    maxFrameLength = max(frameLength);
    
    % for each rotational speed, draw the mean filtered and unfiltered
    % velocity trace
    for speedI = 1:size(conditions, 2)
        velTAverage{speedI} = NaN(length(names), maxFrameLength);
        velTStd{speedI} = NaN(length(names), maxFrameLength);
%         velTUnfiltAverage{speedI} = NaN(length(names), maxFrameLength);
%         velTUnfiltStd{speedI} = NaN(length(names), maxFrameLength);
        
        for subN = 1:size(names, 2)
            tempStartI = maxFrameLength-frameLength(subN)+1;
            velTAverage{speedI}(subN, tempStartI:end) = nanmean(frames{subN, speedI});
            velTStd{speedI}(subN, tempStartI:end) = nanstd(frames{subN, speedI});
%             velTUnfiltAverage{speedI}(subN, tempStartI:end) = nanmean(framesUnfilt{subN, speedI});
%             velTUnfiltStd{speedI}(subN, tempStartI:end) = nanstd(framesUnfilt{subN, speedI});
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
        
%         figure
%         % filtered mean velocity trace
%         plot(timePoints, velTmean{speedI})
%         % hold on
%         % patch(timePoints, )
%         title([eyeName{eye}, ' rotational speed ', num2str(conditions(speedI))])
%         xlabel('Time (ms)')
%         ylabel('Torsional velocity (deg/s)')
%         % ylim([-0.5 0.5])
%         
%         % saveas(gca, ['velocityTraces_', num2str(conditions(speedI)), '.pdf'])
        
        figure % plot individual traces
        for subN = 1:size(names, 2)
            % filtered mean velocity trace
            plot(timePoints, velTAverage{speedI}(subN, (maxFrameLength-minFrameLength+1):end))
            hold on
            % patch(timePoints, )
        end
        title([eyeName{eye}, ' rotational speed ', num2str(conditions(speedI))])
        xlabel('Time (ms)')
        ylabel('Torsional velocity (deg/s)')
        % ylim([-0.5 0.5])
        
        % saveas(gca, ['velocityTracesSub_', num2str(conditions(speedI)), '.pdf'])
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
%     cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\TorsionPerception\analysis')
%     for speedI = 1:size(conditions, 2)
%         for subN = 1:size(names, 2)
%             velTAverageSub(subN, :) = velTAverage{speedI}(subN, startI:end);
%         end
%         csvwrite(['velocityTraceExp2_', eyeName{eye}, '_', num2str(conditions(speedI)), '.csv'], velTAverageSub)
%     end
end
% % just use the mean latency from Exp1
% cd('C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\TorsionPerception\analysis\Exp1\ChronosData\analysis functions')
% load('torsionLatencyExp1.mat')
% meanLatency = mean(latency);
% cd(folder)
% save('meanLatencyExp1', 'meanLatency')

%% baseline
for eye = 1:2
    cd(folder)
    if eye==1
        load('eyeDataAllBase_L.mat');
    else
        load('eyeDataAllBase_R.mat');
    end
    reversalFrames = eyeTrialDataBase.stim.reversalOffset(1, 1)-eyeTrialDataBase.stim.reversalOnset(1, 1);
    afterFrames = eyeTrialDataBase.stim.afterFrames(1, 1);
    for subN = 1:size(names, 2)
        maxBeforeFrames = max(eyeTrialDataBase.stim.beforeFrames(subN, :));
        frameLength(subN) = maxBeforeFrames+reversalFrames+afterFrames;
        for speedI = 1:size(conditions, 2)
            validI = find(eyeTrialDataBase.errorStatus(subN, :)==0 & eyeTrialDataBase.rotationSpeed(subN, :)==conditions(speedI));
            frames{subN, speedI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
            % rows are trials, columns are frames
            framesUnfilt{subN, speedI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
            % rows are trials, columns are frames
            
            % fill in the velocity trace of each frame
            % interpolate NaN points for a better velocity trace
            for validTrialN = 1:length(validI)
                startI = eyeTrialDataBase.stim.onset(subN, validI(validTrialN));
                endI = eyeTrialDataBase.stim.offset(subN, validI(validTrialN));
                startIF = maxBeforeFrames-eyeTrialDataBase.stim.beforeFrames(subN, validI(validTrialN))+1;
                endIF = maxBeforeFrames+reversalFrames+eyeTrialDataBase.stim.afterFrames(subN, validI(validTrialN));
                frames{subN, speedI}(validTrialN, startIF:endIF) = eyeTrialDataBase.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI); % no flip directions
            end
        end
    end
    maxFrameLength = max(frameLength);
    
    % for each rotational speed, draw the mean filtered and unfiltered
    % velocity trace
    for speedI = 1:size(conditions, 2)
        velTAverage{speedI} = NaN(length(names), maxFrameLength);
        velTStd{speedI} = NaN(length(names), maxFrameLength);
%         velTUnfiltAverage{speedI} = NaN(length(names), maxFrameLength);
%         velTUnfiltStd{speedI} = NaN(length(names), maxFrameLength);
        
        for subN = 1:size(names, 2)
            tempStartI = maxFrameLength-frameLength(subN)+1;
            velTAverage{speedI}(subN, tempStartI:end) = nanmean(frames{subN, speedI});
            velTStd{speedI}(subN, tempStartI:end) = nanstd(frames{subN, speedI});
%             velTUnfiltAverage{speedI}(subN, tempStartI:end) = nanmean(framesUnfilt{subN, speedI});
%             velTUnfiltStd{speedI}(subN, tempStartI:end) = nanstd(framesUnfilt{subN, speedI});
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
        plot(timePoints, velTmean{speedI})
        % hold on
        % patch(timePoints, )
        title([eyeName{eye}, ' base rotational speed ', num2str(conditions(speedI))])
        xlabel('Time (ms)')
        ylabel('Torsional velocity (deg/s)')
        % ylim([-0.5 0.5])
        
        % saveas(gca, ['velocityTraces_', num2str(conditions(speedI)), '.pdf'])
        
        figure % plot individual traces
        for subN = 1:size(names, 2)
            % filtered mean velocity trace
            plot(timePoints, velTAverage{speedI}(subN, (maxFrameLength-minFrameLength+1):end))
            hold on
            % patch(timePoints, )
        end
        title([eyeName{eye}, ' base rotational speed ', num2str(conditions(speedI))])
        xlabel('Time (ms)')
        ylabel('Torsional velocity (deg/s)')
        % ylim([-0.5 0.5])
        
        % saveas(gca, ['velocityTracesSub_', num2str(conditions(speedI)), '.pdf'])
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
        csvwrite(['velocityTraceExp2_base_', eyeName{eye}, '_', num2str(conditions(speedI)), '.csv'], velTAverageSub)
    end
end

%% velocity traces for BothEye trials... to show in the manuscript
left = load('eyeDataAll_L.mat');
right = load('eyeDataAll_R.mat');
reversalFrames = left.eyeTrialData.stim.reversalOffset(1, 1)-left.eyeTrialData.stim.reversalOnset(1, 1);
afterFrames = left.eyeTrialData.stim.afterFrames(1, 1);
for subN = 1:size(names, 2)
    maxBeforeFrames = max([left.eyeTrialData.stim.beforeFrames(subN, :) right.eyeTrialData.stim.beforeFrames(subN, :)]);
    frameLength(subN) = maxBeforeFrames+reversalFrames+afterFrames;
    for speedI = 1:size(conditions, 2)
        validI = find((left.eyeTrialData.errorStatus(subN, :)==0 & left.eyeTrialData.rotationSpeed(subN, :)==conditions(speedI) & left.eyeTrialData.targetSide(subN, :)==-1) ...
            | (right.eyeTrialData.errorStatus(subN, :)==0 & right.eyeTrialData.rotationSpeed(subN, :)==conditions(speedI) & right.eyeTrialData.targetSide(subN, :)==1));
        frames{subN, speedI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
        % rows are trials, columns are frames
%         framesUnfilt{subN, speedI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
%         % rows are trials, columns are frames
        
        % fill in the velocity trace of each frame
        % interpolate NaN points for a better velocity trace
        for validTrialN = 1:length(validI)
            if left.eyeTrialData.targetSide(subN, validI(validTrialN))==-1
                startI = left.eyeTrialData.stim.onset(subN, validI(validTrialN));
                endI = left.eyeTrialData.stim.offset(subN, validI(validTrialN));
                startIF = maxBeforeFrames-left.eyeTrialData.stim.beforeFrames(subN, validI(validTrialN))+1;
                endIF = maxBeforeFrames+reversalFrames+left.eyeTrialData.stim.afterFrames(subN, validI(validTrialN));
                frames{subN, speedI}(validTrialN, startIF:endIF) = left.eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI) ...
                    *left.eyeTrialData.afterReversalD(subN, validI(validTrialN)); % flip directions
            elseif right.eyeTrialData.targetSide(subN, validI(validTrialN))==1
                startI = right.eyeTrialData.stim.onset(subN, validI(validTrialN));
                endI = right.eyeTrialData.stim.offset(subN, validI(validTrialN));
                startIF = maxBeforeFrames-right.eyeTrialData.stim.beforeFrames(subN, validI(validTrialN))+1;
                endIF = maxBeforeFrames+reversalFrames+right.eyeTrialData.stim.afterFrames(subN, validI(validTrialN));
                frames{subN, speedI}(validTrialN, startIF:endIF) = right.eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI) ...
                    *right.eyeTrialData.afterReversalD(subN, validI(validTrialN)); % flip directions
            end
        end
    end
end
maxFrameLength = max(frameLength);

% for each rotational speed, draw the mean filtered and unfiltered
% velocity trace
for speedI = 1:size(conditions, 2)
    velTAverage{speedI} = NaN(length(names), maxFrameLength);
    velTStd{speedI} = NaN(length(names), maxFrameLength);
    %         velTUnfiltAverage{speedI} = NaN(length(names), maxFrameLength);
    %         velTUnfiltStd{speedI} = NaN(length(names), maxFrameLength);
    
    for subN = 1:size(names, 2)
        tempStartI = maxFrameLength-frameLength(subN)+1;
        velTAverage{speedI}(subN, tempStartI:end) = nanmean(frames{subN, speedI});
        velTStd{speedI}(subN, tempStartI:end) = nanstd(frames{subN, speedI});
        %             velTUnfiltAverage{speedI}(subN, tempStartI:end) = nanmean(framesUnfilt{subN, speedI});
        %             velTUnfiltStd{speedI}(subN, tempStartI:end) = nanstd(framesUnfilt{subN, speedI});
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
    plot(timePoints, velTmean{speedI})
    % hold on
    % patch(timePoints, )
    title(['bothEye rotational speed ', num2str(conditions(speedI))])
    xlabel('Time (ms)')
    ylabel('Torsional velocity (deg/s)')
    % ylim([-0.5 0.5])
    
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
    csvwrite(['velocityTraceExp2_bothEye_', num2str(conditions(speedI)), '.csv'], velTAverageSub)
end
