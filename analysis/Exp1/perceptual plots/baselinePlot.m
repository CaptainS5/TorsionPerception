% function baselinePlot

% 07/07/2018, Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc
folder = pwd;

% basic setting
names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
merged = 1; % whether initial direction is merged; 1=merged
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
trialPerCon = 6; % trials per condition (separate for directions) in the experiment; 6 for Exp1, 5 for Exp2
% for baseline, initialDirection IS the direction of displacement
fontSize = 15; % for plot
dirCons = [-1 1]; % initial counterclockwise and clockwise; in plots shows direction after reversal

if merged==1
    conditionNames = {'rotationSpeed'}; % rotationSpeed here is the tilt angle
    mergeName = 'merged';
    legendName = {'merged'};
else
    conditionNames = {'rotationSpeed', 'initialDirection'}; % which conditions are different
    mergeName = 'notMerged';
    legendName = {'CC' 'CCW'};
end

% % load raw data collapsed
% cd ..
% load(['dataRaw_all', num2str(size(names, 2))])
% load(['dataRawBase_all', num2str(size(names, 2))])
% % back into the folder
% cd(folder)
dataBase = table();
dataBaseTrial = table();
for t = 1:size(names, 2)
    % load raw data for each participant
    cd ..
    load(['dataRawBase_', names{t}])
    % back into the folder
    cd(folder)
    
    %     % locate data for each individual
    %     idx = find(strcmp(dataRawAll.sub, names{ii}));
    %     dataRaw = dataRawAll(idx,:); % experiment
    %     idx = find(strcmp(dataRawBaseAll.sub, names{ii}));
    %     dataRawBase = dataRawBaseAll(idx,:); % baseline
%     % get the levels of each condition
%     for jj = 1:size(conditionNames, 2)
%         eval(['cons{jj} = unique(roundn(dataRawBase.', conditionNames{jj}, ', roundN));'])
%     end
    
    data = dataRawBase;
    for tt = 1:size(data, 1)
        data.reportAngle(tt) = data.reportAngle(tt)-90;
        if data.reportAngle(tt) < 0
            data.reportAngle(tt) = data.reportAngle(tt)+180;
        end
        data.reversalAngle(tt) = data.reversalAngle(tt)-90;
        if data.reversalAngle(tt) < 0
            data.reversalAngle(tt) = data.reversalAngle(tt)+180;
        end
        
        data.angleError(tt, 1) = (data.reportAngle(tt)-data.reversalAngle(tt))*data.initialDirection(tt);
    end
    idxt = find((data.reportAngle<88 & data.reversalAngle>90) | (data.reportAngle>92 & data.reversalAngle<90) | abs(data.angleError)>10);
    data(idxt, :) = [];
    [data trialDeleted(t)]= cleanData(data, 'angleError'); % excluding outliers 3 sd away
    
    if t==1
        dataBaseTrial = data;
    else
        dataBaseTrial = [dataBaseTrial; data];
    end
    
    cN = 1;
    if strcmp(mergeName, 'notMerged')
        dataCons = data.initialDirection;
        cN = 2;
    end
    if cN>1
        sortCons = unique(dataCons, 'rows');
    end
    
    onset = unique(data.rotationSpeed);
    for ll = 1:length(onset)
        data.flashOnsetIdx(data.rotationSpeed==onset(ll), 1) = ll;
    end
    for ll = 1:length(onset)
        if cN==1
            meanError(:, 1) = accumarray(data.flashOnsetIdx, data.angleError, [], @mean);
            stdError(:, 1) = accumarray(data.flashOnsetIdx, data.angleError, [], @std);
        else
            for cI = 1:cN
                sortConsT = repmat(sortCons(cI, :), size(dataCons, 1), 1);
                arr = find(all(dataCons==sortConsT, 2));
                meanError(:, cI) = accumarray(data.flashOnsetIdx(arr), data.angleError(arr), [], @mean);
                stdError(:, cI) = accumarray(data.flashOnsetIdx(arr), data.angleError(arr), [], @std);
            end
        end
    end
    
    % fit the curve
    [dataFit.fitobject{t}, dataFit.gof{t}, dataFit.output{t}] = fit(data.rotationSpeed, data.angleError, 'poly1', 'lower', [0, 0], 'upper', [inf, inf]); % f(x) = p1*x + p2
    
    dataBase.sub(t, 1) = t;
    dataBase.a(t, 1) = dataFit.fitobject{t}.p1;
    dataBase.b(t, 1) = dataFit.fitobject{t}.p2;
    dataBase.asympt(t, 1) = dataBase.a(t, 1)*16+dataBase.b(t, 1)+16;
    
    % draw plots
    figure
    box off
    for cI = 1:cN
        errorbar(onset, meanError(:, cI), stdError(:, cI), 'LineWidth', 1.5)
        hold on
    end
    plot(dataFit.fitobject{t});%, 'LineWidth', 2)
    legend(legendName, 'box', 'off')
%     ylim([-5, 10])
    xlabel('Tilt angle (°)')
    ylabel('Absolute report error (°)')
%     if cN==1
%     title(['mean=', num2str(dataBase.baseErrorMean(t, 1))])
%     end
    set(gca, 'FontSize', fontSize, 'box', 'off')
    saveas(gca, [names{t}, '_baseline_', mergeName, '.pdf'])
end
if cN==1
    cd ..
    save(['dataBase_all', num2str(t), '.mat'], 'dataBase', 'dataBaseTrial', 'trialDeleted')
end