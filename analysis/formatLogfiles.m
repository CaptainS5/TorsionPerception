% function formatLogfiles
% regenerate the log files from .mat into .txt, so that can be used
% when processing Chronos data

% 07/03/2018 Xiuyun Wu
clear all; close all; clc

% basic setting
% names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
% names = {'XWcontrolTest' 'XWcontrolTest2' 'XWcontrolTest3'};
% names = {'SDcontrol' 'MScontrol' 'KTcontrol' 'JGcontrol' 'APcontrol' 'RTcontrol' 'FScontrol' 'XWcontrol' 'SCcontrol' 'JFcontrol'};
names = {'XW3' 'DC3' 'AR3' 'JF3'};
folder = pwd;
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
% % for Exp1
% expTpB = 60; % trial per block in the experiment
% baseTpB = 50; % trial per block in baseline
% % for Exp2
% expTpB = 48; % trial per block in the experiment
% baseTpB = 48; % trial per block in baseline
% for Exp3
expTpB = 40; % trial per block in the experiment
baseTpB = 40; % trial per block in baseline

for ii = 1:size(names, 2)
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
        while size(resp, 1)<expTpB % not regenerating log files for invalid blocks
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
        delete(filePath)
        fileID = fopen(filePath, 'a');
        % print headers
        fprintf(fileID, ['ExperimentID: 3\n']);
        fprintf(fileID, ['SubjectID: ' num2str(ii) '\n']);
        fprintf(fileID, ['Block: ' blockNstr '\n']);
        fprintf(fileID, ['TrialPerBlock: ' num2str(expTpB) '\n']);
        fprintf(fileID, datestr(now, 'yyyy_mmmm_dd_HH:MM:SS.FFF\n'));
        %         for Exp3
        fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s\n',...
            resp.Properties.VariableNames{:});
        % %         for Exp1
        %                     fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s \n',...
        %                         resp.Properties.VariableNames{:});
        %         % for Exp2
        %         fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s \n',...
        %             resp.Properties.VariableNames{:});
        
        for tt = 1:size(resp, 1)
            % print trial data
            % for Exp3
            %             if resp.rotationSpeed(tt)~=0
            fprintf(fileID, '%0.3f %0.2f %0.3f %0.2f %0.3f %d %0.2f %0.2f %0.3f %0.3f %0.2f %d %d\n',...
                resp{tt, 1:end});
            %             end
            %             % for Exp1
            %             fprintf(fileID, '%0.3f %0.2f %0.3f %0.2f %0.3f %d %0.2f %0.2f %0.3f %0.3f %0.2f \n',...
            %                     resp{tt, 1:end});
            %             % for Exp2
            %             fprintf(fileID, '%0.3f %0.2f %0.3f %0.2f %0.3f %d %d %0.2f %0.2f %0.2f %0.2f %0.3f %0.3f %0.2f \n',...
            %                 resp{tt, 1:end});
        end
        
        fclose(fileID);
        
        jj = jj+1;
    end
    
    %% Baseline data
    cd(['baselineTorsion'])
    % get the filenames to load
    fileResp = dir('response*.mat');
    fileResp = struct2cell(fileResp);
    % for each block, regenerate the file
    jj = 1;
    while jj <= size(fileResp, 2)
        load(fileResp{1, jj})
        while size(resp, 1)<baseTpB % not regenerating log files for invalid blocks
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
        delete(filePath)
        fileID = fopen(filePath, 'a');
        % print headers
        fprintf(fileID, ['ExperimentID: 0\n']);
        fprintf(fileID, ['SubjectID: ' num2str(ii) '\n']);
        fprintf(fileID, ['Block: ' blockNstr '\n']);
        fprintf(fileID, ['TrialPerBlock: ' num2str(baseTpB) '\n']);
        fprintf(fileID, datestr(now, 'yyyy_mmmm_dd_HH:MM:SS.FFF\n'));
        % %             for Exp1
        %                         fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s \n',...
        %                             resp.Properties.VariableNames{:});
        %             % for Exp2
        %             fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s \n',...
        %                 resp.Properties.VariableNames{:});
        % for Exp3
        fprintf(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s\n',...
            resp.Properties.VariableNames{:});
        
        for tt = 1:size(resp, 1)
            % print trial data
            %                 % for Exp1
            %                 fprintf(fileID, '%0.3f %0.2f %0.3f %0.2f %0.3f %d %0.2f %0.2f %0.3f %0.3f %0.2f \n',...
            %                     resp{tt, 1:end});
            %                 % for Exp2
            %                 fprintf(fileID, '%0.3f %0.2f %0.3f %0.2f %0.3f %d %d %0.2f %0.2f %0.2f %0.2f %0.3f %0.3f %0.2f \n',...
            %                     resp{tt, 1:end});
            % for Exp3
            fprintf(fileID, '%0.3f %0.2f %0.3f %0.2f %0.3f %d %0.2f %0.2f %0.3f %0.3f %0.2f %d %d \n',...
                resp{tt, 1:end});
        end
        fclose(fileID);
        
        jj = jj+1;
    end
end

