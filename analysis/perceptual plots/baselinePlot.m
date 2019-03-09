% function baselinePlot
% Exp3, just calculate the mean of reported angle for physical vertical
% 03/05/2019 Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc
folder = pwd;

% basic setting
names = {'tXW0'}; %{'tJF' 'AD'};
% merged = 1; % whether initial direction is merged; 1=merged
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
trialPerCon = 10; % trials per condition (separate for directions) in the experiment
% always vertical in Exp 3
fontSize = 15; % for plot
% dirCons = [-1 1]; % initial counterclockwise and clockwise; in plots shows direction after reversal

% % load raw data collapsed
% cd ..
% load(['dataRaw_all', num2str(size(names, 2))])
% load(['dataRawBase_all', num2str(size(names, 2))])
% % back into the folder
% cd(folder)
dataBase = table();
dataBaseTrial = table();
count = 1;
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
        
%         data.angleError(tt, 1) = (data.reportAngle(tt)-data.reversalAngle(tt))*data.initialDirection(tt);
    end
%     idxt = find((data.reportAngle<87 & data.reversalAngle>90) | (data.reportAngle>93 & data.reversalAngle<90) | abs(data.angleError)>15);
%     data(idxt, :) = [];
%     [data trialDeleted(t)]= cleanData(data, 'angleError'); % excluding outliers 3 sd away
    
    headCons = unique(data.headTilt);
    for headI = 1:size(headCons, 1)
        idx = find(data.headTilt==headCons(headI));
        % just use the average...
        dataBase.sub(count, 1) = t;
        dataBase.headTilt(count, 1) = headCons(headI);
        dataBase.baseMeanAngle(count, 1) = mean(data.reportAngle(idx, 1));
        dataBase.baseMeanAngleStd(count, 1) = std(data.reportAngle(idx, 1));
        count = count+1;
    end
%     % fit the curve
%     [dataFit.fitobject{t}, dataFit.gof{t}, dataFit.output{t}] = fit(data.rotationSpeed, data.angleError, 'poly1', 'lower', [-inf, -inf], 'upper', [inf, inf]); % f(x) = p1*x + p2
%     
%     dataBase.sub(t, 1) = t;
%     dataBase.a(t, 1) = dataFit.fitobject{t}.p1;
%     dataBase.b(t, 1) = dataFit.fitobject{t}.p2;
%     dataBase.asympt(t, 1) = dataBase.a(t, 1)*16+dataBase.b(t, 1)+16;
%     
%     % draw plots
%     figure
%     box off
%     for cI = 1:cN
%         errorbar(onset, meanError(:, cI), stdError(:, cI), 'LineWidth', 1.5)
%         hold on
%     end
%     plot(dataFit.fitobject{t});%, 'LineWidth', 2)
%     legend(legendName, 'box', 'off')
% %     ylim([-5, 10])
%     xlabel('Tilt angle (°)')
%     ylabel('Report error in direction (°)')
% %     if cN==1
% %     title(['mean=', num2str(dataBase.baseErrorMean(t, 1))])
% %     end
%     set(gca, 'FontSize', fontSize, 'box', 'off')
%     saveas(gca, [names{t}, '_baseline_', mergeName, '.pdf'])

    if t==1
        dataBaseTrial = data;
    else
        dataBaseTrial = [dataBaseTrial; data];
    end
end
cd ..
save(['dataBase_all', num2str(t), '.mat'], 'dataBase', 'dataBaseTrial')
