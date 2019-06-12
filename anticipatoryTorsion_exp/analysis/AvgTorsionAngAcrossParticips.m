%% Get mean torsional velocity across all subjects, relative to baseline
% Austin Rothwell - November 30 2016

subjectlist = { '04' '05' '06' '07' '08' '09'};
rotDirList  = [   0    0    1    1    1    0 ];

% set up accumulators
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
    meanAng = [];
    stdAng = [];
    nvels = [];
    Tmeans = [];
    Tsems = [];
    for block = 1:6

        % read in LEFT eye data and socscalexy
        filename = ['Subject' subject '_Block' blocklist{block} '_L.dat'];
        filelocation = ['C:\Users\admin\TorsionAnticipation\subj' subject];
        data = readDataFile(filename, filelocation);
        data = socscalexy(data);
        
        % read in log file
        sampleRate = 200;
        selectedLogFile = ['\subject' subject 'log.txt'];
        folder = ['C:\Users\admin\TorsionAnticipation\subj' subject];
        [header, logData] = readLogFile(block*2, selectedLogFile, folder);

        
        % load LEFT errors
        Lvels = [];
        errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_L_errorFile.mat']);

        
        
        % loop through trials
        for n = 1:10
            for i = n*10-9:n*10
                if errors.errorStatus(i) == 0
                    % setup trial
                    trial = setupTrial(data, header, logData, i);
                    % find saccades                    
                    [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, trial.stimulusMeanVelocity);
                    [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                    [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DT_filt, trial.frames.DDT_filt, 10, 0);

                    % analyze saccades
                    [trial] = analyzeSaccades(trial, saccades);
                    clear saccades;
                    pursuit = socchange(trial);
                    % remove saccades
                    trial = removeSaccades(trial);
                    % analyze pursuit
                    pursuit = analyzePursuit(trial, pursuit);
                    % analyze torsion
                    [torsion, trial] = analyzeTorsion(trial, pursuit);
                    
                    Lvels = [Lvels mean(torsion.slowPhases.anticipationAngle)];
                end
            end
        end

        
        % read in RIGHT eye data and socscalexy
        filename = ['Subject' subject '_Block' blocklist{block} '_R.dat'];
        filelocation = ['C:\Users\admin\TorsionAnticipation\subj' subject];
        data = readDataFile(filename, filelocation);
        data = socscalexy(data);
        
        % load RIGHT errors
        Rvels = [];
        errors = load(['./ErrorFiles/Exp14_Subject' subject '_Block' blocklist{block} '_R_errorFile.mat']);
        
        % loop through trials
        for n = 1:10
            for i = n*10-9:n*10
                if errors.errorStatus(i) == 0
                    % setup trial
                    trial = setupTrial(data, header, logData, i);
                    % find saccades                    
                    [saccades.X.onsets, saccades.X.offsets, saccades.X.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DX_filt, trial.frames.DDX_filt, 20, trial.stimulusMeanVelocity);
                    [saccades.Y.onsets, saccades.Y.offsets, saccades.Y.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DY_filt, trial.frames.DDY_filt, 20, 0);
                    [saccades.T.onsets, saccades.T.offsets, saccades.T.isMax] = findSaccades(trial.stim_onset, trial.stim_offset, trial.frames.DT_filt, trial.frames.DDT_filt, 10, 0);

                    % analyze saccades
                    [trial] = analyzeSaccades(trial, saccades);
                    clear saccades;
                    pursuit = socchange(trial);
                    % remove saccades
                    trial = removeSaccades(trial);
                    % analyze pursuit
                    pursuit = analyzePursuit(trial, pursuit);
                    % analyze torsion
                    [torsion, trial] = analyzeTorsion(trial, pursuit);
                    
                    Rvels = [Rvels mean(torsion.slowPhases.anticipationAngle)];
                end
            end
        end

        % Choose velocities from eye with most valid trials
        if length(Lvels) > length(Rvels)
            meanAng = [meanAng mean(Lvels)];
            stdAng = [stdAng std(Lvels)];
            nvels = [nvels length(Lvels)];
        else
            meanAng = [meanAng mean(Rvels)];
            stdAng = [stdAng std(Rvels)];
            nvels = [nvels length(Rvels)];
        end

    end

    %Swap first 2 blocks with 3rd and 4th blocks if not Natural First
    if NaturalFirst
        Tmeans = [mean(meanAng(1:2))                     mean(meanAng(3:4))                         mean(meanAng(5:6))];  %fill in with mean X-axis velocity
        Tsems = [mean(stdAng(1:2))/sqrt(sum(nvels(1:2))) mean(stdAng(3:4))/sqrt(sum(nvels(3:4)))    mean(stdAng(5:6))/sqrt(sum(nvels(5:6)))];
    else
        Tmeans = [mean(meanAng(3:4))                     mean(meanAng(1:2))                         mean(meanAng(5:6))];  %fill in with mean X-axis velocity
        Tsems = [mean(stdAng(3:4))/sqrt(sum(nvels(3:4))) mean(stdAng(1:2))/sqrt(sum(nvels(1:2)))    mean(stdAng(5:6))/sqrt(sum(nvels(5:6)))];    
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
    
end


patsales = [[4 5 6 7 8 9]' totNatMeans' totUnnatMeans' totNoMeans']

% plot the data
Xax = {'Natural' 'Unnatural' 'None'};
bar([mean(totNatMeans)  mean(totUnnatMeans) mean(totNoMeans)], 'FaceColor', [.9 .4 .5]);
hold on;
errorbar([mean(totNatMeans) mean(totUnnatMeans) mean(totNoMeans)], [mean(totNatSems) mean(totUnnatSems) mean(totNoSems)], 'b.');
box off;
set(gca, 'Xtick', 1:10, 'XTickLabel', Xax, 'fontsize', 14); 
set(gcf, 'color', 'w');
title({['Mean Eye Torsional angle across all subjects (-50ms to 50ms)']})
xlabel('Rotation type', 'fontsize', 14);
ylabel('Torsion Angle (deg)', 'fontsize', 14);


