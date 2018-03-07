% function sortRawData
% Sorting raw data into long format, baseline in separate files
% Merged different initial directions into clockwise:
% clockwise right side = counterclockwise left side.
% Under clockwise direction, positive=perceived left lower
% (initialDirection*reportStyle*choice)

% 10/24/2017 Xiuyun Wu
clear all; close all; clc

% basic setting
names = {'XWb'};
folder = pwd;
howMany = -13; % include the first howMany trials for each condition*each initialDirection
% using for pilot to see how many trials we need...
% if not using this, set howMany to a negative number such as -1
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
trialPerBlock = 60; % ignore unfinished blocks
trialPerBlockBase = 60; % ignore unfinished blocks

dataRawAll = table();
dataRawBaseAll = table();
for ii = 1:size(names, 2)
    % Read all raw data
    cd ..
    % read Experiment data
    cd(['data\', names{ii}])
    % get the filenames to load
    fileResp = dir('response*.mat');
    fileResp = struct2cell(fileResp);
%     fileDisp = dir('display*.mat');
%     fileDisp = struct2cell(fileDisp);
    % load raw data into dataRaw
    dataRaw = table();
    for jj = 1:size(fileResp, 2)
        load(fileResp{1, jj})
%         % ONLY for the initial pilot... still adjusting experimental codes...
%         load(fileDisp{1, jj})

        if size(resp, 1)>=trialPerBlock % ignore files for unfinished blocks
            % regular processing below, first putting all data together
            if jj==1
                dataRaw = resp;
%                 dataRaw.rotationSpeed = display{jj}.rotationSpeed;
            else
%                 if size(resp, 2)>10
%                     resp(resp.RTms<400, :) = [];
%                     resp.RTms = [];
%                 end
%                 resp.rotationSpeed = display{jj}.rotationSpeed;
                dataRaw = [dataRaw; resp];
            end
        end
    end
%     % read Baseline data
%     cd(['baseline'])
%     % get the filenames to load
%     fileResp = dir('response*.mat');
%     fileResp = struct2cell(fileResp);
%     % load raw data into dataRawBase
%     dataRawBase = table();
%     for jj = 1:size(fileResp, 2)
%         load(fileResp{1, jj})
%         if size(resp, 1)>=trialPerBlockBase
%             % regular processing below, first putting all data together
%             if jj==1
%                 dataRawBase = resp;
%             else
%                 dataRawBase = [dataRawBase; resp];
%             end
%         end
%     end
    
    % Go to the analysis file to save the processed data
    cd(folder)
    % delete invalid trials
    dataRaw(dataRaw.RTms<400, :) = [];
    dataRaw.sub = mat2cell(repmat(names{ii}, size(dataRaw, 1), 1), ones(size(dataRaw, 1), 1), length(names{ii})); % experiment
%     dataRawBase(dataRawBase.choice==0, :) = [];
%     dataRawBase.sub = mat2cell(repmat(names{ii}, size(dataRawBase, 1), 1), ones(size(dataRawBase, 1), 1), length(names{ii})); % baseline

    %     % ONLY for the initial pilot...leftArrow=1, rightArrow=2; reportStyle = -1;
    %     dataRaw.reportStyle = repmat([-1], size(dataRaw, 1), 1);
    %     dataRaw.flashDisplaceLeft = dataRaw.flashDisplaceLeft*-1;
    %     dataRaw.choice(dataRaw.choice==1) = -1; % choose left
    %     dataRaw.choice(dataRaw.choice==2) = 1; % choose right
    
%     dataRaw.flashDisplaceLeftMerged = dataRaw.flashDisplaceLeft.*dataRaw.initialDirection; % for merged direction
    
%     dataRaw.perceivedLowerMerged = dataRaw.initialDirection.*dataRaw.reportStyle.*dataRaw.choice; % perception of the side being lower
    % 1: left lower; -1: right lower
    % this is merged direction, all initial direction assumed to be
    % clockwise
    
%     dataRaw.perceivedLowerNotMerged = dataRaw.reportStyle.*dataRaw.choice; % perception of the side being lower
    % initial direction not merged, 1: left lower; -1: right lower
    % for baseline, initial direction not important and merged...
%     dataRawBase.perceivedLower = dataRawBase.reportStyle.*dataRawBase.choice;
    
    % save data with each trials for each participant
    if howMany>0 % delete the later trials, only for the experiment data
        conditionNames = {'flashOnset', 'flashDisplaceLeft', 'initialDirection'};
        for jj = 1:size(conditionNames, 2)
            eval(['cons{jj} = unique(roundn(dataRaw.', conditionNames{jj}, ', roundN));']) % experiment
        end
        comb = cons{1};
        nextConIdx = 2;
        while nextConIdx<=size(conditionNames, 2)
            comb = genCombinations(comb, cons{nextConIdx});
            nextConIdx = nextConIdx+1;
        end
        
        for tt = 1:size(comb, 1)
            idxAll = 1:size(dataRaw, 1);
            for aa = 1:size(comb, 2)
                eval(['idx = find(roundn(dataRaw.', conditionNames{aa}, ', roundN)==', num2str(comb(tt, aa)), ');'])
                idxAll = intersect(idxAll, idx); % all the indices for this condition
            end
%             length(idxAll)
            dataRaw(idxAll(howMany+1:end), :) = []; % delete the trials
        end
        
        save(['dataRaw', num2str(2*howMany), '_', names{ii}], 'dataRaw') % experiment
    else
        save(['dataRaw_', names{ii}], 'dataRaw') % experiment
    end
%     save(['dataRawBase_', names{ii}], 'dataRawBase') % baseline
    
    % collapse all data
    if ii==1
        dataRawAll = dataRaw; % experiment
%         dataRawBaseAll = dataRawBase; % baseline
    else
        dataRawAll = [dataRawAll; dataRaw]; % experiment
%         dataRawBaseAll = [dataRawBaseAll; dataRawBase]; % baseline
    end
    
end
% save(['dataRaw_all', num2str(size(names, 2))], 'dataRawAll')
% save(['dataRawBase_all', num2str(size(names, 2))], 'dataRawBaseAll')