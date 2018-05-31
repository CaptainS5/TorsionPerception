% function speedAnglePlot
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
names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
merged = 1; % whether initial direction is merged; 1=merged
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
% loadData = 0; % whether get new fitting or using existing fitting
howMany = -12;% include the first howMany trials for each condition*each initialDirection
% using for pilot to see how many trials we need... the file name
% would be 2*howMany as the total number of trials per condition (direction merged)
% if not using this, set howMany to a negative number such as -1
trialPerCon = 30; % trials per condition in the experiment
fontSize = 15; % for plot
dirCons = [-1 1]; % initial counterclockwise and clockwise; in plots shows direction after reversal

if merged==1
    conditionNames = {'rotationSpeed'};
    %     conditionNames = {'flashOnset'}; % which conditions are different
    %     conditionNamesBase = {'flashOnset'}; % which conditions are different
    mergeName = 'merged';
else
    conditionNames = {'rotationSpeed', 'initialDirection'}; % which conditions are different
    %     conditionNamesBase = conditionNames;
    mergeName = 'notMerged';
end

cd ..
% load baseline
load(['dataBase_all', num2str(size(names, 2)), '.mat']);
% load raw data collapsed
% load(['dataRaw_all', num2str(size(names, 2))])
% load(['dataRawBase_all', num2str(size(names, 2))])
% % back into the folder
cd(folder)

dataPercept = table();
dataPMFall = table(); % experiment
dataPMFbaseAll = table(); % baseline
for ii = 1:size(names, 2)
    % load raw data for each participant
    cd ..
    if howMany>0
        load(['dataRaw', num2str(2*howMany), '_', names{ii}])
    else
        load(['dataRaw_', names{ii}])
        load(['dataRawBase_', names{ii}])
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
        data.reportAngle(tt) = data.reportAngle(tt)-90;
        if data.reportAngle(tt) < 0
            data.reportAngle(tt) = data.reportAngle(tt)+180;
        end
        data.reversalAngle(tt) = data.reversalAngle(tt)-90;
        if data.reversalAngle(tt) < 0
            data.reversalAngle(tt) = data.reversalAngle(tt)+180;
        end
        %         if data.reversalAngle(tt) > 180
        %             data.reversalAngle(tt) = data.reversalAngle(tt)-180;
        %         end
        
        data.angleError(tt, 1) = -(data.reportAngle(tt)-data.reversalAngle(tt))*data.initialDirection(tt);
    end
    % corrected for baseline
    temp1 = find(data.angleError>dataBase.baseErrorMean(ii, 1));
    temp2 = find(data.angleError<-dataBase.baseErrorMean(ii, 1));
    data.angleError(temp1) = data.angleError(temp1)-dataBase.baseErrorMean(ii, 1);
    data.angleError(temp2) = data.angleError(temp2)+dataBase.baseErrorMean(ii, 1);
    
    idxt = find(data.angleError<-10);
    data(idxt, :) = [];
    
    % save the generated data
    if ii==1
        dataPercept = data;
    else
        dataPercept = [dataPercept; data];
    end
        
    %     onset = unique(data.flashOnset);
    % merged
    onset = unique(data.rotationSpeed);
    for ll = 1:length(onset)
        data.flashOnsetIdx(data.rotationSpeed==onset(ll), 1) = ll;
    end
    meanError = accumarray(data.flashOnsetIdx, data.angleError, [], @mean);
    stdError = accumarray(data.flashOnsetIdx, data.angleError, [], @std);
    
    % initial direction seperated
    onset = unique(data.rotationSpeed);
    for ll = 1:length(onset)
        data.flashOnsetIdx(data.rotationSpeed==onset(ll), 1) = ll;
    end
    for dirI = 1:2
        dataT = data(data.initialDirection==(dirCons(dirI)), :);
        meanErrorS(:, dirI) = accumarray(dataT.flashOnsetIdx, dataT.angleError, [], @mean);
        stdErrorS(:, dirI) = accumarray(dataT.flashOnsetIdx, dataT.angleError, [], @std);
    end
    
    % draw plots
    if merged==1
        figure
        box off
        errorbar(onset, meanError, stdError, 'LineWidth', 2)
        
%         ylim([0, 25])
        xlabel('Rotation speed (°/s)')
        ylabel('Perceived shift (°)')
        set(gca, 'FontSize', fontSize, 'box', 'off')
        saveas(gca, [names{ii}, '_', mergeName, '_speedSameDirection.pdf'])
    else
        figure
        box off
        errorbar(onset, meanErrorS(:, 1), stdErrorS(:, 1), 'LineWidth', 2)
        hold on
        errorbar(onset, -meanErrorS(:, 2), stdErrorS(:, 2), 'LineWidth', 2)
        legend({'CW' 'CCW'}, 'box', 'off', 'Location', 'northwest')
%         ylim([-25, 25])
        xlabel('Rotation speed (°/s)')
        ylabel('Perceived shift (°)')
        set(gca, 'FontSize', fontSize, 'box', 'off')
        saveas(gca, [names{ii}, '_', mergeName, '_speedSameDirection.pdf'])
    end
end

cd ..
save(['dataPercept_all', num2str(ii), '.mat'], 'dataPercept')