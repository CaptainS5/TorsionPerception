% function formatLogfiles
% regenerate the log files from .mat into .txt, so that can be used
% when processing Chronos data

% 11/15/2017 Xiuyun Wu
clear all; close all; clc

% basic setting
names = {'JL' 'RD' 'KK'};
folder = pwd;
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot

for ii = 3:size(names, 2)
    % Read all raw data
    cd(folder)
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
        while size(resp, 1)<60 % not regenerating log files for invalid blocks
            jj = jj+1;
            if jj<=size(fileResp, 2)
                load(fileResp{1, jj})
            end
        end
        if strcmp(fileResp{1, jj}(10), '_')
            blockNstr = ['0' fileResp{1, jj}(9)];
            fileResp{1, jj} = [fileResp{1, jj}(1:8) '0' fileResp{1, jj}(9:end)];
        else
            blockNstr = fileResp{1, jj}(9:10);
        end
        
        fileName = fileResp{1, jj}(1:(11+size(names{ii}, 2)));
        filePath = fullfile(pwd, fileName);
        fileID = fopen(filePath, 'a');
        % print headers
        fprintf(fileID, ['ExperimentID: 0\n']);
        fprintf(fileID, ['SubjectID: ' num2str(ii) '\n']);
        fprintf(fileID, ['Experiment: ' blockNstr '\n']);
        fprintf(fileID, datestr(now, 'yyyy_mmmm_dd_HH:MM:SS.FFF\n'));
        fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s \n',...
            resp.Properties.VariableNames{:});
        
        for tt = 1:size(resp, 1) 
        % print trial data
        fprintf(fileID, '%0.3f %0.2f %0.3f %0.2f %0.3f %d %0.2f %0.2f %0.3f %0.3f %0.2f \n',...
            resp{tt, 1:end});        
        end
        fclose(fileID);
        
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

