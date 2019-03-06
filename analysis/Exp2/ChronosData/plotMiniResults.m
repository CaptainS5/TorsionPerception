function [] = plotMiniResults(trial, torsion, pursuit)

startFrame = 1;
endFrame = min(trial.length,400);

timeInMs = [-200 0 200 400 600 800 1000 1200 1400 1600 1800];
tickStep = (2000/5)/(length(timeInMs)-1);

minifig = figure('Position', [300 300 1000, 400],'Name','Main Analysis Window');
subplot(1,2,1,'replace');

axis([startFrame endFrame -15 15]);
%change frames to ms
set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);

hold on;
xlabel('Time(ms)', 'fontsize', 12);
ylabel('Position (degree)', 'fontsize', 12);

plot(startFrame:endFrame,trial.frames.X_filt(startFrame:endFrame),'k');
plot(startFrame:endFrame,trial.frames.Y_filt(startFrame:endFrame),'b');

plot(trial.saccades.X.onsets,trial.frames.X_filt(trial.saccades.X.onsets),'g*');
plot(trial.saccades.X.offsets,trial.frames.X_filt(trial.saccades.X.offsets),'k*');

plot(trial.saccades.Y.onsets,trial.frames.Y_filt(trial.saccades.Y.onsets),'g*');
plot(trial.saccades.Y.offsets,trial.frames.Y_filt(trial.saccades.Y.offsets),'k*');

plot(startFrame:endFrame,trial.frames.S(startFrame:endFrame),'k-.');

plot(pursuit.onset,trial.frames.X_filt(pursuit.onset),'r:+');

line([trial.stim_onset trial.stim_onset], [-100 100],'Color','k','LineStyle',':');
line([trial.stim_offset trial.stim_offset], [-100 100],'Color','k','LineStyle',':');
line([startFrame endFrame], [0 0],'Color','k','LineStyle',':');

subplot(1,2,2,'replace');

axis([startFrame endFrame -5 5]);
%change frames to ms
set(gca,'Xtick',startFrame:tickStep:endFrame,'XTickLabel',timeInMs);

hold on;
xlabel('Time(ms)', 'fontsize', 12);
ylabel('Torsion (degree)', 'fontsize', 12);


plot(startFrame:endFrame,trial.frames.T_filt(startFrame:endFrame));

plot(trial.saccades.T.onsets,trial.frames.T_filt(trial.saccades.T.onsets),'g*');
plot(trial.saccades.T.offsets,trial.frames.T_filt(trial.saccades.T.offsets),'k*');



plot(pursuit.onset,trial.frames.T_filt(pursuit.onset),'r:+');

line([trial.stim_onset trial.stim_onset], [-100 100],'Color','k','LineStyle',':');
line([trial.stim_offset trial.stim_offset], [-100 100],'Color','k','LineStyle',':');

filename = ['Exp' num2str(trial.log.experiment) '_'];
filename = [filename 'Subj' num2str(trial.log.subject) '_'];
filename = [filename 'Block' num2str(trial.log.block) '_'];
filename = [filename 'Trial' num2str(trial.number) '_'];
filename = [filename 'Eye' num2str(trial.log.eye) '_'];
filename = [filename 'Trans' num2str(trial.log.translationalDirection) '_'];
filename = [filename 'Rot' num2str(trial.log.rotationalDirection) '_'];
filename = [filename 'Speed' num2str(trial.log.rotationalSpeed) '_'];
filename = [filename 'Size' num2str(trial.log.diameter) '_'];
filename = fullfile(pwd, 'MiniPlots', filename);

%filename = [num2str(trial.log.eye) '_' num2str(trial.log.translationalDirection) '_' num2str(trial.log.rotationalDirection) '_' num2str(trial.log.rotationalSpeed) '_' num2str(trial.log.block) '_' num2str(trial.number) '_' num2str(trial.log.subject) ];

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 4]);
print(filename,'-dpng');

temp = [];
text = [];

if trial.log.eye
    temp = 'leftEye';
else
    temp = 'rightEye';
end
text = [text temp];

if trial.log.translationalDirection
    temp = ' toLeft';
else
    temp = ' toRight';
end
text = [text temp];

if trial.log.rotationalDirection
    temp = ' counterclockwise ';
else
    temp = ' clockwise ';
end
text = [text temp];

temp = num2str(trial.log.rotationalSpeed);
text = [text temp];

% uicontrol(minifig,'Style','text',...
%     'String', text,...
%     'Position',[250 350 300 20],...
%     'HorizontalAlignment','left',...
%     'backgroundcolor',get(minifig,'color')); %#ok<*NASGU>

% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 4]);
saveas(minifig, [filename '.png']);

close(minifig);