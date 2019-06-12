%close all;

torsionDataToRight = [];
torsionDataToLeft = [];
positionError = [];
figure();
hold on;
%% read header and setup result files
selectedLogFile = selectedLogFile{1};
[header, ~] = readLogFile(1, selectedLogFile, standardPaths.log); % to get the header information
[results, resultFile] = setupResultFile(header);

%% analyze all selected blocks
for b = 1:length(selectedDataFiles)
    
    
    
    %% executed once per block
    block = str2double(selectedDataFiles{b}(16:17));
    [header, logData] = readLogFile(block, selectedLogFile, standardPaths.log);
    data = readDataFile(selectedDataFiles{b}, standardPaths.data);
    data = socscalexy(data);
    
    try
        %load(fullfile(standardPaths.log,'ErrorFiles',[selectedDataFiles{b}(1:length(selectedDataFiles{b})-4) '_errorFile.mat']));
        load(fullfile(pwd,'ErrorFiles',['Exp' num2str(header.experiment) '_' selectedDataFiles{b}(1:length(selectedDataFiles{b})-4) '_errorFile.mat']));
    catch %#ok<CTCH>
         disp(fullfile(pwd,'ErrorFiles',['Exp' num2str(header.experiment) '_' selectedDataFiles{b}(1:length(selectedDataFiles{b})-4) '_errorFile.mat']));
        fprintf('\n###\nWARNING: No error file definded yet.\nI will analyze the block but be aware that all trials will be considered. Even the bad ones. Even the really bad ones!\n###\n')
        errorStatus = NaN(header.trialsPerBlock,1);
    end
    
    %% executed for each trial
    for currentTrial = 1:header.trialsPerBlock
        if errorStatus(currentTrial) == 0
            analyzeTrial;
            if trial.log.translationalDirection == 0
                %plot(trial.frames.T_filt(40:360),'Color',[0 0 0]+0.7);
                torsionDataToRight= [torsionDataToRight, trial.frames.T_filt(40:360)-trial.frames.T_filt(40)];
            else
                %plot(trial.frames.T_filt(40:360),'Color',[0 0 0]+0.9);
                torsionDataToLeft = [torsionDataToLeft, trial.frames.T_filt(40:360)-trial.frames.T_filt(40)];
            end

            
            results = saveTrialResults(results, trial, torsion, pursuit);
            results = saveSaccades(results, trial);
           %plotMiniResults(trial, torsion, pursuit);
        end
    end
    if trial.log.block < 4
        plot(mean(torsionDataToRight,2),'Color',[b/10 b/10 1],'LineStyle','--');
        plot(mean(torsionDataToLeft,2),'Color',[1 b/10 b/10],'LineStyle','--');
    else
        plot(mean(torsionDataToRight,2),'Color',[b/10 b/10 1]);
        plot(mean(torsionDataToLeft,2),'Color',[1 b/10 b/10]);
    end
    
    
    disp(strcat({'Done with '}, selectedDataFiles{b}, '.'))
end

%% save results
results.trial(isnan(results.trial)) = Inf;
results.trial = unique(results.trial,'rows','stable');
results.trial(results.trial == Inf) = NaN;

results.saccades(isnan(results.saccades)) = Inf;
results.saccades = unique(results.saccades,'rows','stable');
results.saccades(results.saccades == Inf) = NaN;



save(resultFile,'results');

%% close and clear
fclose('all');
clear selectedBlock;
clear block;