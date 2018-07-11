% function speedAnglePlot
% Basic plots of the angle error as a function of duration before
% reversal
% Then save the data, and draw the plots

% 07/10/2018, Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc
folder = pwd;

% basic setting
% names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
% names = {'XWcontrolTest' 'XWcontrolTest2' 'XWcontrolTest3'};
names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol'};
merged = 1; % whether initial direction is merged; 1=merged
mergedSide = 1; % for Exp2
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
% loadData = 0; % whether get new fitting or using existing fitting
howMany = -12;% include the first howMany trials for each condition*each initialDirection
% using for pilot to see how many trials we need... the file name
% would be 2*howMany as the total number of trials per condition (direction merged)
% if not using this, set howMany to a negative number such as -1
trialPerCon = 18; % trials per condition in the experiment; 30 for Exp1, 18 for Exp2
fontSize = 15; % for plot
dirCons = [-1 1]; % initial counterclockwise and clockwise; in plots shows direction after reversal

% if merged==1
%     conditionNames = {'rotationSpeed'};
%     %     conditionNames = {'flashOnset'}; % which conditions are different
%     %     conditionNamesBase = {'flashOnset'}; % which conditions are different
%     mergeName = 'merged';
% else
%     conditionNames = {'rotationSpeed', 'initialDirection'}; % which conditions are different
%     %     conditionNamesBase = conditionNames;
%     mergeName = 'notMerged';
% end

if merged==1
    if mergedSide==1
        conditionNames = {'rotationSpeed'}; % rotationSpeed here is the tilt angle
        mergeName = 'mergedBoth';
        legendName = {'allMerged'};
    else
        conditionNames = {'rotationSpeed', 'targetSide'}; % rotationSpeed here is the tilt angle
        mergeName = 'mergedD';
        legendName = {'L' 'R'};
    end
else
    if mergedSide==1
        conditionNames = {'rotationSpeed', 'initialDirection'}; % which conditions are different
        mergeName = 'mergedS';
        legendName = {'CC' 'CCW'};
    else
        conditionNames = {'rotationSpeed', 'initialDirection', 'targetSide'}; % which conditions are different
        mergeName = 'notMerged';
        legendName = {'CC-L' 'CC-R' 'CCW-L' 'CCW-R'};
    end
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
%     % get the levels of each condition
%     for jj = 1:size(conditionNames, 2)
%         eval(['cons{jj} = unique(roundn(dataRaw.', conditionNames{jj}, ', roundN));']) % experiment
%         %         eval(['consBase{jj} = unique(roundn(dataRawBase.', conditionNamesBase{jj}, ', roundN));']) % baseline
%     end
    
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
    if dataBase.a(ii, 1)~=0
    temp11 = find(data.angleError>dataBase.b(ii, 1) & data.angleError<=dataBase.asympt(ii, 1));
    temp21 = find(data.angleError>dataBase.asympt(ii, 1));
    temp12 = find(data.angleError<-dataBase.b(ii, 1) & data.angleError>=-dataBase.asympt(ii, 1));
    temp22 = find(data.angleError<-dataBase.asympt(ii, 1));
    data.angleError(temp11) = (data.angleError(temp11)-dataBase.b(ii, 1))./(dataBase.a(ii, 1)+1);
    data.angleError(temp21) = data.angleError(temp21)-(dataBase.asympt(ii, 1)-16);
    data.angleError(temp12) = (data.angleError(temp12)+dataBase.b(ii, 1))./(dataBase.a(ii, 1)+1);
    data.angleError(temp22) = data.angleError(temp22)+(dataBase.asympt(ii, 1)-16);
    else
        temp1 = find(data.angleError>dataBase.b(ii, 1));
        temp2 = find(data.angleError<-dataBase.b(ii, 1));
        data.angleError(temp1) = data.angleError(temp1)-dataBase.b(ii, 1);
        data.angleError(temp2) = data.angleError(temp2)+dataBase.b(ii, 1);
    end
    
    idxt = find(data.angleError<-10);
    data(idxt, :) = [];
    
    % save the generated data
    if ii==1
        dataPercept = data;
    else
        dataPercept = [dataPercept; data];
    end
        
%     % merged
%     onset = unique(data.rotationSpeed);
%     for ll = 1:length(onset)
%         data.flashOnsetIdx(data.rotationSpeed==onset(ll), 1) = ll;
%     end
%     meanError = accumarray(data.flashOnsetIdx, data.angleError, [], @mean);
%     stdError = accumarray(data.flashOnsetIdx, data.angleError, [], @std);
%     
%     % initial direction seperated
%     onset = unique(data.rotationSpeed);
%     for ll = 1:length(onset)
%         data.flashOnsetIdx(data.rotationSpeed==onset(ll), 1) = ll;
%     end
%     for dirI = 1:2
%         dataT = data(data.initialDirection==(dirCons(dirI)), :);
%         meanErrorS(:, dirI) = accumarray(dataT.flashOnsetIdx, dataT.angleError, [], @mean);
%         stdErrorS(:, dirI) = accumarray(dataT.flashOnsetIdx, dataT.angleError, [], @std);
%     end

    cN = 1;
    if strcmp(mergeName, 'mergedD')
        dataCons = data.targetSide;
        cN = 2;
    elseif strcmp(mergeName, 'mergedS')
        dataCons = data.initialDirection;
        cN = 2;
    elseif strcmp(mergeName, 'notMerged')
        dataCons = data.initialDirection;
        dataCons = [dataCons data.targetSide];
        cN = 4;
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
    
    % draw plots
        figure
        box off
        for cI = 1:cN
            errorbar(onset, meanError(:, cI), stdError(:, cI), 'LineWidth', 1.5)
            hold on
        end
        legend(legendName, 'box', 'off', 'Location', 'northwest')
%         ylim([-25, 25])
        xlabel('Rotation speed (°/s)')
        ylabel('Perceived shift in direction (°)')
        set(gca, 'FontSize', fontSize, 'box', 'off')
        saveas(gca, [names{ii}, '_', mergeName, '_speedSameDirection.pdf'])
end

cd ..
save(['dataPercept_all', num2str(ii), '.mat'], 'dataPercept')