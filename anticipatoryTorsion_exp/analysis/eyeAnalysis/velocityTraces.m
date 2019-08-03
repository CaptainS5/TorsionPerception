% plot velocity traces, generate csv file for plotting in R, Exp3
% anticipatory torsion control
initializeParas;
eyeTrialData.translationalDirection = double(eyeTrialData.translationalDirection);

%% directions merged, plot for the manuscript
% initialize frames--lengths are fixed
frameLength = 1*sampleRate+1; % -250 from RDP onset to 750 ms, 250+750 ms
for subN = 1:size(names, 2)
    for trialTypeI = 1:size(trialTypeCons, 2)
        validI = find(eyeTrialData.errorStatus(subN, :)==0 & eyeTrialData.trialType(subN, :)==trialTypeCons(trialTypeI));
        framesT{trialTypeI}{subN} = NaN(length(validI), frameLength); % rows are trials, columns are frames, torsion
        framesH{trialTypeI}{subN} = NaN(length(validI), frameLength); % rows are trials, columns are frames, horizontal pursuit
        
        % fill in the velocity trace of each frame
        for validTrialN = 1:length(validI)
            startI = eyeTrialData.frameLog.stimOnset(subN, validI(validTrialN))-0.25*sampleRate;
            endI = eyeTrialData.frameLog.stimOnset(subN, validI(validTrialN))+0.75*sampleRate;
            framesT{trialTypeI}{subN}(validTrialN, :) = eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI).*eyeTrialData.translationalDirection(subN, validI(validTrialN)); % cw is positive, 1=cw
            framesH{trialTypeI}{subN}(validTrialN, :) = -eyeTrialData.frames{subN, validI(validTrialN)}.DX_noSac(startI:endI).*eyeTrialData.translationalDirection(subN, validI(validTrialN)); % left is positive... -1=left
        end        
    end
end

% for each head tilt condition and each direction, draw the mean filtered and unfiltered
% velocity trace
for trialTypeI = 1:size(trialTypeCons, 2)
        velTAverage{trialTypeI} = NaN(length(names), frameLength);
        velTStd{trialTypeI} = NaN(length(names), frameLength);
        velHAverage{trialTypeI} = NaN(length(names), frameLength);
        velHStd{trialTypeI} = NaN(length(names), frameLength);
        
        for subN = 1:size(names, 2)
            if ~isempty(framesT{trialTypeI}{subN})
                velTAverage{trialTypeI}(subN, :) = nanmean(framesT{trialTypeI}{subN});
                velTStd{trialTypeI}(subN, :) = nanstd(framesT{trialTypeI}{subN});
                
                velHAverage{trialTypeI}(subN, :) = nanmean(framesH{trialTypeI}{subN});
                velHStd{trialTypeI}(subN, :) = nanstd(framesH{trialTypeI}{subN});
            end
        end
        velTmean{trialTypeI} = nanmean(velTAverage{trialTypeI});
        velTstd{trialTypeI} = nanstd(velTAverage{trialTypeI});
        velHmean{trialTypeI} = nanmean(velHAverage{trialTypeI});
        velHstd{trialTypeI} = nanstd(velHAverage{trialTypeI});
end
% plotting parameters
framePerSec = 1/sampleRate;
timePoints = -250:5:750; % RDP onset is 0

cd(velTraceFolder)
% plot averaged traces
% horizontal pursuit
figure
hold on
for trialTypeI = 1:size(trialTypeCons, 2)
    % filtered mean velocity trace
    p{trialTypeI} = plot(timePoints, velHmean{trialTypeI}, 'color', colorPlot(trialTypeI, :));
    patch([timePoints, fliplr(timePoints)], ...
        [velHmean{trialTypeI}-velHstd{trialTypeI}, fliplr(velHmean{trialTypeI}+velHstd{trialTypeI})], ...
        colorPlot(trialTypeI, :), 'FaceAlpha', 0.3)
end
% anticipatory time window
line([-50 -50], [-3 15])
line([50 50], [-3 15])
% target velocity
targetVel = 10*cos(10/180*pi);
line([0 750], [targetVel targetVel], 'LineStyle', '--')
line([0 0], [0 targetVel], 'LineStyle', '--')
line([-250 0], [0 0], 'LineStyle', '--')
legend([p{:}], {'no rotation' 'natural'}, ...
    'location', 'northwest')
title('horizontal pursuit')
xlim([-250, 750])
xlabel('Time (ms)')
ylabel('Horizontal eye velocity (deg/s)')
ylim([-3 15])
set(gca, 'XTick', [-250, 0, 250, 500, 750], 'YTick', [0, 5, 10, 15])
saveas(gca, ['velocityTracesHorizontal_manuscript.pdf'])

% torsion
figure
hold on
for trialTypeI = 1:size(trialTypeCons, 2)
    % filtered mean velocity trace
    p{trialTypeI} = plot(timePoints, velTmean{trialTypeI}, 'color', colorPlot(trialTypeI, :));
    patch([timePoints, fliplr(timePoints)], ...
        [velTmean{trialTypeI}-velTstd{trialTypeI}, fliplr(velTmean{trialTypeI}+velTstd{trialTypeI})], ...
        colorPlot(trialTypeI, :), 'FaceAlpha', 0.3)
end
% anticipatory time window
line([-50 -50], [-6 6])
line([50 50], [-6 6])
line([-250 750], [0 0], 'LineStyle', '--')
legend([p{:}], {'no rotation' 'natural'}, ...
    'location', 'northwest')
title('horizontal pursuit')
xlim([-250, 750])
xlabel('Time (ms)')
ylabel('Torsional eye velocity (deg/s)')
ylim([-6 6])
set(gca, 'XTick', [-250, 0, 250, 500, 750], 'YTick', [-6, -3, 0, 3, 6])
saveas(gca, ['velocityTracesTorsional_manuscript.pdf'])

%% Experimental trials, directions not merged
% % initialize frames--lengths are fixed
% frameLength = 2*sampleRate; % -400 from RDP onset to RDP offset, 400+1600 ms
% for subN = 1:size(names, 2)
%     for trialTypeI = 1:size(trialTypeCons, 2)
%         for dirI = 1:size(transDirCons, 2)
%             validI = find(eyeTrialData.errorStatus(subN, :)==0 & eyeTrialData.trialType(subN, :)==trialTypeCons(trialTypeI) ...
%                 & eyeTrialData.translationalDirection(subN, :)==transDirCons(dirI));
%             framesT{trialTypeI}{subN, dirI} = NaN(length(validI), frameLength); % rows are trials, columns are frames, torsion
%             framesH{trialTypeI}{subN, dirI} = NaN(length(validI), frameLength); % rows are trials, columns are frames, horizontal pursuit
%             
%             % fill in the velocity trace of each frame
%             for validTrialN = 1:length(validI)
%                 startI = eyeTrialData.frameLog.stimOnset(subN, validI(validTrialN))-0.4*sampleRate+1;
%                 endI = eyeTrialData.frameLog.stimOffset(subN, validI(validTrialN));
%                 framesT{trialTypeI}{subN, dirI}(validTrialN, :) = eyeTrialData.frames{subN, validI(validTrialN)}.DT_noSac(startI:endI);
%                 framesH{trialTypeI}{subN, dirI}(validTrialN, :) = eyeTrialData.frames{subN, validI(validTrialN)}.DX_noSac(startI:endI);
%             end
%         end
%     end
% end
% 
% % for each head tilt condition and each direction, draw the mean filtered and unfiltered
% % velocity trace
% for trialTypeI = 1:size(trialTypeCons, 2)
%         for dirI = 1:size(transDirCons, 2)
%         velTAverage{trialTypeI, dirI} = NaN(length(names), frameLength);
%         velTStd{trialTypeI, dirI} = NaN(length(names), frameLength);
%         velHAverage{trialTypeI, dirI} = NaN(length(names), frameLength);
%         velHStd{trialTypeI, dirI} = NaN(length(names), frameLength);
%         
%         for subN = 1:size(names, 2)
%             if ~isempty(framesT{trialTypeI}{subN, dirI})
%                 velTAverage{trialTypeI, dirI}(subN, :) = nanmean(framesT{trialTypeI}{subN, dirI});
%                 velTStd{trialTypeI, dirI}(subN, :) = nanstd(framesT{trialTypeI}{subN, dirI});
%                 
%                 velHAverage{trialTypeI, dirI}(subN, :) = nanmean(framesH{trialTypeI}{subN, dirI});
%                 velHStd{trialTypeI, dirI}(subN, :) = nanstd(framesH{trialTypeI}{subN, dirI});
%             end
%         end
%         velTmean{trialTypeI, dirI} = nanmean(velTAverage{trialTypeI, dirI});
%         velHmean{trialTypeI, dirI} = nanmean(velHAverage{trialTypeI, dirI});
%     end
% end
% % plotting parameters
% framePerSec = 1/sampleRate;
% timePoints = -395:5:1600; % RDP onset is 0

% cd(velTraceFolder)
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
% % plot individual traces in different figures
% for subN = 1:size(names, 2)
%     figure
%     for trialTypeI = 1:size(trialTypeCons, 2)
%         subplot(2, 1, trialTypeI)
%         hold on
%         % filtered mean velocity trace
%         plot(timePoints, velHAverage{trialTypeI, 1}(subN, :), '--')
%         plot(timePoints, velHAverage{trialTypeI, 2}(subN, :), '--')
%         legend({'left moving' 'right moving'}, ...
%             'location', 'northwest')
%         title([trialTypeNames{trialTypeI}])
%         xlabel('Time (ms)')
%         ylabel('Horizontal velocity (deg/s)')
%         % ylim([-0.5 0.5])
%     end
%     saveas(gca, ['velocityTracesHorizontal_', names{subN}, '.pdf'])
% end

% % plot average traces in different head conditions, directions not
% % merged
% figure
% for trialTypeI = 1:size(trialTypeCons, 2)
%     subplot(2, 1, trialTypeI)
%     hold on
%     % filtered mean velocity trace
%     plot(timePoints, velHmean{trialTypeI, 1}, '--');
%     plot(timePoints, velHmean{trialTypeI, 2}, '--');
%     legend({'left moving' 'right moving'}, ...
%         'location', 'northwest')
%     title([trialTypeNames{trialTypeI}])
%     xlabel('Time (ms)')
%     ylabel('Horizontal velocity (deg/s)')
% %     ylim([-2.5 2.5])
% end
% saveas(gca, ['velocityTracesHorizontal_notMerged.pdf'])