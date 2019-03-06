% function sortRawData
% Sorting raw data into long format, baseline in separate files
% For Exp3, do not merge directions, exp trials and baseline
% perception trials mixed in each block, but saved in separate files

% 03/05/2019 Xiuyun Wu
clear all; close all; clc

% basic setting
names = {'tXW0' 'tJF'};
folder = pwd;
howMany = -13; % include the first howMany trials for each condition*each initialDirection
% using for pilot to see how many trials we need...
% if not using this, set howMany to a negative number such as -1
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
trialPerBlockTotal = 50;
trialPerBlockExp = 40; % 
trialPerBlockBase = 10; % 

dataRawAll = table();
dataRawBaseAll = table();
for ii = 1:1%size(names, 2)
    % Read all raw data
    cd ..
    cd(['data\', names{ii}])
    % get the filenames to load
    fileResp = dir('response*.mat');
    fileResp = struct2cell(fileResp);

    % load raw data into dataRaw
    dataRaw = table();
    dataRawBase = table();
    for jj = 1:size(fileResp, 2)
        load(fileResp{1, jj})
        
        if size(resp, 1)>=trialPerBlockTotal % ignore files for unfinished blocks
            % regular processing below, first putting all data together
            if jj==1
                idxExp = find(resp.rotationSpeed~=0);
                idxBase = find(resp.rotationSpeed==0);
                dataRaw = resp(idxExp, :);
                dataRawBase = resp(idxBase, :);
            else
                idxExp = find(resp.rotationSpeed~=0);
                idxBase = find(resp.rotationSpeed==0);
                dataRaw = [dataRaw; resp(idxExp, :)];
                dataRawBase = [dataRawBase; resp(idxBase, :)];
            end
        end
    end
    
    % Go to the analysis file to save the processed data
    cd(folder)
%     % delete invalid trials
%     dataRaw(dataRaw.RTms<400, :) = [];
%     dataRaw.sub = mat2cell(repmat(names{ii}, size(dataRaw, 1), 1), ones(size(dataRaw, 1), 1), length(names{ii})); % experiment
%         dataRawBase(dataRawBase.choice==0, :) = [];
%     dataRawBase(dataRawBase.RTms<400, :) = [];
%     dataRawBase.sub = mat2cell(repmat(names{ii}, size(dataRawBase, 1), 1), ones(size(dataRawBase, 1), 1), length(names{ii})); % baseline
    
%     % save data with each trials for each participant
%     if howMany>0 % delete the later trials, only for the experiment data
%         conditionNames = {'flashOnset', 'flashDisplaceLeft', 'initialDirection'};
%         for jj = 1:size(conditionNames, 2)
%             eval(['cons{jj} = unique(roundn(dataRaw.', conditionNames{jj}, ', roundN));']) % experiment
%         end
%         comb = cons{1};
%         nextConIdx = 2;
%         while nextConIdx<=size(conditionNames, 2)
%             comb = genCombinations(comb, cons{nextConIdx});
%             nextConIdx = nextConIdx+1;
%         end
%         
%         for tt = 1:size(comb, 1)
%             idxAll = 1:size(dataRaw, 1);
%             for aa = 1:size(comb, 2)
%                 eval(['idx = find(roundn(dataRaw.', conditionNames{aa}, ', roundN)==', num2str(comb(tt, aa)), ');'])
%                 idxAll = intersect(idxAll, idx); % all the indices for this condition
%             end
%             %             length(idxAll)
%             dataRaw(idxAll(howMany+1:end), :) = []; % delete the trials
%         end
%         
%         save(['dataRaw', num2str(2*howMany), '_', names{ii}], 'dataRaw') % experiment
%     else
        save(['dataRaw_', names{ii}], 'dataRaw') % experiment
%     end
    save(['dataRawBase_', names{ii}], 'dataRawBase') % baseline
    
    % collapse all data
    if ii==1
        dataRawAll = dataRaw; % experiment
        dataRawBaseAll = dataRawBase; % baseline
    else
        dataRawAll = [dataRawAll; dataRaw]; % experiment
        dataRawBaseAll = [dataRawBaseAll; dataRawBase]; % baseline
    end
    
end
save(['dataRaw_all', num2str(size(names, 2))], 'dataRawAll')
save(['dataRawBase_all', num2str(size(names, 2))], 'dataRawBaseAll')