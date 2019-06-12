%%
subject = '16';
blocklist = {'02' '04' '06' '08' '10' '12'};
NaturalFirst = 1;
block1X = [];
block2X = [];
block3X = [];
block1Y = [];
block2Y = [];
block3Y = [];
block1Ons = [];
block2Ons = [];
block3Ons = [];
for block = 1:6

    % read in data and socscalexy
    filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
    filelocation = ['C:\Users\admin\TorsionAnticipation\exp14b\subj' subject];
    data = readDataFile(filename, filelocation);
    data = socscalexy(data);
    
    % get mean velocities for RIGHT eye
    RXvels = [];
    RYvels = [];
    errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
    Ronsets = [];
    [header, logData] = readLogFile(block*2, ['subject' subject 'log.txt'] , filelocation);
    sampleRate = 200;
    for n = 1:10
        for i = n*10-9:n*10
            if errors.errorStatus(i) == 0  && data.startFrames(i) + 429 <= length(data.DT_filt)
                %RXvels = [RXvels; data.DX_filt(data.startFrames(i)+50:data.startFrames(i)+249)'];
                %RYvels = [RYvels; data.DY_filt(data.startFrames(i)+50:data.startFrames(i)+249)'];
                trial = setupTrial(data, header, logData, i);
                currentTrial = i;
                analyzeTrial;
                RXvels = [RXvels; trial.frames.DX_noSac(50:249)'];
                RYvels = [RYvels; trial.frames.DY_noSac(50:249)'];
                Ronsets = [Ronsets; pursuit.onset];
            end
        end
    end


    if block < 3
        block1X = [block1X; RXvels];
    elseif block < 5
        block2X = [block2X; RXvels];
    else
        block3X = [block3X; RXvels];
    end

    
    if block < 3
        block1Y = [block1Y; RYvels];
    elseif block < 5
        block2Y = [block2Y; RYvels];
    else
        block3Y = [block3Y; RYvels];
    end
    
    if block < 3
        block1Ons = [block1Ons; Ronsets];
    elseif block < 5
        block2Ons = [block2Ons; Ronsets];
    else
        block3Ons = [block3Ons; Ronsets];
    end

end

%Swap first 2 blocks with 3rd and 4th blocks if not Natural First
if NaturalFirst
    natVelsX = block1X;
    unnatVelsX = block2X;
    noneVelsX = block3X;
else
    natVelsX = block2X;
    unnatVelsX = block1X;
    noneVelsX = block3X;
end

if NaturalFirst
    natVelsY = block1Y;
    unnatVelsY = block2Y;
    noneVelsY = block3Y;
else
    natVelsY = block2Y;
    unnatVelsY = block1Y;
    noneVelsY = block3Y;
end

if NaturalFirst
    natons = block1Ons;
    unnatons = block2Ons;
    noneons = block3Ons;
else
    natons = block2Ons;
    unnatons = block1Ons;
    noneons = block3Ons;
end



% % X axis - natural rotation
% xNone = [-50:149]';
% yNone = mean(natVelsX)';
% dyNone = std(natVelsX)';  
% h1= fill([xNone;flipud(xNone)],[yNone-dyNone;flipud(yNone+dyNone)],[.5 .5 .9],'linestyle','none');
% set(h1,'facealpha',.2)
% l1 = line(xNone,yNone, 'Color', [.3 .3 .8], 'LineWidth', 2);
% hold on;


% % X axis - unnatural rotation
% xNone = [-50:149]';
% yNone = mean(unnatVelsX)';
% dyNone = std(unnatVelsX)';  
% h1= fill([xNone;flipud(xNone)],[yNone-dyNone;flipud(yNone+dyNone)],[.9 .5 .5],'linestyle','none');
% set(h1,'facealpha',.2)
% l2 = line(xNone,yNone, 'Color', [.8 .3 .3], 'LineWidth', 2);
% hold on;
% 
% 
% X axis - no rotation
xNone = [-50:149]';
yNone = nanmean(noneVelsX)';
dyNone = nanstd(noneVelsX)';  
h1= fill([xNone;flipud(xNone)],[yNone-dyNone;flipud(yNone+dyNone)],[.1 .1 .1],'linestyle','none');
set(h1,'facealpha',.2)
l3 = line(xNone,yNone, 'Color', [0.1 .1 .1], 'LineWidth', 2);
hold on;


% Y axis
xNoneY = [-50:149]';
yNoneY = nanmean(noneVelsY)';
dyNoneY = nanstd(noneVelsY)';  
h1Y= fill([xNoneY;flipud(xNoneY)],[yNoneY-dyNoneY;flipud(yNoneY+dyNoneY)],[.7 .7 .7],'linestyle','none');
set(h1Y,'facealpha',.2)
l3Y = line(xNoneY,yNoneY, 'Color', [.6 .6 .6], 'LineWidth', 2);
hold on;
% 
 box off
 set(gcf,'color','w');
 labels = [-250  0  250  500  750];
 tickStep = (1000/5)/(length(labels)-1);
 set(gca, 'XTick', -50:tickStep:150, 'XTickLabel', labels);
 hold on;
% 
Xstim = [zeros(50,1)' (zeros(150,1)+10)'];
x = [-50:149];
Rstim = plot(x, Xstim, 'Color', [0 0 0], 'linestyle', '--', 'linewidth', 1.3);
hold on;

% % plot([0 0], [30 -30], 'color', [0 0 0], 'linestyle', '--', 'linewidth', 1.2)
 plot([mean(natons)-100 mean(natons)-100], [30 -30], 'linestyle', '--', 'color', [1 .65 0], 'linewidth', 1.2)
 %a1 = area([mean(natons)-100 0], [25 25], -9.9 , 'FaceColor', [1 1 .8], 'EdgeColor', 'none');

%title({['X-axis Pursuit Velocity - Subject ' subject]}, 'FontSize', 12, 'fontweight', 'bold')
xlabel('Time (ms)', 'fontsize', 15, 'fontweight', 'bold')
ylabel('Velocity (deg/s)', 'fontsize', 15, 'fontweight', 'bold')
axis([-50 150 -5 20]);
 legend([ l3 l3Y], { 'Horizontal Velocity', 'Vertical Velocity'}, 'Location','northeast')
set(gca, 'linewidth', 1.3);
set(gca, 'fontweight', 'bold');
set(gca, 'fontsize', 20);

set(gca, 'Ytick', [0:10:20]) 


h=gcf;
set(h,'PaperPositionMode','auto');         
set(h,'PaperOrientation','landscape');
set(h,'Position',[50 50 1200 600]);
%print(gcf, '-dpdf', 'trace.pdf')
