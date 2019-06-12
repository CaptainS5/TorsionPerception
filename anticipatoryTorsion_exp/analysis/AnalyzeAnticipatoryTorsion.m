%% Get mean torsional velocity across trials and blocks and plot
% Austin Rothwell - November 20 2016

% Enter subject details
subject = '12';
NaturalFirst = 0;
blocklist = {'02' '04' '06' '08' '10' '12'};

totNatMeans = [];
totUnnatMeans = [];
totNoMeans = [];

totNatSems = [];
totUnnatSems = [];
totNoSems = [];

% Loop through all blocks and all trials for both eyes - choosing the data
% from the eye with the most valid trials
meanvels = [];
stdvels = [];
nvels = [];
for block = 1:6

    % read in data and socscalexy
    filename = ['Subject' subject '_Block' blocklist{block} '_L.dat'];
    filelocation = ['C:\Users\admin\TorsionAnticipation\subj' subject];
    data = readDataFile(filename, filelocation);
    data = socscalexy(data);

    % get mean velocities for LEFT eye
    Lvels = [];
    errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_L_errorFile.mat']);
    for n = 1:10
        for i = n*10-9:n*10
            if errors.errorStatus(i) == 0
                Lvels = [Lvels mean(data.DT_filt(data.startFrames(i)+40:data.startFrames(i)+49))];
            end
        end
    end

    % read in data and socscalexy
    filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
    filelocation = ['C:\Users\admin\TorsionAnticipation\subj' subject];
    data = readDataFile(filename, filelocation);
    data = socscalexy(data);

    % get mean velocities for RIGHT eye
    Rvels = [];
    errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
    for n = 1:10
        for i = n*10-9:n*10
            if errors.errorStatus(i) == 0
                Rvels = [Rvels mean(data.DT_filt(data.startFrames(i)+40:data.startFrames(i)+49))];
            end
        end
    end

    % Choose velocities from eye with most valid trials
    if length(Lvels) > length(Rvels)
        meanvels = [meanvels mean(Lvels)];
        stdvels = [stdvels std(Lvels)];
        nvels = [nvels length(Lvels)];
    else
        meanvels = [meanvels mean(Rvels)];
        stdvels = [stdvels std(Rvels)];
        nvels = [nvels length(Rvels)];
    end

end

% Swap first 2 blocks with 3rd and 4th blocks if not Natural First
if NaturalFirst
    Tmeans = [mean(meanvels(1:2))                     mean(meanvels(3:4))                         mean(meanvels(5:6))];  %fill in with mean X-axis velocity
    Tsems = [mean(stdvels(1:2))/sqrt(sum(nvels(1:2))) mean(stdvels(3:4))/sqrt(sum(nvels(3:4)))    mean(stdvels(5:6))/sqrt(sum(nvels(5:6)))];
else
    Tmeans = [mean(meanvels(3:4))                     mean(meanvels(1:2))                         mean(meanvels(5:6))];  %fill in with mean X-axis velocity
    Tsems = [mean(stdvels(3:4))/sqrt(sum(nvels(3:4))) mean(stdvels(1:2))/sqrt(sum(nvels(1:2)))    mean(stdvels(5:6))/sqrt(sum(nvels(5:6)))];    
end
nvels
%     % Make torsional velocity relative to baseline (no rotation) torsion
%     natT = Tmeans(1) - Tmeans(3);
%     unnatT = Tmeans(2) - Tmeans(3);
%     
% Add torsional velocities and SEMs to each accumulator
totNatMeans = [totNatMeans Tmeans(1)];
totUnnatMeans = [totUnnatMeans Tmeans(2)];
totNoMeans = [totNoMeans Tmeans(3)];

totNatSems = [totNatSems Tsems(1)];
totUnnatSems = [totUnnatSems Tsems(2)];
totNoSems = [totNoSems Tsems(3)];

%     totNatMeans = [totNatMeans Tmeans(1)];
%     totUnnatMeans = [totUnnatMeans Tmeans(2)];
%     totNoMeans = [totNatSems Tmeans(3)];
% plot means

Xax = {'Natural Rotation' 'Unnatural Rotation' 'No Rotation'};
bar(Tmeans, 'FaceColor', [.9 .4 .5]);
hold on;
errorbar(Tmeans, Tsems, 'b.');
box off;
set(gca, 'Xtick', 1:10, 'XTickLabel', Xax,'fontsize',14); 
set(gcf, 'color', 'w');
title({['Mean Eye Torsion velocity from -50ms to 50ms: Subj' subject]}, 'fontsize',14)
xlabel('Rotation type', 'fontsize', 12);
ylabel('Mean Torsion Velocity (deg/s)', 'fontsize', 12);


%% Get mean horizontal velocity across trials and blocks and plot

% Enter subject details
subject = '07';
NaturalFirst = 1;
blocklist = {'02' '04' '06' '08' '10' '12'};

% Loop through all blocks and all trials for both eyes - choosing the data
% from the eye with the most valid trials
meanvels = [];
stdvels = [];
for block = 1:6
   
    % read in data and socscalexy
    filename = ['Subject' subject '_Block' blocklist{block} '_L.dat'];
    filelocation = ['C:\Users\admin\TorsionAnticipation\subj' subject];
    data = readDataFile4  (filename, filelocation);
    data = socscalexy(data);
    
    % get mean velocities for LEFT eye
    Lvels = [];
    errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_L_errorFile.mat']);
    for n = 1:10
        for i = n*10-9:n*10
            if errors.errorStatus(i) == 0
                Lvels = [Lvels mean(data.DX_filt(data.startFrames(i)+90:data.startFrames(i)+109))];
            end
        end
    end
    
    % get mean velocities for RIGHT eye
    Rvels = [];
    errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
    for n = 1:10
        for i = n*10-9:n*10
            if errors.errorStatus(i) == 0
                Rvels = [Rvels mean(data.DX_filt(data.startFrames(i)+90:data.startFrames(i)+109))];
            end
        end
    end
    
    % Choose velocities from eye with most valid trials
    if length(Lvels) > length(Rvels)
        meanvels = [meanvels mean(Lvels)];
        stdvels = [stdvels std(Lvels)];
    else
        meanvels = [meanvels mean(Rvels)];
        stdvels = [stdvels std(Rvels)];
    end
    
end

% Swap first 2 blocks with 3rd and 4th blocks if not Natural First
if NaturalFirst
    Tmeans = [mean(meanvels(1:2)) mean(meanvels(3:4))    mean(meanvels(5:6))];  %fill in with mean X-axis velocity
    Tsems = [mean(stdvels(1:2)/10) mean(stdvels(5:6)/10)    mean(stdvels(5:6)/10)];
else
    Tmeans = [mean(meanvels(3:4)) mean(meanvels(1:2))    mean(meanvels(5:6))];  %fill in with mean X-axis velocity
    Tsems = [mean(stdvels(3:4)/10) mean(stdvels(1:2)/10)    mean(stdvels(5:6)/10)];    
end

% plot means
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