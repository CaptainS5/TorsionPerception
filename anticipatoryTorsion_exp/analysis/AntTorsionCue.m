%% Get mean torsional velocity across all subjects, relative to baseline
%%% FOR EXP 16 - with cue
% Austin Rothwell - July 4 2017 - UPDATED 2/27/2018

subjectlist = { '01' '02' '03' '04'  '06' '07' '08' '09' '10'};
blocklist = {'02' '04' '06' '08' '10' '12'};


torsionAnt = nan(200,3,length(subjectlist));
horizontalAnt = nan(200,3,length(subjectlist));
torsionPursuit = nan(200,3,length(subjectlist));
horizontalPursuit = nan(200,3,length(subjectlist));
numNonError = zeros(length(subjectlist),3);

for subj = 1:length(subjectlist)
    
    % Subject details
    subject = subjectlist{subj};

    counts = [ 0 0 0];
    
    for block = 1:6
        % read in data and socscalexy
        filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
        filelocation = ['C:\Users\admin\TorsionAnticipation\exp16\subj' subject];
        data = readDataFile(filename, filelocation);
        data = socscalexy(data);
        [header, logData] = readLogFile(block*2, ['subject' subject 'log.txt'] , filelocation);
        sampleRate = 200;
        
        
        % get mean velocities for RIGHT eye
        Rvels = [];
        
        antStart = 90;
        antEnd = 109;
        
        pursuitStart = 110;
        pursuitEnd = 449;
        
       
        
        errors = load(['./ErrorFiles/Exp16_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
        
        for t = 1:100
            if errors.errorStatus(t) == 0
                currentTrial = t;
                analyzeTrial;
                if logData.rotationalDirection(t) == 1
                    counts(1) = counts(1)+1;

                    tAntInd = find(isnan(torsionAnt(:,1,subj)), 1, 'first');
                    hAntInd = find(isnan(horizontalAnt(:,1,subj)), 1, 'first');
                    tPurInd = find(isnan(torsionPursuit(:,1,subj)), 1, 'first');
                    hPurInd = find(isnan(horizontalPursuit(:,1,subj)), 1, 'first');

                    torsionAnt(tAntInd,1,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                    horizontalAnt(hAntInd,1,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                    torsionPursuit(tPurInd,1,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd));
                    horizontalPursuit(hPurInd,1,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                elseif logData.rotationalDirection(t) == -1

                    counts(2) = counts(2)+1;

                    tAntInd = find(isnan(torsionAnt(:,2,subj)), 1, 'first');
                    hAntInd = find(isnan(horizontalAnt(:,2,subj)), 1, 'first');
                    tPurInd = find(isnan(torsionPursuit(:,2,subj)), 1, 'first');
                    hPurInd = find(isnan(horizontalPursuit(:,2,subj)), 1, 'first');

                    torsionAnt(tAntInd,2,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                    horizontalAnt(hAntInd,2,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                    torsionPursuit(tPurInd,2,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd));
                    horizontalPursuit(hPurInd,2,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                elseif logData.rotationalDirection(t) == 0
                    counts(3) = counts(3)+1;

                    tAntInd = find(isnan(torsionAnt(:,3,subj)), 1, 'first');
                    hAntInd = find(isnan(horizontalAnt(:,3,subj)), 1, 'first');
                    tPurInd = find(isnan(torsionPursuit(:,3,subj)), 1, 'first');
                    hPurInd = find(isnan(horizontalPursuit(:,3,subj)), 1, 'first');

                    torsionAnt(tAntInd,3,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                    horizontalAnt(hAntInd,3,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                    torsionPursuit(tPurInd,3,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd));
                    horizontalPursuit(hPurInd,3,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                end
            end
        end
    end
    numNonError(subj,:) = counts;
end


%% Calculate means and sds of data
mean(nanmean(torsionAnt),3)
std(nanmean(torsionAnt),[],3)
mean(nanmean(torsionPursuit),3)
std(nanmean(torsionPursuit),[],3)

mean(nanmean(horizontalAnt),3)
mean(nanmean(horizontalPursuit),3)



%% Calculate psychometrics of data for EXP16 with cue
subjectlist = { '01' '02' '03' '04' '06' '07' '08' '09' '10'};
totalNumFaster = [];
totalNumNatFaster = [];
totalNumUnnatFaster = [];
for subj = 1:length(subjectlist)

    numFaster = [0 0 0 0 0]; 
    natFaster = [0 0 0 0 0];
    unnatFaster = [0 0 0 0 0];
    for block = 1:6
        
        % read in log file
        selectedLogFile = ['\subject' subjectlist{subj} 'log.txt'];
        folder = ['D:\admin-austin\TorsionAnticipation\TorsionAnticipation\exp16\subj' subjectlist{subj}];
        [header, logData] = readLogFile(block*2, selectedLogFile, folder);

        % find correct responses
        for trial = 1:length(logData.trial)           
            if logData.rotationalDirection(trial) == 1 || logData.rotationalDirection(trial) == -1
                if (logData.decision(trial) > 0) % && (logData.rotationalDirection(trial) == 1)
                    if logData.randomSpeed(trial) == -8
                        numFaster(1) = numFaster(1)+1;
                    elseif logData.randomSpeed(trial) == -4
                       numFaster(2)=numFaster(2)+1;
                    elseif logData.randomSpeed(trial) == 0
                       numFaster(3)=numFaster(3)+1;
                    elseif logData.randomSpeed(trial) == 4
                       numFaster(4)=numFaster(4)+1;
                    elseif logData.randomSpeed(trial) == 8
                       numFaster(5)=numFaster(5)+1;
                    end
                elseif logData.decision(trial) > 0 && logData.rotationalDirection(trial) == -1
%                     if logData.randomSpeed(trial) == 8
%                         numFaster(1) = numFaster(1)+1;
%                     elseif logData.randomSpeed(trial) == -4
%                        numFaster(2)=numFaster(2)+1;
%                     elseif logData.randomSpeed(trial) == 0
%                        numFaster(3)=numFaster(3)+1;
%                     elseif logData.randomSpeed(trial) == -4
%                        numFaster(4)=numFaster(4)+1;
%                     elseif logData.randomSpeed(trial) == -8
%                        numFaster(5)=numFaster(5)+1;
%                     end
                end
            end
            if logData.rotationalDirection(trial) == 1
                if logData.decision(trial) > 0
                    if logData.randomSpeed(trial) == -8
                        natFaster(1) = natFaster(1)+1;
                    elseif logData.randomSpeed(trial) == -4
                       natFaster(2)=natFaster(2)+1;
                    elseif logData.randomSpeed(trial) == 0
                       natFaster(3)=natFaster(3)+1;
                    elseif logData.randomSpeed(trial) == 4
                       natFaster(4)=natFaster(4)+1;
                    elseif logData.randomSpeed(trial) == 8
                       natFaster(5)=natFaster(5)+1;
                    end
                end
            end
            if logData.rotationalDirection(trial) == -1
                if logData.decision(trial) > 0
                    if logData.randomSpeed(trial) == -8
                        unnatFaster(1) = unnatFaster(1)+1;
                    elseif logData.randomSpeed(trial) == -4
                       unnatFaster(2)=unnatFaster(2)+1;
                    elseif logData.randomSpeed(trial) == 0
                       unnatFaster(3)=unnatFaster(3)+1;
                    elseif logData.randomSpeed(trial) == 4
                       unnatFaster(4)=unnatFaster(4)+1;
                    elseif logData.randomSpeed(trial) == 8
                       unnatFaster(5)=unnatFaster(5)+1;
                    end
                end
            end
        end
    end
    totalNumFaster = [totalNumFaster; numFaster];
    totalNumNatFaster = [totalNumNatFaster; natFaster];
    totalNumUnnatFaster = [totalNumUnnatFaster; unnatFaster];

end

totalCorrect = [100-totalNumFaster(:,1) + 100-totalNumFaster(:,2) + 40 + totalNumFaster(:,4) + totalNumFaster(:,5)];

scores = [[1 2 3 4 6 7 8 9 10]' totalCorrect];

% totalNumCorrect(:,1:2) = 80 - totalNumCorrect(:,1:2);
% totalNumCorrect(:,3) =  totalNumCorrect(:,3) - 40;
% 
% means = totalNumCorrect/80;

totalPropFaster = totalNumFaster ./ 80

totalPropNatFaster = totalNumNatFaster ./ 40;
totalPropUnnatFaster = totalNumUnnatFaster ./ 40;

natural_faster_exp16 = totalPropNatFaster
unnatural_faster_exp16 = totalPropUnnatFaster

%% Get mean torsional velocity across all subjects, relative to baseline
%%% FOR EXP 14 a/b - NO CUE
% Austin Rothwell - 2/27/2018

subjectlist = { '04' '05' '06' '07' '08' '09' '11' '12' '13' '15' '16' '17'};
rotDirList  = [   0    0    1    1    1    0    0   0    1    1    1    1];

% subjectlist = { '12' };
% rotDirList  = [  0 ];

blocklist = {'02' '04' '06' '08' '10' '12'};


torsionAnt = nan(200,3,length(subjectlist));
horizontalAnt = nan(200,3,length(subjectlist));
torsionPursuit = nan(200,3,length(subjectlist));
horizontalPursuit = nan(200,3,length(subjectlist));
numNonError = zeros(length(subjectlist),3);

for subj = 1:length(subjectlist)
    disp(subjectlist(subj))
    % Subject details
    subject = subjectlist{subj};

    counts = [ 0 0 0];
    
    for block = 1:6
        disp(blocklist(block))
        % read in data and socscalexy
        filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
        filelocation = ['C:\Users\admin\TorsionAnticipation\exp14\subj' subject];
        data = readDataFile(filename, filelocation);
        data = socscalexy(data);
        [header, logData] = readLogFile(block*2, ['subject' subject 'log.txt'] , filelocation);
        sampleRate = 200;
           
        % get mean velocities for RIGHT eye        
        antStart = 90;
        antEnd = 109;
        pursuitStart = 110;
        pursuitEnd = 449;
        
        errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
        
        for t = 1:100
            disp(num2str(t))
            if block == 2 || block == 4 || block == 6 
                t_ind = t+100;
            else
                t_ind = t;
            end
            if errors.errorStatus(t) == 0
                currentTrial = t;
                analyzeTrial;
                
                
                
                if (block-1)*100 + t > 400
                    torsionAnt(t_ind,3,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                    horizontalAnt(t_ind,3,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                    torsionPursuit(t_ind,3,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd)); 
                    horizontalPursuit(t_ind,3,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                else
                    if (block-1)*100 + t < 201
                        if rotDirList(subj)
                            torsionAnt(t_ind,1,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                            horizontalAnt(t_ind,1,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                            torsionPursuit(t_ind,1,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd)); 
                            horizontalPursuit(t_ind,1,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                        else
                            torsionAnt(t_ind,2,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                            horizontalAnt(t_ind,2,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                            torsionPursuit(t_ind,2,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd)); 
                            horizontalPursuit(t_ind,2,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                        end
                    else
                        if rotDirList(subj)
                            torsionAnt(t_ind,2,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                            horizontalAnt(t_ind,2,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                            torsionPursuit(t_ind,2,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd)); 
                            horizontalPursuit(t_ind,2,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                        else
                            torsionAnt(t_ind,1,subj) = nanmean(trial.frames.DT_noSac(antStart:antEnd));
                            horizontalAnt(t_ind,1,subj) = nanmean(trial.frames.DX_noSac(antStart:antEnd));

                            torsionPursuit(t_ind,1,subj) = nanmean(trial.frames.DT_noSac(pursuitStart:pursuitEnd)); 
                            horizontalPursuit(t_ind,1,subj) = nanmean(trial.frames.DX_noSac(pursuitStart:pursuitEnd));
                        end
                    end
                end
            else
                torsionAnt(t_ind,1,subj) = nan;
                horizontalAnt(t_ind,1,subj) = nan;

                torsionPursuit(t_ind,1,subj) = nan; 
                horizontalPursuit(t_ind,1,subj) = nan;
            end
        end
    end
end
%     numNonError(subj,:) = counts;


%%
figure(1)
Xax = {'Natural' 'Unnatural' 'None'};
bar([mean(totNatMeans)  mean(totUnnatMeans) mean(totNoMeans)], 'FaceColor', [.9 .4 .5]);
hold on;
errorbar([mean(totNatMeans) mean(totUnnatMeans) mean(totNoMeans)], [mean(totNatSems) mean(totUnnatSems) mean(totNoSems)], 'b.');
box off;
ylim([-1 1]);
set(gca, 'Xtick', 1:10, 'XTickLabel', Xax, 'fontsize', 14); 
set(gcf, 'color', 'w');
title({['Mean Eye Torsion velocity across all subjects RIGHT motion (-50ms to 50ms)']})
xlabel('Rotation type', 'fontsize', 14);
ylabel('Torsion Velocity (deg/s)', 'fontsize', 14);

torsionmeans = zeros(10,6,length(subjectlist));
torsion10trial = zeros(6,30);
for subject = 1:length(subjectlist)
    for block = 1:6
        for trial = 0:9
            vals = torsionvals((trial*10)+1:(trial*10)+10, block, subject);
            torsionmeans(trial+1,block,subject) = nanmean(vals(vals~=0));
        end
    end
end


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


