%% Get mean torsional velocity across all subjects, relative to baseline
% Austin Rothwell - November 30 2016
% timecourse = zeros(12,3,11);
% rawtimecourse = zeros(100,6,12);
% for time = 1:10:101

    %subjectlist = { '04' '05' '06' '07' '08' '09'};
    %subjectlist = { '11' '12' '13' '15' '16' '17'};
    %rotDirList  = [   0    0    1    1    1    0 ];
    %rotDirList  = [ 0  0  1  1  1  1];

    subjectlist = { '04' '05' '06' '07' '08' '09' '11' '12' '13' '15' '16' '17'};
    rotDirList  = [   0    0    1    1    1    0  0  0  1  1  1  1];

    totNatMeans = [];
    totUnnatMeans = [];
    totNoMeans = [];

    totNatSems = [];
    totUnnatSems = [];
    totNoSems = [];

    torsionvals = nan(100,6,length(subjectlist));

    for subj = 1:length(subjectlist)
        totalLvels = [];
        totalRvels = [];


        % Enter subject details
        subject = subjectlist{subj};
        NaturalFirst = rotDirList(subj);
        blocklist = {'02' '04' '06' '08' '10' '12'};

        % Loop through all blocks and all trials for both eyes - choosing the data
        % from the eye with the most valid trials
        meanLvels = [];
        stdLvels = [];
        nLvels = [];
        meanRvels = [];
        stdRvels = [];
        nRvels = [];
        for block = 1:6


            % read in data and socscalexy
            filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
            filelocation = ['C:\Users\admin\TorsionAnticipation\exp14\subj' subject];
            data = readDataFile(filename, filelocation);
            data = socscalexy(data);
            [header, logData] = readLogFile(block*2, ['subject' subject 'log.txt'] , filelocation);
            sampleRate = 200;

            % get mean velocities for RIGHT eye
            Rvels = [];
            errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
            for n = 1:10
                for i = n*10-9:n*10
                    if errors.errorStatus(i) == 0 && data.startFrames(i) + 429 <= length(data.DT_filt)
                        %Rvels = [Rvels mean(data.DT_filt(data.startFrames(i)+420:data.startFrames(i)+429))];
                        trial = setupTrial(data, header, logData, i);
                        currentTrial = i;
                        analyzeTrial;
                        Rvels = [Rvels nanmean(trial.frames.DT_noSac(110:429))];
                        start = time;
%                         stop = time+9;
                        torsionvals(currentTrial,block,subj) = nanmean(trial.frames.DT_noSac(20:29));
                    end
                end
            end



            totalRvels = [totalRvels Rvels];

            meanRvels = [meanRvels mean(Rvels)];
            stdRvels = [stdRvels std(Rvels)];
            nRvels = [nRvels length(Rvels)];    
        end


            meanvels = meanRvels;
            stdvels = stdRvels;
            nvels = nRvels;

        % Swap first 2 blocks with 3rd and 4th blocks if not Natural First
        if NaturalFirst
            Tmeans = [mean(meanvels(1:2))                     mean(meanvels(3:4))                         mean(meanvels(5:6))];  %fill in with mean X-axis velocity
            Tsems = [mean(stdvels(1:2))/sqrt(sum(nvels(1:2))) mean(stdvels(3:4))/sqrt(sum(nvels(3:4)))    mean(stdvels(5:6))/sqrt(sum(nvels(5:6)))];
        else
            Tmeans = [mean(meanvels(3:4))                     mean(meanvels(1:2))                         mean(meanvels(5:6))];  %fill in with mean X-axis velocity
            Tsems = [mean(stdvels(3:4))/sqrt(sum(nvels(3:4))) mean(stdvels(1:2))/sqrt(sum(nvels(1:2)))    mean(stdvels(5:6))/sqrt(sum(nvels(5:6)))];    
            block12 = torsionvals(:,1:2,subj) ;
            torsionvals(:,1:2,subj) = torsionvals(:,3:4,subj);
            torsionvals(:,3:4,subj) = block12;
        end
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
    
%     timecourse(:,:,subj) = torsionvals;
%     
%     t=squeeze(nanmean(torsionvals))';
%     t = [nanmean(t(:,1:2),2) nanmean(t(:,3:4),2) nanmean(t(:,5:6),2)];
%     timecourse(:,:,ceil(time/10)) = t;
% end

%      t=squeeze(nanmean(torsionvals))';
%      t = [nanmean(t(:,1:2),2) nanmean(t(:,3:4),2) nanmean(t(:,5:6),2)];
%      timecourse(:,:,ceil(time/10)) = t;

% figure(1)
% Xax = {'Natural' 'Unnatural' 'None'};
% bar([mean(totNatMeans)  mean(totUnnatMeans) mean(totNoMeans)], 'FaceColor', [.9 .4 .5]);
% hold on;
% errorbar([mean(totNatMeans) mean(totUnnatMeans) mean(totNoMeans)], [mean(totNatSems) mean(totUnnatSems) mean(totNoSems)], 'b.');
% box off;
% ylim([-1 1]);
% set(gca, 'Xtick', 1:10, 'XTickLabel', Xax, 'fontsize', 14); 
% set(gcf, 'color', 'w');
% title({['Mean Eye Torsion velocity across all subjects RIGHT motion (-50ms to 50ms)']})
% xlabel('Rotation type', 'fontsize', 14);
% ylabel('Torsion Velocity (deg/s)', 'fontsize', 14);
% 
% torsionmeans = zeros(10,6,length(subjectlist));
% torsion10trial = zeros(6,30);
% for subject = 1:length(subjectlist)
%     for block = 1:6
%         for trial = 0:9
%             vals = torsionvals((trial*10)+1:(trial*10)+10, block, subject);
%             torsionmeans(trial+1,block,subject) = nanmean(vals(vals~=0));
%         end
%     end
% end


%%
load('horizontaldata.mat')
load('horizontaldata.mat')

figure
for subject = 1:12
    for i = 1:6
        subplot(3,2,i)
        if subject < 7
            plot(horizontaldata(:,i,subject)', 'linewidth', 3, 'color', 'b')
        else
            plot(horizontaldata(:,i,subject)', 'linewidth', 3, 'color', 'r')

        end
        ylim([-7 7])
        box off;
        hold on;
    end
    hold on;
end
set(gcf, 'color', 'w');


%%
% LEFT MOTION

% subjectlist = { '04' '05' '06' '07' '08' '09'};
subjectlist = { '11' '12' '13' '15' '16' '17'};
% rotDirList  = [   0    0    1    1    1    0 ];
rotDirList  = [ 0  0  1  1  1  1];

totNatMeans = [];
totUnnatMeans = [];
totNoMeans = [];

totNatSems = [];
totUnnatSems = [];
totNoSems = [];

rightlefteye = [0 0];
for subj = 1:length(subjectlist)
    totalLvels = [];
    totalRvels = [];
    % Enter subject details
    subject = subjectlist{subj};
    NaturalFirst = rotDirList(subj);
    blocklist = {'02' '04' '06' '08' '10' '12'};

    % Loop through all blocks and all trials for both eyes - choosing the data
    % from the eye with the most valid trials
    meanLvels = [];
    stdLvels = [];
    nLvels = [];
    meanRvels = [];
    stdRvels = [];
    nRvels = [];
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
                    Lvels = [Lvels mean(data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+109))];
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
                    Rvels = [Rvels mean(data.DT_filt(data.startFrames(i)+90:data.startFrames(i)+109))];
                end
            end
        end


        totalLvels = [totalLvels Lvels];
        totalRvels = [totalRvels Rvels];

        % Choose velocities from eye with most valid trials
        meanLvels = [meanLvels mean(Lvels)];
        stdLvels = [stdLvels std(Lvels)];
        nLvels = [nLvels length(Lvels)];
        
        meanRvels = [meanRvels mean(Rvels)];
        stdRvels = [stdRvels std(Rvels)];
        nRvels = [nRvels length(Rvels)];

    end
    
%       UNCOMMENT THIS TO USE DATA FROM BEST TRACKED EYE
%     if length(totalLvels) > length(totalRvels)
%         rightlefteye = rightlefteye + [0 1];
%         meanvels = meanLvels;
%         stdvels = stdLvels;
%         nvels = nLvels;
%     else
%         rightlefteye = rightlefteye + [1 0];
%         meanvels = meanRvels;
%         stdvels = stdRvels;
%         nvels = nRvels;
%     end

        meanvels = meanRvels;
        stdvels = stdRvels;
        nvels = nRvels;

    % Swap first 2 blocks with 3rd and 4th blocks if not Natural First
    if NaturalFirst
        Tmeans = [mean(meanvels(1:2))                     mean(meanvels(3:4))                         mean(meanvels(5:6))];  %fill in with mean X-axis velocity
        Tsems = [mean(stdvels(1:2))/sqrt(sum(nvels(1:2))) mean(stdvels(3:4))/sqrt(sum(nvels(3:4)))    mean(stdvels(5:6))/sqrt(sum(nvels(5:6)))];
    else
        Tmeans = [mean(meanvels(3:4))                     mean(meanvels(1:2))                         mean(meanvels(5:6))];  %fill in with mean X-axis velocity
        Tsems = [mean(stdvels(3:4))/sqrt(sum(nvels(3:4))) mean(stdvels(1:2))/sqrt(sum(nvels(1:2)))    mean(stdvels(5:6))/sqrt(sum(nvels(5:6)))];    
    end
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
    
figure(2)
Xax = {'Natural' 'Unnatural' 'None'};
bar([mean(totNatMeans)  mean(totUnnatMeans) mean(totNoMeans)], 'FaceColor', [.9 .4 .5]);
hold on;
errorbar([mean(totNatMeans) mean(totUnnatMeans) mean(totNoMeans)], [mean(totNatSems) mean(totUnnatSems) mean(totNoSems)], 'b.');
box off;
ylim([-1 1]);
set(gca, 'Xtick', 1:10, 'XTickLabel', Xax, 'fontsize', 14); 
set(gcf, 'color', 'w');
title({['Mean Eye Torsion velocity across all subjects LEFT motion (-50ms to 50ms)']})
xlabel('Rotation type', 'fontsize', 14);
ylabel('Torsion Velocity (deg/s)', 'fontsize', 14);


