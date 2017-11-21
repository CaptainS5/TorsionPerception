% function getPSE
% Calculate psychometric function for each flash onset, including
% experiment and baseline data
% Then save the data, and draw the plots

% 11/01/2017, Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc
folder = pwd;

% basic setting
names = {'XWp1'};
merged = 1; % whether initial direction is merged; 1=merged
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
loadData = 0; % whether get new fitting or using existing fitting
howMany = -12;% include the first howMany trials for each condition*each initialDirection
% using for pilot to see how many trials we need... the file name
% would be 2*howMany as the total number of trials per condition (direction merged)
% if not using this, set howMany to a negative number such as -1
trialPerCon = 24; % trials per condition in the experiment
threshold = 0.5; % for PSE
fontSize = 15; % for plot

% for fitting using Palamedes
PF = @PAL_Logistic;  %Alternatives: PAL_Gumbel, PAL_Weibull,
%PAL_Quick, PAL_logQuick,
%PAL_CumulativeNormal, PAL_HyperbolicSecant
%Threshold and Slope are free parameters, guess and lapse rate are fixed
paramsFree = [1 1 0 1];  %1: free parameter, 0: fixed parameter
%Parameter grid defining parameter space through which to perform a
%brute-force search for values to be used as initial guesses in iterative
%parameter search.
searchGrid.alpha = -3.5:0.01:1; % threshold
searchGrid.beta = -20:0.1:0; % slope
searchGrid.gamma = 0;  % lower asymptote, guess rate, for 2AFC it's 0.5?...
searchGrid.lambda = 0:0.01:0.1;  % upper asymptote (1-lambda), lapse rate, the probability of an incorrect response...

if merged==1
    conditionNames = {'flashOnset', 'flashDisplaceLeftMerged'}; % which conditions are different
    conditionNamesBase = {'flashOnset', 'flashDisplaceLeft'}; % which conditions are different
    mergeName = 'merged';
else
    conditionNames = {'flashOnset', 'flashDisplaceLeft', 'initialDirection'}; % which conditions are different
    conditionNamesBase = conditionNames;
    mergeName = 'notMerged';
end

% % load raw data collapsed
% cd ..
% load(['dataRaw_all', num2str(size(names, 2))])
% load(['dataRawBase_all', num2str(size(names, 2))])
% % back into the folder
% cd(folder)

dataPMFall = table(); % experiment
dataPMFbaseAll = table(); % baseline
for ii = 1:size(names, 2)
    % load raw data for each participant
    cd ..
    if howMany>0
        load(['dataRaw', num2str(2*howMany), '_', names{ii}])
    else
        load(['dataRaw_', names{ii}])        
    end
    load(['dataRawBase_', names{ii}])
    % back into the folder
    cd(folder)
    
    if loadData==0
        % initialize data points for the psychometric function
        dataPMF = table(); % experiment
        dataPMFbase = table(); % baseline
    else
        if howMany>0
            load(['dataPMFbase', num2str(2*howMany), '_', names{ii}]) % baseline
            load(['dataPMF', mergeName, num2str(2*howMany), '_', names{ii}]) % experiment
        else
            load(['dataPMFbase_', names{ii}]) % baseline
            load(['dataPMF', mergeName, '_', names{ii}]) % experiment
        end
    end
    
    %     % locate data for each individual
    %     idx = find(strcmp(dataRawAll.sub, names{ii}));
    %     dataRaw = dataRawAll(idx,:); % experiment
    %     idx = find(strcmp(dataRawBaseAll.sub, names{ii}));
    %     dataRawBase = dataRawBaseAll(idx,:); % baseline
    % get the levels of each condition
    for jj = 1:size(conditionNames, 2)
        eval(['cons{jj} = unique(roundn(dataRaw.', conditionNames{jj}, ', roundN));']) % experiment
        eval(['consBase{jj} = unique(roundn(dataRawBase.', conditionNamesBase{jj}, ', roundN));']) % baseline
    end
    xFit = min(unique(dataRaw.flashDisplaceLeft)):0.01:max(unique(dataRaw.flashDisplaceLeft));
    xFitBase = min(unique(dataRawBase.flashDisplaceLeft)):0.01:max(unique(dataRawBase.flashDisplaceLeft));
    
    %% Experiment data, flash onset is important
    tempI = 1; % index to add into the table of dataPMF
    
    onsetIdx = find(strcmp(conditionNames, 'flashOnset'));
    for jj = 1:length(cons{onsetIdx}) % each flash onset interval
        if loadData==0
            idx = find(roundn(dataRaw.flashOnset, roundN)==cons{onsetIdx}(jj));
            dataOnset = dataRaw(idx, :); % data of this flash onset
            
            comb = cons{2};
            nextConIdx = 3;
            while nextConIdx<=size(conditionNames, 2)
                comb = genCombinations(comb, cons{nextConIdx});
                nextConIdx = nextConIdx+1;
            end
            
            for tt = 1:size(comb, 1)
                dataPMF.sub(tempI, 1) = names(ii);
                dataPMF.flashOnset(tempI, 1) = cons{onsetIdx}(jj);
                idxAll = 1:size(dataOnset, 1);
                for aa = 1:size(comb, 2)
                    eval(['dataPMF.', conditionNames{aa+1}, '(tempI, 1) = ', num2str(comb(tt, aa)), ';'])
                    eval(['idx = find(roundn(dataOnset.', conditionNames{aa+1}, ', roundN)==', num2str(comb(tt, aa)), ');'])
                    idxAll = intersect(idxAll, idx);
                end
                if merged==1
                    idx = find(dataOnset.perceivedLowerMerged(idxAll)==1);
                else
                    idx = find(dataOnset.perceivedLowerNotMerged(idxAll)==1);
                end
                dataPMF.percentLeftLower(tempI, 1) = length(idx)/length(idxAll);
                dataPMF.totalTrials(tempI,1) = length(idxAll);
                
                tempI = tempI+1;
            end
        end
        % draw plots
        if merged==1
            figure
            box off
            % draw plots for each flash onset, initial direction merged
            idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj));
            dataPlot = dataPMF(idx, :);
            if loadData==0
            [fitObj{jj} LL{jj} exitflag{jj}] = PAL_PFML_Fit(dataPlot.flashDisplaceLeftMerged, ...
                dataPlot.totalTrials.*dataPlot.percentLeftLower, dataPlot.totalTrials, searchGrid, paramsFree, PF);
            end
            scatter(dataPlot.flashDisplaceLeftMerged, dataPlot.percentLeftLower, 'filled');
            hold on
            % fitted line
            yFit = PAL_Logistic(fitObj{jj}, xFit);
            plot(xFit, yFit, '-k')
            % get the PSE
            PSE(jj) = PAL_Logistic(fitObj{jj}, threshold, 'Inverse');
           
            ylim([0, 1])
            xlabel('Flash Displacement (left-right, dva)')
            ylabel('Percentage of of perceived left to be lower')
            set(gca, 'FontSize', fontSize)
            if howMany>0
                title(['onset ', num2str(cons{onsetIdx}(jj)), ' s, ', num2str(2*howMany), ' trials'])
            else
                title(['onset ', num2str(cons{onsetIdx}(jj)), ' s, ', num2str(trialPerCon), ' trials'])
            end
        else
            % draw plots for each flash onset, initial direction not merged
            figure
            box off
            subplot(1, 2, 1) % initial clockwise
            idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj) & dataPMF.initialDirection==1);
            dataPlot = dataPMF(idx, :);
            if loadData==0
            [fitObj{jj, 1} LL{jj, 1} exitflag{jj, 1}] = PAL_PFML_Fit(dataPlot.flashDisplaceLeft, ...
                dataPlot.totalTrials.*dataPlot.percentLeftLower, dataPlot.totalTrials, searchGrid, paramsFree, PF);
            end
            % raw data
            scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
            hold on
            % fitted line
            yFit = PAL_Logistic(fitObj{jj, 1}, xFit);
            plot(xFit, yFit, '-k')
            % get the PSE
            PSE(jj, 1) = PAL_Logistic(fitObj{jj, 1}, threshold, 'Inverse');
           
            ylim([0, 1])
            xlabel('Flash Displacement (left-right, dva)')
            ylabel('Percentage of perceived left to be lower')
            title([num2str(cons{onsetIdx}(jj)), 's clockwise'])
            set(gca, 'FontSize', fontSize)
            
            subplot(1, 2, 2) % initial counterclockwise
            idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj) & dataPMF.initialDirection==-1);
            dataPlot = dataPMF(idx, :);
            if loadData==0
            [fitObj{jj, 2} LL{jj, 2} exitflag{jj, 2}] = PAL_PFML_Fit(dataPlot.flashDisplaceLeft, ...
                dataPlot.totalTrials.*dataPlot.percentLeftLower, dataPlot.totalTrials, searchGrid, paramsFree, PF);
            end
            % raw data
            scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
            hold on
            % fitted line
            yFit = PAL_Logistic(fitObj{jj, 2}, xFit);
            plot(xFit, yFit, '-k')
            
            % get the PSE
            PSE(jj, 2) = PAL_Logistic(fitObj{jj, 2}, threshold, 'Inverse');
            
            ylim([0, 1])
            xlabel('Flash Displacement (left-right, dva)')
            ylabel('Percentage of perceived left to be lower')
            set(gca, 'FontSize', fontSize)
            title([num2str(cons{onsetIdx}(jj)), 's counterclockwise'])
        end
 
        saveas(gca, [names{ii}, '_', mergeName, '_onset', num2str(cons{onsetIdx}(jj)), '_fit.pdf'])
    end
    
    %% Baseline data, flash onset was not important and merged
    if loadData==0
        tempI = 1; % index to add into the table of dataPMFbase
        
        comb = consBase{2};
        for tt = 1:size(comb, 1)
            dataPMFbase.sub(tempI, 1) = names(ii);
            idxAll = 1:size(dataRawBase, 1);
            for aa = 1:size(comb, 2)
                eval(['dataPMFbase.', conditionNamesBase{aa+1}, '(tempI, 1) = ', num2str(comb(tt, aa)), ';'])
                eval(['idx = find(roundn(dataRawBase.', conditionNamesBase{aa+1}, ', roundN)==', num2str(comb(tt, aa)), ');'])
                idxAll = intersect(idxAll, idx);
            end
            idx = find(dataRawBase.perceivedLower(idxAll)==1);
            dataPMFbase.percentLeftLower(tempI, 1) = length(idx)/length(idxAll);
            dataPMFbase.totalTrials(tempI, 1) = length(idxAll);
            
            tempI = tempI+1;
        end
    end
    
    % draw plots for baseline, initial direction merged
    figure
    box off
    dataPlot = dataPMFbase;
    if loadData==0
    [fitObjBase LLBase exitflagBase] = PAL_PFML_Fit(dataPlot.flashDisplaceLeft, ...
        dataPlot.totalTrials.*dataPlot.percentLeftLower, dataPlot.totalTrials, searchGrid, paramsFree, PF);
    end
    % raw data
    scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
    hold on
    % fitted line
    yFitBase = PAL_Logistic(fitObjBase, xFitBase);
    plot(xFitBase, yFitBase, '-k')
    % get the PSE
    PSEbase = PAL_Logistic(fitObjBase, threshold, 'Inverse');
    
    ylim([0, 1])
    xlabel('Flash Displacement (left-right, dva)')
    ylabel('Percentage of perceived left to be lower')
    if howMany>0
        title(['PSE=', num2str(PSEbase(1)), ', ', num2str(2*howMany),' trials'])
    else
        title(['PSE=', num2str(PSEbase(1))])
    end
    
    saveas(gca, [names{ii}, '_baseline_fit.pdf'])
    
    %% Plot for the fitted PSE of the experiment
    figure
    box off
    if merged==1
        plot(cons{onsetIdx}, PSE(:), '-r')
        hold on
        plot(cons{onsetIdx}, repmat(PSEbase, size(cons{onsetIdx})), '--k')
        legend({'Clockwise (merged)', 'baseline'}, 'box', 'off', 'Location', 'northwest')
    else
        plot(cons{onsetIdx}, PSE(:, 1), '-b')
        hold on
        plot(cons{onsetIdx}, PSE(:, 2), '-r')
        plot(cons{onsetIdx}, repmat(PSEbase, size(cons{onsetIdx})), '--k')
        legend({'Clockwise', 'Counterclockwise', 'baseline'}, 'box', 'off', 'Location', 'northwest')
    end
    ylim([-0.5 0.3])
    xlabel('Flash Onset (s)')
    ylabel('Point of subjective equality, left-right')
    set(gca, 'FontSize', fontSize)
    if howMany>0
        title([num2str(2*howMany), ' trials'])
    else
        title([num2str(trialPerCon), ' trials'])
    end
    
    saveas(gca, [names{ii}, '_', mergeName, '_PSE.pdf'])
    
    close all
    
    % save data
    if loadData==0
        if howMany>0
            save(['dataPMFbase', num2str(2*howMany), '_', names{ii}], 'dataPMFbase', 'fitObjBase', 'LLBase', 'exitflagBase', 'PSEbase') % baseline
            save(['dataPMF', mergeName, num2str(2*howMany), '_', names{ii}], 'dataPMF', 'fitObj', 'LL', 'exitflag', 'PSE') % experiment
        else
            save(['dataPMFbase_', names{ii}], 'dataPMFbase', 'fitObjBase', 'LLBase', 'exitflagBase', 'PSEbase') % baseline
            save(['dataPMF', mergeName, '_', names{ii}], 'dataPMF', 'fitObj', 'LL', 'exitflag', 'PSE') % experiment
        end
    end
    %
    %     % collapse data
    %     if ii==1
    %         dataPMFall = dataPMF; % experiment
    %         dataPMFbaseAll = dataPMFbase; % baseline
    %     else
    %         dataPMFall = [dataPMFall; dataPMF]; % experiment
    %         dataPMFbaseAll = [dataPMFbaseAll; dataPMFbase];  % baseline
    %     end
end
% % save collapsed data
%     save(['dataPMF', mergeName, '_all', num2str(size(names, 2))], 'dataPMFall') % experiment
%     save(['dataPMFbase', mergeName, '_all', num2str(size(names, 2))], 'dataPMFbaseAll') % baseline