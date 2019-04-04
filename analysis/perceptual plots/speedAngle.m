% function speedAnglePlot
% Basic plots of the angle error as a function of duration before
% reversal
% Then save the data, and draw the plots

% 10/17/2018, Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc
folder = pwd;

% basic setting
names = {'XW3' 'DC3' 'AR3' 'JF3' 'PK3' 'AD3', 'PH3'};
merged = 0; % whether initial direction is merged; 1=merged, 0=not
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
% loadData = 0; % whether get new fitting or using existing fitting
howMany = -12;% include the first howMany trials for each condition*each initialDirection
% using for pilot to see how many trials we need... the file name
% would be 2*howMany as the total number of trials per condition (direction merged)
% if not using this, set howMany to a negative number such as -1
trialPerCon = 20; % trials per condition in the experiment; 30 for Exp1, 18 for Exp2
fontSize = 15; % for plot
headCons = [-1 0 1]; % head tilt direction
headNames = {'CCW' 'Up' 'CW'};
dirCons = [-1 1]; % initial counterclockwise and clockwise; in plots shows direction after reversal
% colorPlot = [232 71 12; 2 255 44; 12 76 150; 140 0 255; 255 212 13]/255;
for t = 1:size(names, 2)
    if t<=2
        markerC(t, :) = (t+2)/4*[77 255 202]/255;
    elseif t<=4
        markerC(t, :) = (t)/4*[70 95 232]/255;
    elseif t<=6
        markerC(t, :) = (t-2)/4*[232 123 70]/255;
    elseif t<=8
        markerC(t, :) = (t-4)/4*[255 231 108]/255;
    elseif t<=10
        markerC(t, :) = (t-6)/4*[255 90 255]/255;
    end
end

cd ..
% % load baseline
% load(['dataBase_all', num2str(size(names, 2)), '.mat']);
% % load raw data collapsed
% load(['dataRaw_all', num2str(size(names, 2))])
% load(['dataRawBase_all', num2str(size(names, 2))])
% % back into the folder
cd(folder)

%%
dataPercept = table();
dataPMFall = table(); % experiment
for ii = 1:size(names, 2)
    % load raw data for each participant
    cd ..
    if howMany>0
        load(['dataRaw', num2str(2*howMany), '_', names{ii}])
    else
        load(['dataRaw_', names{ii}])
%         load(['dataRawBase_', names{ii}])
    end
    %     load(['dataRawBase_', names{ii}])
    % back into the folder
    cd(folder)
    
    %% Experiment data
    data = dataRaw;
    for tt = 1:size(data, 1)
        data.reportAngle(tt) = data.reportAngle(tt)-90;
        if data.reportAngle(tt) < 0
            data.reportAngle(tt) = data.reportAngle(tt)+180;
        end
        data.reversalAngle(tt) = data.reversalAngle(tt)-90;
        if data.reversalAngle(tt) < 0
            data.reversalAngle(tt) = data.reversalAngle(tt)+180;
        end
        
%         idxBase = find(dataBase.sub==ii & dataBase.headTilt==data.headTilt(tt));
%         baseAngle = dataBase.baseMeanAngle(idxBase, 1);
        data.angleError(tt, 1) = -(data.reportAngle(tt)-data.reversalAngle(tt))*data.initialDirection(tt);
    end
    
    % save the generated data
    if ii==1
        dataPercept = data;
    else
        dataPercept = [dataPercept; data];
    end
        
    % initial direction merged
    headIdx = unique(data.headTilt);
    headSub{ii} = headIdx;
    for ll = 1:length(headIdx)
        data.headTiltIdx(data.headTilt==headIdx(ll), 1) = ll;
    end
    meanErrorSubM{ii} = accumarray(data.headTiltIdx, data.angleError, [], @mean);
    stdErrorSubM{ii} = accumarray(data.headTiltIdx, data.angleError, [], @std);
    
    % initial direction seperated
    headIdx = unique(data.headTilt);
    for ll = 1:length(headIdx)
        data.headTiltIdx(data.headTilt==headIdx(ll), 1) = ll;
    end
    for headI = 1:length(headIdx)
        for dirI = 1:2
            dataT = data(data.initialDirection==(dirCons(dirI)), :); % 1=afterReversal CW, 2=afterReversal CCW
            meanErrorSub{ii}(:, dirI) = accumarray(dataT.headTiltIdx, dataT.angleError, [], @mean);
            stdErrorSub{ii}(:, dirI) = accumarray(dataT.headTiltIdx, dataT.angleError, [], @std);
        end
    end

% draw individual plots
figure
box off
hold on
p1 = errorbar(headIdx, meanErrorSub{ii}(:, 1), stdErrorSub{ii}(:, 1), '-o', 'LineWidth', 1, 'color', markerC(1, :));
p2 = errorbar(headIdx, meanErrorSub{ii}(:, 2), stdErrorSub{ii}(:, 2), '--o', 'LineWidth', 1, 'color', markerC(1, :));

legend([p1, p2], {'visual CW' 'visual CCW'}, 'box', 'off', 'Location', 'northwest')
%         ylim([-25, 25])
xlim([-1.5 1.5])
xlabel('Head tilt direction')
ylabel('Perceived shift in direction (°)')
set(gca, 'FontSize', fontSize, 'box', 'off')
saveas(gca, [names{ii}, '_illusion.pdf'])
end

% draw plots for all together
figure
box off
for subN = 1:size(names, 2)
    hold on
    p{subN} = errorbar(headSub{subN}, meanErrorSubM{subN}, stdErrorSubM{subN}, '-o', 'LineWidth', 1, 'color', markerC(subN, :));
end
legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}], names, 'box', 'off', 'Location', 'northwest')
%         ylim([-25, 25])
xlim([-1.5 1.5])
xlabel('Head tilt direction')
ylabel('Perceived shift in direction (°)')
set(gca, 'FontSize', fontSize, 'box', 'off')
saveas(gca, ['all_illusion.pdf'])

% cd ..
% save(['dataPercept_all', num2str(ii), '.mat'], 'dataPercept')