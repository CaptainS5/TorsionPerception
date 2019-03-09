% plot velocity traces, generate csv file for plotting in R, Exp3 head
% tilted
clear all; close all; clc

names = {'tJF'};
% t2CW only have available data for the first two secs...
conditions = [200];
sampleRate = 200;
eyeName = {'L' 'R'};
dirCons = [-1 1]; % -1 = ccw; 1 = cw
headCons = [-1 0]; % head tilt direction
folder = pwd;
colorPlot = [0.4 0.4 0.4; 0 0 0; 0.7 0.7 0.7];

%% directions not merged, generate csv files for R plotting
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
    for subN = 1:size(names, 2)
        maxBeforeFrames = max(eyeTrialData.stim.beforeFrames(subN, :));
        frameLength(subN) = maxBeforeFrames+reversalFrames+afterFrames;
        for headI = 1:size(headCons, 2)
            for dirI = 1:size(dirCons, 2)
                validI = find(eyeTrialData.errorStatus(subN, :)==0 & eyeTrialData.rotationSpeed(subN, :)~=0 ...
                    & eyeTrialData.headTilt(subN, :)==headCons(headI) & eyeTrialData.afterReversalD(subN, :)==dirCons(dirI));
                frames{subN}{headI, dirI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
                % rows are trials, columns are frames
                
                % fill in the velocity trace of each frame
                % interpolate NaN points for a better velocity trace
                for validTrialN = 1:length(validI)
                    startI = eyeTrialData.stim.onset(subN, validI(validTrialN));
                    endI = eyeTrialData.stim.offset(subN, validI(validTrialN));
                    startIF = maxBeforeFrames-eyeTrialData.stim.beforeFrames(subN, validI(validTrialN))+1;
                    endIF = maxBeforeFrames+reversalFrames+eyeTrialData.stim.afterFrames(subN, validI(validTrialN));
                    frames{subN}{headI, dirI}(validTrialN, startIF:endIF) = eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI);
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
                tempStartI = maxFrameLength-frameLength(subN)+1;
                velTAverage{headI, dirI}(subN, tempStartI:end) = nanmean(frames{subN}{headI, dirI});
                velTStd{headI, dirI}(subN, tempStartI:end) = nanstd(frames{subN}{headI, dirI});
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
    
    figure % plot individual traces in different figures
    for subN = 1:size(names, 2)
        for dirI = 1:size(dirCons, 2)
            % filtered mean velocity trace
            plot(timePoints, velTAverage{1, dirI}(subN, (maxFrameLength-minFrameLength+1):end), '--', 'color', colorPlot(dirI, :)) 
            hold on
            plot(timePoints, velTAverage{2, dirI}(subN, (maxFrameLength-minFrameLength+1):end), '-', 'color', colorPlot(dirI, :)) 
        end
        legend({'headCCW-motionCCW', 'headUp-motionCCW', 'headCCW-motionCW', 'headUp-motionCW'}, ...
            'location', 'northwest')
%         title([eyeName{eye}, ' rotational speed ', num2str(conditions(headI))])
        xlabel('Time (ms)')
        ylabel('Torsional velocity (deg/s)')
        % ylim([-0.5 0.5])
        
        saveas(gca, ['velocityTracesSub_', names{subN}, '.pdf'])
    end
    
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
% for eye = 2:2
%     cd(folder)
%     if eye==1
%         load('eyeDataAllBase_L.mat');
%     else
%         load('eyeDataAllBase_R.mat');
%     end
%     reversalFrames = eyeTrialDataBase.stim.reversalOffset(1, 1)-eyeTrialDataBase.stim.reversalOnset(1, 1);
%     afterFrames = eyeTrialDataBase.stim.afterFrames(1, 1);
%     for subN = 1:size(names, 2)
%         maxBeforeFrames = max(eyeTrialDataBase.stim.beforeFrames(subN, :));
%         frameLength(subN) = maxBeforeFrames+reversalFrames+afterFrames;
%         for speedI = 1:size(conditions, 2)
%             for dirI = 1:size(dirCons, 2)
%                 validI = find(eyeTrialDataBase.errorStatus(subN, :)==0 & eyeTrialDataBase.rotationSpeed(subN, :)==conditions(speedI) & eyeTrialDataBase.afterReversalD(subN, :)==dirCons(dirI));
%                 frames{subN}{speedI, dirI} = NaN(length(validI), frameLength(subN)); % align the reversal; filled with NaN
%                 % rows are trials, columns are frames
%
%                 % fill in the velocity trace of each frame
%                 % interpolate NaN points for a better velocity trace
%                 for validTrialN = 1:length(validI)
%                     startI = eyeTrialDataBase.stim.onset(subN, validI(validTrialN));
%                     endI = eyeTrialDataBase.stim.offset(subN, validI(validTrialN));
%                     startIF = maxBeforeFrames-eyeTrialDataBase.stim.beforeFrames(subN, validI(validTrialN))+1;
%                     endIF = maxBeforeFrames+reversalFrames+eyeTrialDataBase.stim.afterFrames(subN, validI(validTrialN));
%                     frames{subN}{speedI, dirI}(validTrialN, startIF:endIF) = eyeTrialDataBase.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI);
%                 end
%             end
%         end
%     end
%     maxFrameLength = max(frameLength);
%
%     % for each rotational speed and direction, draw the mean filtered and unfiltered
%     % velocity trace
%     for speedI = 1:size(conditions, 2)
%         for dirI = 1:size(dirCons, 2)
%             velTAverage{speedI, dirI} = NaN(length(names), maxFrameLength);
%             velTStd{speedI, dirI} = NaN(length(names), maxFrameLength);
%
%             for subN = 1:size(names, 2)
%                 tempStartI = maxFrameLength-frameLength(subN)+1;
%                 velTAverage{speedI, dirI}(subN, tempStartI:end) = nanmean(frames{subN}{speedI, dirI});
%                 velTStd{speedI, dirI}(subN, tempStartI:end) = nanstd(frames{subN}{speedI, dirI});
%             end
%
%             % plotting parameters
%             minFrameLength = min(frameLength);
%             beforeFrames = minFrameLength-reversalFrames-afterFrames;
%             framePerSec = 1/sampleRate;
%             timePReversal = [0:(reversalFrames-1)]*framePerSec*1000;
%             timePBeforeReversal = timePReversal(1)-(beforeFrames+1-[1:beforeFrames])*framePerSec*1000;
%             timePAfterReversal = timePReversal(end)+[1:afterFrames]*framePerSec*1000;
%             timePoints = [timePBeforeReversal timePReversal timePAfterReversal]-min(timePBeforeReversal); % align at the reversal and after...
%             % reversal onset is 0
%             velTmean{speedI, dirI} = nanmean(velTAverage{speedI, dirI}(:, (maxFrameLength-minFrameLength+1):end));
%             % need to plot ste? confidence interval...?
%         end
%         % individual traces
%         figure
%         for subN = 1:size(names, 2)
%             % filtered mean velocity trace
%             plot(timePoints, velTAverage{speedI, 1}(subN, (maxFrameLength-minFrameLength+1):end), '--', 'color', colorPlot(subN, :)) % ccw
%             hold on
%             plot(timePoints, velTAverage{speedI, 2}(subN, (maxFrameLength-minFrameLength+1):end), '-', 'color', colorPlot(subN, :)) % cw
%         end
%         legend({'tiltCCW-motionCCW' 'tiltCCW-motionCW' 'noTilt-CCW' 'noTilt-CW'});% 'tiltCW-motionCCW' 'tiltCW-motionCW' }, ...
% %             'location', 'southeast')
%         title([eyeName{eye}, ' base rotational speed ', num2str(conditions(speedI))])
%         xlabel('Time (ms)')
%         ylabel('Torsional velocity (deg/s)')
%         ylim([-6 6])
%
%         saveas(gca, ['velocityTracesSub_', num2str(conditions(speedI)), '.pdf'])
%     end
%
%     % average across participants, each speed
%     figure
%     for speedI = 1:size(conditions, 2)
%         plot(timePoints, velTmean{speedI, 1}, '--', 'color', colorPlot(speedI, :)) % ccw
%         hold on
%         plot(timePoints, velTmean{speedI, 2}, '-', 'color', colorPlot(speedI, :)) % cw
%     end
%     legend({'25-CCW' '25-CW' '200-CCW' '200-CW'}, 'location', 'southeast')
%     title([eyeName{eye}])
%     xlabel('Time (ms)')
%     ylabel('Torsional velocity (deg/s)')
%     ylim([-6 6])
%
%     saveas(gca, ['velocityTracesSpeeds_', eyeName{eye}, '.pdf'])
% end

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