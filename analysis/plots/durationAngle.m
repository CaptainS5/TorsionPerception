% function durationAngle
% Basic plots of the angle error as a function of duration before
% reversal
% Then save the data, and draw the plots

% 01/24/2018, Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc
folder = pwd;

% basic setting
names = {'testXW1'};
merged = 1; % whether initial direction is merged; 1=merged
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
% loadData = 0; % whether get new fitting or using existing fitting
howMany = -12;% include the first howMany trials for each condition*each initialDirection
% using for pilot to see how many trials we need... the file name
% would be 2*howMany as the total number of trials per condition (direction merged)
% if not using this, set howMany to a negative number such as -1
trialPerCon = 30; % trials per condition in the experiment
fontSize = 15; % for plot

if merged==1
    conditionNames = {'rotationSpeed'}; 
%     conditionNames = {'flashOnset'}; % which conditions are different
%     conditionNamesBase = {'flashOnset'}; % which conditions are different
    mergeName = 'merged';
else
    conditionNames = {'flashOnset', 'initialDirection'}; % which conditions are different
%     conditionNamesBase = conditionNames;
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
    %     load(['dataRawBase_', names{ii}])
    % back into the folder
    cd(folder)
    
    %     % locate data for each individual
    %     idx = find(strcmp(dataRawAll.sub, names{ii}));
    %     dataRaw = dataRawAll(idx,:); % experiment
    %     idx = find(strcmp(dataRawBaseAll.sub, names{ii}));
    %     dataRawBase = dataRawBaseAll(idx,:); % baseline
    % get the levels of each condition
    for jj = 1:size(conditionNames, 2)
        eval(['cons{jj} = unique(roundn(dataRaw.', conditionNames{jj}, ', roundN));']) % experiment
        %         eval(['consBase{jj} = unique(roundn(dataRawBase.', conditionNamesBase{jj}, ', roundN));']) % baseline
    end
    
    %% Experiment data, flash onset is important
    data = dataRaw;
    for tt = 1:size(data, 1)
%         % only for the first pilot testXW
%         if data.reportAngle(tt) > 180
%             data.reportAngle(tt) = data.reportAngle(tt)-180;
%         end
%         data.reversalAngle(tt) = data.reversalAngle(tt)-90;
%         if data.reversalAngle(tt) < 0
%             data.reversalAngle(tt) = data.reversalAngle(tt)+180;
%         end
%         if data.reversalAngle(tt) > 180
%             data.reversalAngle(tt) = data.reversalAngle(tt)-180;
%         end
        
        data.angleError(tt, 1) = -(data.reportAngle(tt)-data.reversalAngle(tt))*data.initialDirection(tt);
    end
    
%     onset = unique(data.flashOnset);
onset = unique(data.rotationSpeed);
    for ll = 1:length(onset)
        data.flashOnsetIdx(data.rotationSpeed==onset(ll), 1) = ll;
    end
    meanError = accumarray(data.flashOnsetIdx, data.angleError, [], @mean);
    stdError = accumarray(data.flashOnsetIdx, data.angleError, [], @std);
    
        % draw plots
        if merged==1
            figure
            box off
            errorbar(onset, meanError, stdError)
            
            xlabel('Rotation speed (°/s)')
            ylabel('Perceived shift (°)')
            set(gca, 'FontSize', fontSize)
        end
        
        saveas(gca, [names{ii}, '_', mergeName, '_speed.pdf'])
    end
    
    %% Baseline data, flash onset was not important and merged
    %     if loadData==0
    %         tempI = 1; % index to add into the table of dataPMFbase
    %
    %         comb = consBase{2};
    %         for tt = 1:size(comb, 1)
    %             dataPMFbase.sub(tempI, 1) = names(ii);
    %             idxAll = 1:size(dataRawBase, 1);
    %             for aa = 1:size(comb, 2)
    %                 eval(['dataPMFbase.', conditionNamesBase{aa+1}, '(tempI, 1) = ', num2str(comb(tt, aa)), ';'])
    %                 eval(['idx = find(roundn(dataRawBase.', conditionNamesBase{aa+1}, ', roundN)==', num2str(comb(tt, aa)), ');'])
    %                 idxAll = intersect(idxAll, idx);
    %             end
    %             idx = find(dataRawBase.perceivedLower(idxAll)==1);
    %             dataPMFbase.percentLeftLower(tempI, 1) = length(idx)/length(idxAll);
    %             dataPMFbase.totalTrials(tempI, 1) = length(idxAll);
    %
    %             tempI = tempI+1;
    %         end
    %     end
    %
    %     % draw plots for baseline, initial direction merged
    %     figure
    %     box off
    %     dataPlot = dataPMFbase;
    %     if loadData==0
    %     [fitObjBase LLBase exitflagBase] = PAL_PFML_Fit(dataPlot.flashDisplaceLeft, ...
    %         dataPlot.totalTrials.*dataPlot.percentLeftLower, dataPlot.totalTrials, searchGrid, paramsFree, PF);
    %     end
    %     % raw data
    %     scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
    %     hold on
    %     % fitted line
    %     yFitBase = PAL_Logistic(fitObjBase, xFitBase);
    %     plot(xFitBase, yFitBase, '-k')
    %     % get the PSE
    %     PSEbase = PAL_Logistic(fitObjBase, threshold, 'Inverse');
    %
    %     ylim([0, 1])
    %     xlabel('Flash Displacement (left-right, dva)')
    %     ylabel('Percentage of perceived left to be lower')
    %     if howMany>0
    %         title(['PSE=', num2str(PSEbase(1)), ', ', num2str(2*howMany),' trials'])
    %     else
    %         title(['PSE=', num2str(PSEbase(1))])
    %     end
    %
    %     saveas(gca, [names{ii}, '_baseline_fit.pdf'])
    
    % save data
%     if loadData==0
        if howMany>0
            %             save(['dataPMFbase', num2str(2*howMany), '_', names{ii}], 'dataPMFbase', 'fitObjBase', 'LLBase', 'exitflagBase', 'PSEbase') % baseline
            save(['data', mergeName, num2str(2*howMany), '_', names{ii}], 'data') % experiment
        else
            %             save(['dataPMFbase_', names{ii}], 'dataPMFbase', 'fitObjBase', 'LLBase', 'exitflagBase', 'PSEbase') % baseline
            save(['data', mergeName, '_', names{ii}], 'data') % experiment
        end
%     end
    %
    %     % collapse data
    %     if ii==1
    %         dataPMFall = dataPMF; % experiment
    %         dataPMFbaseAll = dataPMFbase; % baseline
    %     else
    %         dataPMFall = [dataPMFall; dataPMF]; % experiment
    %         dataPMFbaseAll = [dataPMFbaseAll; dataPMFbase];  % baseline
    %     end
% end
% % save collapsed data
%     save(['dataPMF', mergeName, '_all', num2str(size(names, 2))], 'dataPMFall') % experiment
%     save(['dataPMFbase', mergeName, '_all', num2str(size(names, 2))], 'dataPMFbaseAll') % baseline