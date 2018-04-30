% function baselinePlot

% 04/21/2018, Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc
folder = pwd;

% basic setting
names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY'};
merged = 1; % whether initial direction is merged; 1=merged
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
trialPerCon = 6; % trials per condition (separate for directions) in the experiment
% for baseline, initialDirection IS the direction of displacement
fontSize = 15; % for plot
dirCons = [-1 1]; % initial counterclockwise and clockwise; in plots shows direction after reversal

if merged==1
    conditionNames = {'rotationSpeed'}; % rotationSpeed here is the tilt angle
    mergeName = 'merged';
else
    conditionNames = {'rotationSpeed', 'initialDirection'}; % which conditions are different
    mergeName = 'notMerged';
end

% % load raw data collapsed
% cd ..
% load(['dataRaw_all', num2str(size(names, 2))])
% load(['dataRawBase_all', num2str(size(names, 2))])
% % back into the folder
% cd(folder)
dataBase = table();
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
    % get the levels of each condition
    for jj = 1:size(conditionNames, 2)
        eval(['cons{jj} = unique(roundn(dataRawBase.', conditionNames{jj}, ', roundN));'])
    end
    
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
    idxt = find((data.reportAngle<90 & data.reversalAngle>90) | (data.reportAngle>90 & data.reversalAngle<90) | abs(data.angleError)>15);
    data(idxt, :) = [];
    
    %     onset = unique(data.flashOnset);
    % merged
    onset = unique(data.rotationSpeed);
    for ll = 1:length(onset)
        data.flashOnsetIdx(data.rotationSpeed==onset(ll), 1) = ll;
    end
    meanError = accumarray(data.flashOnsetIdx, data.angleError, [], @mean);
    stdError = accumarray(data.flashOnsetIdx, data.angleError, [], @std);

    % just use the average...
    dataBase.sub(t, 1) = t;
    dataBase.baseErrorMean(t, 1) = mean(data.angleError);
    dataBase.baseErrorStd(t, 1) = std(data.angleError);
%     % fit the curve
%     [dataFit.fitobject{t}, dataFit.gof{t}, dataFit.output{t}] = fit(data.rotationSpeed, data.angleError, 'lowess', 'lower', [-inf, -inf, 0], 'upper', [inf, inf, 0]); % f(x) = p1*x^2 + p2*x + p3
    
    % draw plots
    figure
    box off
    errorbar(onset, meanError, stdError, 'LineWidth', 2)
%     hold on
%     plot(dataFit.fitobject{t});%, 'LineWidth', 2)
%     legend({'data' 'fitted curve'}, 'box', 'off')
%     ylim([-5, 10])
    xlabel('Tilt angle (°)')
    ylabel('Report error (°)')
    title(['mean=', num2str(dataBase.baseErrorMean(t, 1))])
    set(gca, 'FontSize', fontSize, 'box', 'off')
    saveas(gca, [names{t}, '_baseline_', mergeName, '.pdf'])
end

cd ..
save(['dataBase_all', num2str(t), '.mat'], 'dataBase')