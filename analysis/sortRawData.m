% function sortRawData
% Sorting raw data into long format
% Merged different initial directions into clockwise: 
% clockwise right side = counterclockwise left side.
% Under clockwise direction, positive=perceived left lower 
% (initialDirection*reportStyle*choice)

% 10/13/2017 Xiuyun Wu
clear all; close all; clc

% basic setting
names = {'XW2'};

dataRawAll = table();
for ii = 1:size(names, 2)
    % read all raw data
    cd ..
    cd(['data\', names{ii}])
    % get the filenames to load
    fileResp = dir('response*.mat');
    fileResp = struct2cell(fileResp);
    % load raw data into dataRawAll
    dataRaw = table();
    for jj = 1:size(fileResp, 2)
        load(fileResp{1, jj})
%         % for initial pilots... still adjusting experimental codes...
%         resp = resp{1, size(resp, 2)};
        
        % regular processing below, first putting all data together
        if jj==1
            dataRaw = resp;
        else
            dataRaw = [dataRaw; resp];
        end
    end
    
    % go to the analysis file to save the processed data
    cd ..
    cd ..
    cd('analysis')
    % delete invalid trials
    dataRaw(dataRaw.choice==0, :) = [];
    dataRaw.sub = mat2cell(repmat(names{ii}, size(dataRaw, 1), 1), ones(size(dataRaw, 1), 1), length(names{ii}));
    
%     % ONLY for the initial pilot...leftArrow=1, rightArrow=2; reportStyle = -1;
%     dataRaw.reportStyle = repmat([-1], size(dataRaw, 1), 1);
%     dataRaw.flashDisplaceLeft = dataRaw.flashDisplaceLeft*-1;
%     dataRaw.choice(dataRaw.choice==1) = -1; % choose left
%     dataRaw.choice(dataRaw.choice==2) = 1; % choose right
    %
    dataRaw.perceivedLower = dataRaw.initialDirection.*dataRaw.reportStyle.*dataRaw.choice; % perception of the side being lower
    % 1: left lower; -1: right lower
    % this is merged direction, all initial direction assumed to be
    % clockwise
    
    dataRaw.perceivedLowerNotMerged = dataRaw.reportStyle.*dataRaw.choice; % perception of the side being lower
    % initial direction not merged, 1: left lower; -1: right lower
    
    % save data with each trials for each participant
    save(['dataRaw_', names{ii}], 'dataRaw')
    
    % collapse all data
    if ii==1
        dataRawAll = dataRaw;
    else
        dataRawAll = [dataRawAll; dataRaw];
    end
end

save(['dataRaw_all', num2str(size(names, 2))], 'dataRawAll')
% end