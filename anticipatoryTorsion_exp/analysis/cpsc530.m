%% Get mean torsional velocity across all subjects, relative to baseline
% Austin Rothwell - April 14 2016
% RIGHT MOTION

totalLvels = [];
totalRvels = [];


% Enter subject details
subject = '05';
NaturalFirst = 0;
blocklist = {'02' '04' '06' '08' '10' '12'};

% Loop through all blocks and all trials for both eyes - choosing the data
% from the eye with the most valid trials
meanLvels = [];
stdLvels = [];
nLvels = [];
meanRvels = [];
stdRvels = [];
nRvels = [];

block1 = [];
block2 = [];
block3 = [];
for block = 1:6


    % read in data and socscalexy
    filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
    filelocation = ['C:\Users\admin\TorsionAnticipation\subj' subject];
    data = readDataFile(filename, filelocation);
    data = socscalexy(data);

    % get mean velocities for RIGHT eye
    Rvels = [];
    vels = [];
    errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
    for n = 1:10
        for i = n*10-9:n*10
            if errors.errorStatus(i) == 0
                Rvels = [Rvels mean(data.DDX_filt(data.startFrames(i)+50:data.startFrames(i)+299))];
                vels = [vels; data.DDX_filt(data.startFrames(i)+50:data.startFrames(i)+299)'];                
            end
        end
    end
    totalRvels = [totalRvels Rvels];

    meanRvels = [meanRvels mean(Rvels)];
    stdRvels = [stdRvels std(Rvels)];
    nRvels = [nRvels length(Rvels)];
    
    if block == 1
        block1 = vels;
    elseif block == 2
        block2 = vels;
    else
        block3 = vels;
    end
            
end


meanvels = meanRvels;
meanvels = [meanvels(2) meanvels(1) meanvels(3)];
stdvels = stdRvels;
stdvels = [stdvels(2) stdvels(1) stdvels(3)];
nvels = nRvels;
nvels = [nvels(2) nvels(1) nvels(3)];



%%
% 
%     Make torsional velocity relative to baseline (no rotation) torsion
% Plot standard trials average velocity with fill
% xNat = [-50:199]';
% yNat = mean(block1)';
% dyNat = std(block1)';  
% h1= fill([xNat;flipud(xNat)],[yNat-dyNat;flipud(yNat+dyNat)],[.9 .4 .9],'linestyle','none');
% set(h1,'facealpha',.2)
% l1 = line(xNat,yNat, 'Color', [.8 .1 .8], 'LineWidth', 2);
% hold on;
% 
% xUnnat = [-50:199]';
% yUnnat = mean(block2)';
% dyUnnat = std(block2)'; 
% l2 = line(xUnnat,yUnnat, 'Color', [0 .6 .0], 'LineWidth', 2);
% h2= fill([xUnnat;flipud(xUnnat)],[yUnnat-dyUnnat;flipud(yUnnat+dyUnnat)],[0 .8 .0],'linestyle','none');
% set(h2,'facealpha',.2)
% hold on;

xNone = [-50:199]';
yNone = mean(block3)';
dyNone = std(block3)';  
l3 = line(xNone,yNone, 'Color', [0 .2 .9], 'LineWidth', 2);
hold on
h3= fill([xNone;flipud(xNone)],[yNone-dyNone;flipud(yNone+dyNone)],[0 .5 .9],'linestyle','none');
set(h3,'facealpha',.2)
hold on;

box off
set(gcf,'color','w');
labels = [-250 -200 -150 -100 -50 0 50 100 150 200 250 300 350 400 450 500 550 600 650 700 750];
tickStep = (1000/5)/(length(labels)-1);
set(gca, 'XTick', -50:tickStep:200, 'XTickLabel', labels);
hold on;

a1 = area([-49 10], [5 5], -24.9 , 'FaceColor', [1 1 .9], 'EdgeColor', 'none');
a2 = area([10 199], [5 5], -24.9, 'FaceColor', [.9 1 1], 'EdgeColor', 'none');
%

Xstim = [zeros(50,1)' (zeros(150,1)-10)'];
x = [-50:149];
Rstim = plot(x, Xstim, 'Color', [0 0 0], 'linestyle', '--', 'linewidth', 1.3);
hold on;

%title({['X-axis Pursuit Velocity - Subject ' subject]}, 'FontSize', 12, 'fontweight', 'bold')
xlabel('Time (ms)', 'fontsize', 12, 'fontweight', 'bold')
ylabel('Mean Velocity in X-axis (deg/s)', 'fontsize', 12, 'fontweight', 'bold')
axis([-50 150 -25 5]);
legend([l1 l2 l3 Rstim], {'Natural', 'Unnatural', 'No Rotation', 'Stimulus'}, 'Location','northeast')
set(gca, 'linewidth', 1.3);
set(gca, 'fontweight', 'bold');


