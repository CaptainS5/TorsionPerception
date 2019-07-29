% plot velocity traces, generate csv file for plotting in R, Exp3
% anticipatory torsion control
initializeParas;

%% Experimental trials, directions not merged, generate csv files for R plotting
% initialize frames--lengths are fixed
frameLength = 2*sampleRate; % -400 from RDP onset to RDP offset, 400+1600 ms
for subN = 1:size(names, 2)
    for trialTypeI = 1:size(trialTypeCons, 2)
        for dirI = 1:size(transDirCons, 2)
            validI = find(eyeTrialData.errorStatus(subN, :)==0 & eyeTrialData.trialType(subN, :)==trialTypeCons(trialTypeI) ...
                & eyeTrialData.translationalDirection(subN, :)==transDirCons(dirI));
            framesT{trialTypeI}{subN, dirI} = NaN(length(validI), frameLength); % rows are trials, columns are frames, torsion
            framesH{trialTypeI}{subN, dirI} = NaN(length(validI), frameLength); % rows are trials, columns are frames, horizontal pursuit
            
            % fill in the velocity trace of each frame
            for validTrialN = 1:length(validI)
                startI = eyeTrialData.frameLog.stimOnset(subN, validI(validTrialN))-0.4*sampleRate+1;
                endI = eyeTrialData.frameLog.stimOffset(subN, validI(validTrialN));
                framesT{trialTypeI}{subN, dirI}(validTrialN, :) = eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI);
                framesH{trialTypeI}{subN, dirI}(validTrialN, :) = eyeTrialData.frames{subN, validI(validTrialN)}.DX_noSac(startI:endI);
            end
        end
    end
end

% for each head tilt condition and each direction, draw the mean filtered and unfiltered
% velocity trace
for trialTypeI = 1:size(trialTypeCons, 2)
        for dirI = 1:size(transDirCons, 2)
        velTAverage{trialTypeI, dirI} = NaN(length(names), frameLength);
        velTStd{trialTypeI, dirI} = NaN(length(names), frameLength);
        velHAverage{trialTypeI, dirI} = NaN(length(names), frameLength);
        velHStd{trialTypeI, dirI} = NaN(length(names), frameLength);
        
        for subN = 1:size(names, 2)
            if ~isempty(framesT{trialTypeI}{subN, dirI})
                velTAverage{trialTypeI, dirI}(subN, :) = nanmean(framesT{trialTypeI}{subN, dirI});
                velTStd{trialTypeI, dirI}(subN, :) = nanstd(framesT{trialTypeI}{subN, dirI});
                
                velHAverage{trialTypeI, dirI}(subN, :) = nanmean(framesH{trialTypeI}{subN, dirI});
                velHStd{trialTypeI, dirI}(subN, :) = nanstd(framesH{trialTypeI}{subN, dirI});
            end
        end
        velTmean{trialTypeI, dirI} = nanmean(velTAverage{trialTypeI, dirI});
        velHmean{trialTypeI, dirI} = nanmean(velHAverage{trialTypeI, dirI});
    end
end
% plotting parameters
framePerSec = 1/sampleRate;
timePoints = -395:5:1600; % RDP onset is 0

cd(velTraceFolder)
%% torsion
% % plot individual traces in different figures
% for subN = 1:size(names, 2)
%     figure
%     for trialTypeI = 1:size(trialTypeCons, 2)
%         subplot(2, 1, trialTypeI)
%         hold on
%         % filtered mean velocity trace
%         plot(timePoints, velTAverage{trialTypeI, 1}(subN, :), '--')
%         plot(timePoints, velTAverage{trialTypeI, 2}(subN, :), '--')
%         legend({'left moving' 'right moving'}, ...
%             'location', 'northwest')
%         title([trialTypeNames{trialTypeI}])
%         xlabel('Time (ms)')
%         ylabel('Torsional velocity (deg/s)')
%         % ylim([-0.5 0.5])
%     end
%     saveas(gca, ['velocityTracesTorsional_', names{subN}, '.pdf'])
% end
% 
% % plot average traces in different head conditions, directions not
% % merged
% figure
% for trialTypeI = 1:size(trialTypeCons, 2)
%     subplot(2, 1, trialTypeI)
%     hold on
%     % filtered mean velocity trace
%     plot(timePoints, velTmean{trialTypeI, 1}, '--');
%     plot(timePoints, velTmean{trialTypeI, 2}, '--');
%     legend({'left moving' 'right moving'}, ...
%         'location', 'northwest')
%     title([trialTypeNames{trialTypeI}])
%     xlabel('Time (ms)')
%     ylabel('Torsional velocity (deg/s)')
% %     ylim([-2.5 2.5])
% end
% saveas(gca, ['velocityTracesTorsional_notMerged.pdf'])

%% pursuit
% plot individual traces in different figures
for subN = 1:size(names, 2)
    figure
    for trialTypeI = 1:size(trialTypeCons, 2)
        subplot(2, 1, trialTypeI)
        hold on
        % filtered mean velocity trace
        plot(timePoints, velHAverage{trialTypeI, 1}(subN, :), '--')
        plot(timePoints, velHAverage{trialTypeI, 2}(subN, :), '--')
        legend({'left moving' 'right moving'}, ...
            'location', 'northwest')
        title([trialTypeNames{trialTypeI}])
        xlabel('Time (ms)')
        ylabel('Horizontal velocity (deg/s)')
        % ylim([-0.5 0.5])
    end
    saveas(gca, ['velocityTracesHorizontal_', names{subN}, '.pdf'])
end

% plot average traces in different head conditions, directions not
% merged
figure
for trialTypeI = 1:size(trialTypeCons, 2)
    subplot(2, 1, trialTypeI)
    hold on
    % filtered mean velocity trace
    plot(timePoints, velHmean{trialTypeI, 1}, '--');
    plot(timePoints, velHmean{trialTypeI, 2}, '--');
    legend({'left moving' 'right moving'}, ...
        'location', 'northwest')
    title([trialTypeNames{trialTypeI}])
    xlabel('Time (ms)')
    ylabel('Horizontal velocity (deg/s)')
%     ylim([-2.5 2.5])
end
saveas(gca, ['velocityTracesHorizontal_notMerged.pdf'])

%% generate csv files, each file for one speed condition
% % each row is the mean velocity trace of one participant
% % use the min frame length--the lengeth where all participants have
% % valid data points
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