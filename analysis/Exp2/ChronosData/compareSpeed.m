timeInMs = [-200 0 200 400 600 800 1000 1200 1400 1600 1800];
tickStep = (2000/5)/(length(timeInMs)-1);
axis([trial.startFrame trial.endFrame -50 50]);
%change frames to ms
set(gca,'Xtick',trial.startFrame:tickStep:trial.endFrame,'XTickLabel',timeInMs);

hold on;
xlabel('Time(ms)', 'fontsize', 12);
ylabel('Position (degree)', 'fontsize', 12);

plot(trial.frames.DX_filt)
plot(trial.frames.DY_filt,'y')
plot(trial.frames.DT_filt,'r')