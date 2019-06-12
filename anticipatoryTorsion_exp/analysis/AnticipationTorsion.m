%%% Anticipation Torsion Analysis
% Austin Rothwell - Aug 15 2016

%% X-axis Position Anticipation from trigger start
Xpos = [];
for i = 1:length(data.startFrames)
    Xpos = [Xpos; data.X_filt(data.startFrames(i):data.startFrames(i)+400)'];
end
meanXpos = mean(Xpos);
sdXpos = std(Xpos);

dyR = sdXpos';
xR = [1:401]';
yR = meanXpos';
h1 = fill([xR;flipud(xR)], [yR-dyR;flipud(yR+dyR)],[.5 .5 .9], 'linestyle', 'none');
set(h1, 'facealpha', .3);

line(1:401, meanXpos, 'linewidth', 2)
box off;
set(gcf, 'color', 'w');
title('Mean Eye X position across Block 1 (Natural rotation): Subj02')
line([100 100], [-15 10],'Color','k','LineStyle',':');
xlabel('Frames', 'fontsize', 12);
ylabel('X Position (degree)', 'fontsize', 12);
legend('Mean eye X position', 'Stimulus onset');

%% X-axis Position Anticipation from trigger start excluding error trials
Xpos = [];

errors = load('./ErrorFiles/Exp14_Subject07_Block02_L_errorFile.mat');
for i = 1:length(data.startFrames)
    if errors.errorStatus(i) == 0
        Xpos = [Xpos; data.X_filt(data.startFrames(i):data.startFrames(i)+400)'];
    end
end
meanXpos = mean(Xpos);
sdXpos = std(Xpos);

dyR = sdXpos';
xR = [1:401]';
yR = meanXpos';
h1 = fill([xR;flipud(xR)], [yR-dyR;flipud(yR+dyR)],[.5 .5 .9], 'linestyle', 'none');
set(h1, 'facealpha', .3);

line(1:401, meanXpos, 'linewidth', 2)
box off;
set(gcf, 'color', 'w');
title('Mean Eye X position across Block 1 (Natural rotation): Subj02')
line([100 100], [-15 10],'Color','k','LineStyle',':');
xlabel('Frames', 'fontsize', 12);
ylabel('X Position (degree)', 'fontsize', 12);
legend('Mean eye X position', 'Stimulus onset');

%% X-axis Position Anticipation from pursuit onset
onsetXpos = [];
for i = 1:length(data.startFrames)
    if(~isnan(results.trial(i,28)))
        onsetXpos = [onsetXpos; data.X_filt(data.startFrames(i)+100+ms2frames(results.trial(i,28)):data.startFrames(i)+100+ms2frames(results.trial(i,28))+200)'];
    end
end
meanXpos = mean(onsetXpos);
sdXpos = std(onsetXpos);

dyR = sdXpos';
xR = [1:201]';
yR = meanXpos';
h1 = fill([xR;flipud(xR)], [yR-dyR;flipud(yR+dyR)],[.5 .5 .9], 'linestyle', 'none');
set(h1, 'facealpha', .3);

stuff = line(1:201, meanXpos, 'linewidth', 2);
box off;
set(gcf, 'color', 'w');
title('Mean Eye X position across Block 1 (Natural rotation): Subj02')
%stim = line([100 100], [-15 10],'Color','k','LineStyle',':');
xlabel('Frames', 'fontsize', 12);
ylabel('X Position (degree)', 'fontsize', 12);
legend([stuff stim], {'Mean eye X position', 'Stimulus onset'});

%% X-axis Velocity Anticipation - 10 trial binned average    
Xmeans = [];
errors = load('./ErrorFiles/Exp14_Subject08_Block12_L_errorFile.mat');
for n = 1:10
    DXpos = [];
    for i = n*10-9:n*10
        if errors.errorStatus(i) == 0
            DXpos = [DXpos; data.DX_filt(data.startFrames(i)+90:data.startFrames(i)+110)'];
        end
    end
    meanDXpos = mean(DXpos);
    stdDXpos = std(DXpos);
    Xmeans = [Xmeans mean(meanDXpos)];
end
Xmeans
mean(Xmeans)
std(Xmeans)
sects = {'1-10' '11-20' '21-30' '31-40' '41-50' '51-60' '61-70' '71-80' '81-90' '91-100'};
bar(Xmeans);
box off;
set(gca, 'Xtick', 1:10, 'XTickLabel', sects); 
set(gcf, 'color', 'w');
title({'Mean Eye X velocity from -50ms stim onset to 50ms' '- Block 12 (No rotation): Subj05'})
xlabel('Block Trials Sections', 'fontsize', 12);
ylabel('X-axis Velocity (deg/s)', 'fontsize', 12);



%% X-axis Velocity anticipation from trigger onset
DXpos = [];
for i = 1:length(data.startFrames)
    DXpos = [DXpos; data.DX_filt(data.startFrames(i)+40:data.startFrames(i)+400)'];
end
meanDXpos = mean(DXpos);
stdDXpos = std(DXpos);

dyR = stdDXpos';
xR = [1:361]';
yR = meanDXpos';
h1 = fill([xR;flipud(xR)], [yR-dyR;flipud(yR+dyR)],[.5 .5 .9], 'linestyle', 'none');
set(h1, 'facealpha', .3);
line(1:361, meanDXpos, 'linewidth', 2)
box off;
set(gcf, 'color', 'w');
title('Mean Eye Torsion position across Block 1 (Natural rotation): Subj02')
%line([40 40], [0 -10],'Color','k','LineStyle',':');
stim = [zeros(60,1)' (zeros(301, 1)-10)'];
hold on;
plot(1:361, stim,'Color','k','LineStyle',':');
xlabel('Frames', 'fontsize', 12);
ylabel('X-axis Velocity (deg/s)', 'fontsize', 12);
legend('Mean eye X Velocity', 'Stimulus');


%% Average X-axis velocity across BLOCKS
Xmeans = [mean([-0.6735, -1.0420 ]) mean([-1.4477, -1.1125])    mean([-1.5349, -1.7042])];  %fill in with mean X-axis velocity
Xsems = [mean([0.03375, 0.04676]) mean([0.07075, 0.04477])    mean([0.05729, 0.06494])];  %fill in with SEM X-axis velocity
Xax = {'Natural Rotation' 'Unnatural Rotation' 'No Rotation'};
bar(Xmeans, 'FaceColor', [.9 .4 .5]);
hold on;
errorbar(Xmeans, Xsems, 'b.');
box off;
set(gca, 'Xtick', 1:10, 'XTickLabel', Xax); 
set(gcf, 'color', 'w');
title({'Mean Eye X-axis velocity from -50ms stim onset to 50ms: Subj08'})
xlabel('Rotation type', 'fontsize', 12);
ylabel('Mean X-axis Velocity (deg/s)', 'fontsize', 12);


%% Torsional Position Anticipation from tigger onset
Tpos = [];
for i = 1:length(data.startFrames)
    Tpos = [Tpos; data.T_filt(data.startFrames(i):data.startFrames(i)+300)'];
end
meanTpos = mean(Tpos);
sdTpos = std(Tpos);

dyR = sdTpos';
xR = [1:301]';
yR = meanTpos';
h1 = fill([xR;flipud(xR)], [yR-dyR;flipud(yR+dyR)],[.5 .5 .9], 'linestyle', 'none');
set(h1, 'facealpha', .3);

t = line(1:301, meanTpos, 'linewidth', 2);
box off;
axis([0, 301, -2, 3]);
set(gcf, 'color', 'w');
title('Mean Eye Torsion position across Block 1 (Natural rotation): Subj02')
stim = line([100 100], [4 -1],'Color','k','LineStyle',':');
xlabel('Frames', 'fontsize', 12);
ylabel('Torsion Position (degree)', 'fontsize', 12);
legend([t], {'Mean eye T position'});

%% Torsion position anticipation from pursuit onset
Tpos = [];
for i = 30:40%length(data.startFrames)
    if(~isnan(results.trial(i,28)))
        Tpos = [Tpos; data.T_filt(data.startFrames(i)+100+ms2frames(results.trial(i,28)):data.startFrames(i)+100+ms2frames(results.trial(i,28))+300)'];
    end
end
meanTpos = mean(Tpos);
sdTpos = std(Tpos);

dyR = sdTpos';
xR = [1:301]';
yR = meanTpos';
h1 = fill([xR;flipud(xR)], [yR-dyR;flipud(yR+dyR)],[.5 .5 .9], 'linestyle', 'none');
set(h1, 'facealpha', .3);

t = line(1:301, meanTpos, 'linewidth', 2);
box off;
axis([0, 301, -3, 0]);
set(gcf, 'color', 'w');
title('Mean Eye Torsion position across Block 1 (Natural rotation): Subj02')
%stim = line([100 100], [4 -1],'Color','k','LineStyle',':');
xlabel('Frames', 'fontsize', 12);
ylabel('Torsion Position (degree)', 'fontsize', 12);
legend([t], {'Mean eye T position'});


%% Torsional Velocity Anticipation Across trial bins
means = [];
vels = [];
errors = load('./ErrorFiles/Exp14_Subject07_Block06_L_errorFile.mat');
for n = 1:10
    DTpos = [];
    for i = n*10-9:n*10%length(data.startFrames)
        if errors.errorStatus(i) == 0
            DTpos = [DTpos; data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+109)'];
            vels = [vels mean(data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+109))];
        end
    end
    meanDTpos = mean(DTpos);
    sdDTpos = std(DTpos);
    means = [means mean(meanDTpos)];
end
mean(vels)
std(vels)
sects = {'1-10' '11-20' '21-30' '31-40' '41-50' '51-60' '61-70' '71-80' '81-90' '91-100'};
bar(means);
box off;
set(gca, 'Xtick', 1:10, 'XTickLabel', sects); 
set(gcf, 'color', 'w');
title({'Mean Eye Torsion velocity from -50ms stim onset to 50ms' '- Block 2 (Unatural rotation): Subj05'})
xlabel('Block trials sections', 'fontsize', 12);
ylabel('Torsion Velocity (deg/s)', 'fontsize', 12);





%% Torsional Velocity Anticipation from trigger onset
Tpos = [];
for i = 1:100%length(data.startFrames)
    Tpos = [Tpos; data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+110)'];
end
meanTpos = mean(Tpos);
sdTpos = std(Tpos);
% dyR = sdDTpos';
% xR = [1:361]';
% yR = meanDTpos';
% h1 = fill([xR;flipud(xR)], [yR-dyR;flipud(yR+dyR)],[.5 .5 .9], 'linestyle', 'none');
% set(h1, 'facealpha', .3);


line(-10:10, meanDTpos, 'linewidth', 2)
box off;
axis([-10 10 -1 1]);
set(gcf, 'color', 'w');
title('Mean Eye Torsion position across Block 1 (Natural rotation): Subj02')
line([0 0], [4 -2],'Color','k','LineStyle',':');
xlabel('Frames', 'fontsize', 12);
ylabel('Torsion Velocity (deg/s)', 'fontsize', 12);
legend('Mean eye T Velocity', 'Stimulus onset');

%% Torsional Velocity anticipation from pursuit onset
Tpos = [];
for i = 1:length(data.startFrames)
    if(~isnan(results.trial(i,28)))
        Tpos = [Tpos; data.T_filt(data.startFrames(i)+100+ms2frames(results.trial(i,28)):data.startFrames(i)+100+ms2frames(results.trial(i,28))+300)'];
    end
end
meanTpos = mean(Tpos);
sdTpos = std(Tpos);
% dyR = sdDTpos';
% xR = [1:361]';
% yR = meanDTpos';
% h1 = fill([xR;flipud(xR)], [yR-dyR;flipud(yR+dyR)],[.5 .5 .9], 'linestyle', 'none');
% set(h1, 'facealpha', .3);

line(-10:10, meanDTpos, 'linewidth', 2)
box off;
axis([-10 10 -1 1]);
set(gcf, 'color', 'w');
title('Mean Eye Torsion position across Block 1 (Natural rotation): Subj02')
line([0 0], [4 -2],'Color','k','LineStyle',':');
xlabel('Frames', 'fontsize', 12);
ylabel('Torsion Velocity (deg/s)', 'fontsize', 12);
legend('Mean eye T Velocity', 'Stimulus onset');

%% Average Torsional velocity across BLOCKS
Tmeans = [mean([0.5493, 0.2139 ]) mean([0.2406, -0.0664])    mean([0.4237, 0.0726])];  %fill in with mean X-axis velocity
Tsems = [mean([0.07135, 0.05352]) mean([0.07178, 0.10788])    mean([0.13018, 0.07591])];
Xax = {'Natural Rotation' 'Unnatural Rotation' 'No Rotation'};
bar(Tmeans, 'FaceColor', [.9 .4 .5]);
hold on;
errorbar(Tmeans, Tsems, 'b.');
box off;
set(gca, 'Xtick', 1:10, 'XTickLabel', Xax); 
set(gcf, 'color', 'w');
title({'Mean Eye Torsion velocity from -50ms stim onset to 50ms: Subj07'})
xlabel('Rotation type', 'fontsize', 12);
ylabel('Mean Torsion Velocity (deg/s)', 'fontsize', 12);



%% Correlation between horizontal anticipation and torsional anticipation

Tant = [];
Hant = [];
errors = load('./ErrorFiles/Exp14_Subject04_Block06_L_errorFile.mat');
for i = 1:length(data.startFrames)
    if errors.errorStatus(i) == 0
        Tant = [Tant; mean(data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+110))];
        Hant = [Hant; mean(data.DX_filt(data.startFrames(i)+90:data.startFrames(i)+110))];
    end
end

corrcoef(Tant,Hant)
scatter(Tant, Hant);
set(gcf, 'color', 'w');
title({'Torsion anticipation vs. horizontal anticipation from frame 90-110: Subj04 Block 2L'})
xlabel('Mean Torsion Anticipation (deg/s)', 'fontsize', 12);
ylabel('Mean Horizontal Anticipation deg/s)', 'fontsize', 12);




%% mean block torsional velocity, taking best eye

subject = '06';
NaturalFirst = 1;
blocklist = {'02' '04' '06' '08' '10' '12'};
meanvels = [];
stdvels = [];
for block = 1:6
   
    filename = ['Subject' subject '_Block' blocklist{block} '_L.dat'];
    filelocation = ['C:\Users\admin\TorsionAnticipation\subj' subject];
    data = readDataFile(filename, filelocation);
    data = socscalexy(data);

    Lvels = [];
    errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_L_errorFile.mat']);
    for n = 1:10
        for i = n*10-9:n*10
            if errors.errorStatus(i) == 0
                Lvels = [Lvels mean(data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+109))];
            end
        end
    end
    
    Rvels = [];
    errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
    for n = 1:10
        for i = n*10-9:n*10
            if errors.errorStatus(i) == 0
                Rvels = [Rvels mean(data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+109))];
            end
        end
    end
    
    if length(Lvels) > length(Rvels)
        meanvels = [meanvels mean(Lvels)];
        stdvels = [stdvels std(Lvels)];
    else
        meanvels = [meanvels mean(Rvels)];
        stdvels = [stdvels std(Rvels)];
    end
    
end
meanvels
stdvels

if NaturalFirst
    Tmeans = [mean(meanvels(1:2)) mean(meanvels(3:4))    mean(meanvels(5:6))];  %fill in with mean X-axis velocity
    Tsems = [mean(stdvels(1:2)/10) mean(stdvels(5:6)/10)    mean(stdvels(5:6)/10)];
else
    Tmeans = [mean(meanvels(3:4)) mean(meanvels(1:2))    mean(meanvels(5:6))];  %fill in with mean X-axis velocity
    Tsems = [mean(stdvels(3:4)/10) mean(stdvels(1:2)/10)    mean(stdvels(5:6)/10)];    
end
Xax = {'Natural Rotation' 'Unnatural Rotation' 'No Rotation'};
bar(Tmeans, 'FaceColor', [.9 .4 .5]);
hold on;
errorbar(Tmeans, Tsems, 'b.');
box off;
set(gca, 'Xtick', 1:10, 'XTickLabel', Xax); 
set(gcf, 'color', 'w');
title({['Mean Eye Torsion velocity from -50ms stim onset to 50ms: Subj' subject]})
xlabel('Rotation type', 'fontsize', 12);
ylabel('Mean Torsion Velocity (deg/s)', 'fontsize', 12);


