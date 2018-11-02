function [] = updatePlots(trial, torsion, pursuit, data)

startFrame = trial.stim_onset; % 1;
endFrame = min(trial.length, trial.stim_offset+40);

sampleRate = evalin('base','sampleRate');
timeInMs = linspace(0, (endFrame-startFrame+1)*1000/sampleRate, 5); 
tickStep = (2000/5)/(length(timeInMs)-1);
latency = 0.12*sampleRate;
% tickStep = (2000/5)/(length(timeInMs)-1); %?...
%% position plot
% subplot(2,2,2,'replace');
% 
% axis([startFrame endFrame -15 15]);
% %change frames to ms
% set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);
% 
% hold on;
% xlabel('Time(ms)', 'fontsize', 12);
% ylabel('Position (degree)', 'fontsize', 12);
% 
% plot(startFrame:endFrame,trial.frames.X_filt(startFrame:endFrame),'k');
% plot(startFrame:endFrame,trial.frames.Y_filt(startFrame:endFrame),'b');
% 
% plot(trial.saccades.X.onsets,trial.frames.X_filt(trial.saccades.X.onsets),'g*');
% plot(trial.saccades.X.offsets,trial.frames.X_filt(trial.saccades.X.offsets),'k*');
% 
% plot(trial.saccades.Y.onsets,trial.frames.Y_filt(trial.saccades.Y.onsets),'g*');
% plot(trial.saccades.Y.offsets,trial.frames.Y_filt(trial.saccades.Y.offsets),'k*');
% 
% % plot(startFrame:endFrame,trial.frames.S(startFrame:endFrame),'k-.');
% 
% 
% % if pursuit.onsetOnSaccade
% %     plot(trial.saccades.firstSaccadeOffset+trial.stim_onset,trial.frames.X_filt(trial.saccades.firstSaccadeOffset+trial.stim_onset),'r:+');
% % else
% %     plot(pursuit.onset,trial.frames.X_filt(pursuit.onset),'r:+');
% % end
% 
% line([trial.stim_onset trial.stim_onset], [-100 100],'Color','k','LineStyle',':');
% line([trial.stim_offset trial.stim_offset], [-100 100],'Color','k','LineStyle',':');
% line([startFrame endFrame], [0 0],'Color','k','LineStyle',':');
% 
% if sum(trial.lostXframes) > 0
%    plot(startFrame:endFrame, double(trial.lostXframes(startFrame:endFrame)+13), 'r');
% end


%% velocity plot
% subplot(2,2,1,'replace');
% axis([startFrame endFrame -60 60]);
% %change frames to ms
% set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);
% 
% hold on;
% xlabel('Time(ms)', 'fontsize', 12);
% ylabel('Speed (degree/second)', 'fontsize', 12);
% plot(startFrame:endFrame,trial.frames.DX_filt(startFrame:endFrame),'k');
% 
% plot(startFrame:endFrame,trial.frames.DY_filt(startFrame:endFrame),'b');
% plot(pursuit.onset,trial.frames.DX_filt(pursuit.onset),'r:+');
% 
% 
% plot(trial.saccades.X.onsets,trial.frames.DX_filt(trial.saccades.X.onsets),'g*');
% plot(trial.saccades.X.offsets,trial.frames.DX_filt(trial.saccades.X.offsets),'k*');
% 
% plot(trial.saccades.Y.onsets,trial.frames.DY_filt(trial.saccades.Y.onsets),'y*');
% plot(trial.saccades.Y.offsets,trial.frames.DY_filt(trial.saccades.Y.offsets),'b*');
% 
% % if pursuit.onsetOnSaccade
% %     plot(trial.saccades.firstSaccadeOffset+trial.stim_onset,trial.frames.DX_filt(trial.saccades.firstSaccadeOffset+trial.stim_onset),'r:+');
% % else
% %     plot(pursuit.onset,trial.frames.DX_filt(pursuit.onset),'r:+');
% % end
% 
% % plot(startFrame:endFrame,trial.frames.DS(startFrame:endFrame),'k-.');
% 
% line([trial.stim_onset trial.stim_onset], [-100 100],'Color','k','LineStyle',':');
% line([trial.stim_offset trial.stim_offset], [-100 100],'Color','k','LineStyle',':');
% line([startFrame endFrame], [0 0],'Color','k','LineStyle',':');

%% torsion plot
% subplot(2,2,3,'replace');
subplot(3,1,1,'replace');

axis([startFrame endFrame -5 5]);
%change frames to ms
set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);

hold on;
xlabel(['Time(ms) speed ', num2str(trial.log.rotationalSpeed)], 'fontsize', 12);
ylabel('Torsion (degree)', 'fontsize', 12);

% plot segments
% plot(startFrame:endFrame,data.segments(startFrame+data.startFrames(trial.number):endFrame+data.startFrames(trial.number),1),'b:');
% plot(startFrame:endFrame,data.segments(startFrame+data.startFrames(trial.number):endFrame+data.startFrames(trial.number),2),'r:');
% plot(startFrame:endFrame,data.segments(startFrame+data.startFrames(trial.number):endFrame+data.startFrames(trial.number),3),'g:');
% plot(startFrame:endFrame,data.segments(startFrame+data.startFrames(trial.number):endFrame+data.startFrames(trial.number),4),'m:');


plot(startFrame:endFrame,trial.frames.T_filt(startFrame:endFrame), 'LineWidth', 2);

% mark saccade trace
for ii = 1:length(trial.saccades.T.onsets)
    plot(trial.saccades.T.onsets(ii):trial.saccades.T.offsets(ii), trial.frames.T_filt(trial.saccades.T.onsets(ii):trial.saccades.T.offsets(ii)), 'm', 'LineWidth', 2)
end

plot(trial.saccades.T.onsets,trial.frames.T_filt(trial.saccades.T.onsets),'g*', 'MarkerSize', 10);
plot(trial.saccades.T.offsets,trial.frames.T_filt(trial.saccades.T.offsets),'k*', 'MarkerSize', 10);
% 
% plot(pursuit.onset,trial.frames.T_filt(pursuit.onset),'r:+');

% start of stimuli and reversal point
% line([trial.stim_start trial.stim_start], [-100 100],'Color','b','LineStyle','--', 'LineWidth', 2);
line([trial.stim_reversal trial.stim_reversal], [-100 100],'Color','b','LineStyle','--', 'LineWidth', 2);
line([trial.stim_reversal+latency trial.stim_reversal+latency], [-100 100],'Color','k','LineStyle','--', 'LineWidth', 2);

% analysis window
line([trial.stim_onset+latency trial.stim_onset+latency], [-100 100],'Color','k','LineStyle','--', 'LineWidth', 2);
line([trial.stim_offset trial.stim_offset], [-100 100],'Color','k','LineStyle','--', 'LineWidth', 2);

% if sum(trial.lostTframes) > 0
%    plot(startFrame:endFrame, double(trial.lostTframes(startFrame:endFrame)+3), 'r');
% end

try
    plot(startFrame:endFrame,trial.LP(startFrame:endFrame), 'k--', 'LineWidth', 2);
end

set(gca, 'FontSize', 15)

%% torsion velocity plot
subplot(3,1,2,'replace');
% subplot(2,2,4,'replace');
xlim([startFrame endFrame]);
ylim([-15 15])
%change frames to ms
set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);

hold on;
xlabel('Time(ms)', 'fontsize', 12);
ylabel('Torsion velocity (degree/second)', 'fontsize', 12);

plot(startFrame:endFrame,trial.frames.DT_filt(startFrame:endFrame), 'LineWidth', 2);
plot(trial.frames.DT_slowphases,'g:');

% mark saccade trace
for ii = 1:length(trial.saccades.T.onsets)
    plot(trial.saccades.T.onsets(ii):trial.saccades.T.offsets(ii), trial.frames.DT_filt(trial.saccades.T.onsets(ii):trial.saccades.T.offsets(ii)), 'm', 'LineWidth', 2)
end

plot(trial.saccades.T.onsets,trial.frames.DT_filt(trial.saccades.T.onsets),'g*', 'MarkerSize', 10);
plot(trial.saccades.T.offsets,trial.frames.DT_filt(trial.saccades.T.offsets),'k*', 'MarkerSize', 10);

% plot(trial.saccades.T.onsets,trial.frames.DT_filt(trial.saccades.T.onsets),'g*');
% plot(trial.saccades.T.offsets,trial.frames.DT_filt(trial.saccades.T.offsets),'k*');
% 
% plot(pursuit.onset,trial.frames.DT_filt(pursuit.onset),'r:+');

% analysis window
line([trial.stim_reversal+latency trial.stim_reversal+latency], [-100 100],'Color','k','LineStyle','--', 'LineWidth', 2);
line([trial.stim_onset+latency trial.stim_onset+latency], [-100 100],'Color','k','LineStyle','--', 'LineWidth', 2);
line([trial.stim_offset trial.stim_offset], [-100 100],'Color','k','LineStyle','--', 'LineWidth', 2);

% start of stimuli and reversal point
% line([trial.stim_start trial.stim_start], [-100 100],'Color','b','LineStyle','--', 'LineWidth', 2);
line([trial.stim_reversal trial.stim_reversal], [-100 100],'Color','b','LineStyle','--', 'LineWidth', 2);

line([startFrame endFrame], [0 0],'Color','k','LineStyle',':');

%% torsion velocity plot, unfiltered
subplot(3,1,3,'replace');
% subplot(2,2,4,'replace');
axis([startFrame endFrame -15 15]);
%change frames to ms
set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);

hold on;
xlabel('Time(ms)', 'fontsize', 12);
ylabel('Torsion velocity unfiltered (degree/second)', 'fontsize', 12);

plot(startFrame:endFrame,trial.frames.DT(startFrame:endFrame), 'LineWidth', 2);
plot(trial.frames.DTUnfiltered_slowphases,'g:');

% plot(trial.saccades.T.onsets,trial.frames.DT_filt(trial.saccades.T.onsets),'g*');
% plot(trial.saccades.T.offsets,trial.frames.DT_filt(trial.saccades.T.offsets),'k*');
% 
% plot(pursuit.onset,trial.frames.DT_filt(pursuit.onset),'r:+');

% analysis window
line([trial.stim_reversal+latency trial.stim_reversal+latency], [-100 100],'Color','k','LineStyle','--', 'LineWidth', 2);
line([trial.stim_onset+latency trial.stim_onset+latency], [-100 100],'Color','k','LineStyle','--', 'LineWidth', 2);
line([trial.stim_offset trial.stim_offset], [-100 100],'Color','k','LineStyle','--', 'LineWidth', 2);

% start of stimuli and reversal point
% line([trial.stim_start trial.stim_start], [-100 100],'Color','b','LineStyle','--', 'LineWidth', 2);
line([trial.stim_reversal trial.stim_reversal], [-100 100],'Color','b','LineStyle','--', 'LineWidth', 2);

line([startFrame endFrame], [0 0],'Color','k','LineStyle',':');

%% onset plot
% subplot(2,3,3,'replace');
% subplot(1,3,3,'replace');
% 
% axis([startFrame endFrame -5 5]);
% %change frames to ms
% set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);
% 
% hold on;
% xlabel('Time(ms)', 'fontsize', 12);
% ylabel('Torsion (degree)', 'fontsize', 12);
% 
% plot(startFrame:endFrame,trial.frames.T_filt(startFrame:endFrame));
% 
% plot(trial.saccades.T.onsets,trial.frames.T_filt(trial.saccades.T.onsets),'g*');
% plot(trial.saccades.T.offsets,trial.frames.T_filt(trial.saccades.T.offsets),'k*');
% 
% % plot segment quality
% plot([trial.stim_onset trial.stim_offset], [0.7 0.7],'Color','k','LineStyle',':');
% plot(startFrame:endFrame,data.segmentsCorrelation(startFrame+data.startFrames(trial.number):endFrame+data.startFrames(trial.number),1),'b:');
% plot(startFrame:endFrame,data.segmentsCorrelation(startFrame+data.startFrames(trial.number):endFrame+data.startFrames(trial.number),2),'r:');
% plot(startFrame:endFrame,data.segmentsCorrelation(startFrame+data.startFrames(trial.number):endFrame+data.startFrames(trial.number),3),'g:');
% plot(startFrame:endFrame,data.segmentsCorrelation(startFrame+data.startFrames(trial.number):endFrame+data.startFrames(trial.number),4),'m:');
% 
% % plot(pursuit.onset,trial.frames.T_filt(pursuit.onset),'r:+');
% 
% line([trial.stim_onset trial.stim_onset], [-100 100],'Color','k','LineStyle',':');
% line([trial.stim_offset trial.stim_offset], [-100 100],'Color','k','LineStyle',':');
% 
% 
% 
% if sum(trial.lostTframes) > 0
%    plot(startFrame:endFrame, double(trial.lostTframes(startFrame:endFrame)+3), 'r');
% end


%new
% 
% axis([startFrame endFrame -40 40]);
% %change frames to ms
% set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);
% 
% hold on;
% xlabel('Time(ms)', 'fontsize', 12);
% ylabel('Position (degree)', 'fontsize', 12);
% 
% plot(trial.frames.DX_filt)
% plot(trial.frames.DT_filt,'r')


end