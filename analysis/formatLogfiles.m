% function formatLogfiles
% regenerate the log files from .mat into .txt, so that can be used
% when processing Chronos data

% 11/15/2017 Xiuyun Wu
clear all; close all; clc

% basic setting
names = {'XWp0'};
folder = pwd;
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot

for ii = 1:size(names, 2)
    % Read all raw data
    cd ..
    %% Experiment data
    cd(['data\', names{ii}])
    % get the filenames to load
    fileResp = dir('response*.mat');
    fileResp = struct2cell(fileResp);
    % for each block, regenerate the file
    jj = 1;
    while jj <= size(fileResp, 2)
        load(fileResp{1, jj})
        while size(resp, 1)<70 % not regenerating log files for invalid blocks
            jj = jj+1;
            if jj<=size(fileResp, 2)
                load(fileResp{1, jj})
            end
        end
        jj = jj+1;
    end
    
    %% Baseline data
%     cd(['baseline'])
%     % get the filenames to load
%     fileResp = dir('response*.mat');
%     fileResp = struct2cell(fileResp);
%         
%     cd ..    
end

