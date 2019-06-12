%% Get mean torsional velocity across all subjects, relative to baseline
% Austin Rothwell - November 30 2016

%subjectlist = { '04' '05' '06' '07' '08' '09'};
subjectlist = { '11' '12' '13' '15' '16' '17'};
%rotDirList  = [   0    0    1    1    1    0 ];
rotDirList  = [   0    0    1   1   1 1];

totNatMeans = [];
totUnnatMeans = [];
totNoMeans = [];

totNatSems = [];
totUnnatSems = [];
totNoSems = [];

for subj = 1:length(subjectlist)
    
    % Enter subject details
    subject = subjectlist{subj};
    NaturalFirst = rotDirList(subj);
    blocklist = {'02' '04' '06' '08' '10' '12'};

    % Loop through all blocks and all trials for both eyes - choosing the data
    % from the eye with the most valid trials
    meanvels = [];
    stdvels = [];
    nvels = [];
    for block = 1:6
        
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
                    Rvels = [Rvels mean(data.DX_filt(data.startFrames(i)+90:data.startFrames(i)+109))];
                end
            end
        end


            meanvels = [meanvels mean(Rvels)];
            stdvels = [stdvels std(Rvels)];
            nvels = [nvels length(Rvels)];

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
    
end
    

Xax = {'Natural' 'Unnatural' 'None'};
bar([mean(totNatMeans)  mean(totUnnatMeans) mean(totNoMeans)], 'FaceColor', [.9 .4 .5]);
hold on;
errorbar([mean(totNatMeans) mean(totUnnatMeans) mean(totNoMeans)], [mean(totNatSems) mean(totUnnatSems) mean(totNoSems)], 'b.');
box off;
ylim([-4 0]);
set(gca, 'Xtick', 1:10, 'XTickLabel', Xax, 'fontsize', 14); 
set(gcf, 'color', 'w');
title({['Mean Eye horizontal velocity across all LEFT subjects (-300ms to -250ms)']})
xlabel('Rotation type', 'fontsize', 14);
ylabel('Horizontal Velocity (deg/s)', 'fontsize', 14);
hold on;

% testing bar plots
% xVect = [0.85 1.85 2.85 1.15 2.15 3.15]';
% for j=1:length(Rvels)
%     x = repmat(xVect(j),1,length(Rvels)); %the x axis location
%     x = x+(rand(size(x))-0.5)*0.05; %add a little random "jitter" to aid visibility
% 
%     plot(x,Rvels(:,j),'.k', 'MarkerSize', 10)
% end


