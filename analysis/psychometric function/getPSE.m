% function getPSE
% Calculate psychometric function for each flash onset, including
% experiment and baseline data
% Then save the data, and draw the plots

% 10/24/2017, Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc
folder = pwd;

% basic setting
names = {'XW2' 'NI'};
conditionNames = {'flashOnset', 'flashDisplaceLeft', 'initialDirection'}; % which conditions are different
merged = 0; % whether initial direction is merged; 1=merged
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
myfittype = fittype('a*(1-exp(-s*(x-ic)))', 'independent', 'x');
% myfittype = fittype('a*(1-exp(-(x/lambda).^(k)))', 'independent', 'x');
loadData = 0; % whether get new fitting or using existing fitting

% % load raw data collapsed
% cd ..
% load(['dataRaw_all', num2str(size(names, 2))])
% load(['dataRawBase_all', num2str(size(names, 2))])
% % back into the folder
% cd(folder)

dataPMFall = table(); % experiment
dataPMFbaseAll = table(); % baseline
for ii = 1:1%size(names, 2)
    % load raw data for each participant
    cd ..
    load(['dataRaw_', names{ii}])
    load(['dataRawBase_', names{ii}])
    % back into the folder
    cd(folder)
    
    if loadData==0
        % initialize data points for the psychometric function
        dataPMF = table(); % experiment
        dataPMFbase = table(); % baseline
    else
        if merged==1
            load(['dataPMFmerged_', names{ii}]) % experiment
            load(['dataPMFbaseMerged_', names{ii}]) % baseline
        else
            load(['dataPMFnotMerged_', names{ii}]) % experiment
            load(['dataPMFbaseNotMerged_', names{ii}]) % baseline
        end
    end
    
    %     % locate data for each individual
    %     idx = find(strcmp(dataRawAll.sub, names{ii}));
    %     dataRaw = dataRawAll(idx,:); % experiment
    %     idx = find(strcmp(dataRawBaseAll.sub, names{ii}));
    %     dataRawBase = dataRawBaseAll(idx,:); % baseline
    % get the levels of each condition
    for jj = 1:size(conditionNames, 2)
        eval(['cons{jj} = unique(roundn(dataRaw.', conditionNames{jj}, ', roundN));']) % experiment
        eval(['consBase{jj} = unique(roundn(dataRawBase.', conditionNames{jj}, ', roundN));']) % baseline
    end
    xFit = min(unique(dataRaw.flashDisplaceLeft)):0.01:max(unique(dataRaw.flashDisplaceLeft));
    xFitBase = min(unique(dataRawBase.flashDisplaceLeft)):0.01:max(unique(dataRawBase.flashDisplaceLeft));
    
    %% Experiment data, flash onset is important
    tempI = 1; % index to add into the table of dataPMF
    
    onsetIdx = find(strcmp(conditionNames, 'flashOnset'));
    for jj = 1:length(cons{onsetIdx}) % each flash onset interval
        if loadData==0
            idx = find(roundn(dataRaw.flashOnset, roundN)==cons{onsetIdx}(jj));
            dataOnset = dataRaw(idx, :); % data of this flash onset
            
            comb = cons{2};
            nextConIdx = 3;
            while nextConIdx<=size(conditionNames, 2)
                comb = genCombinations(comb, cons{nextConIdx});
                nextConIdx = nextConIdx+1;
            end
            
            for tt = 1:size(comb, 1)
                dataPMF.sub(tempI, 1) = names(ii);
                dataPMF.flashOnset(tempI, 1) = cons{onsetIdx}(jj);
                idxAll = 1:size(dataOnset, 1);
                for aa = 1:size(comb, 2)
                    eval(['dataPMF.', conditionNames{aa+1}, '(tempI, 1) = ', num2str(comb(tt, aa)), ';'])
                    eval(['idx = find(roundn(dataOnset.', conditionNames{aa+1}, ', roundN)==', num2str(comb(tt, aa)), ');'])
                    idxAll = intersect(idxAll, idx);
                end
                if merged==1
                    idx = find(dataOnset.perceivedLower(idxAll)==1);
                else
                    idx = find(dataOnset.perceivedLowerNotMerged(idxAll)==1);
                end
                dataPMF.percentLeftLower(tempI, 1) = length(idx)/length(idxAll);
                
                tempI = tempI+1;
            end
        end
        % draw plots
        if merged==1 % modify later
            %             % draw plots for each flash onset, initial direction merged
            %             idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj));
            %             dataPlot = dataPMF(idx, :);
            %
            %             figure
            %             scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
            %             ylim([0, 1])
            %             xlabel('Flash Displacement (left-right, dva)')
            %             ylabel('Percentage of following current motion')
            %             title(['flash onset ', num2str(12*cons{onsetIdx}(jj)), ' s'])
            %             saveas(gca, [names{ii}, '_merged_onset', num2str(12*cons{onsetIdx}(jj)), '.pdf'])
        else
            % draw plots for each flash onset, initial direction not merged
            figure
            box off
            subplot(1, 2, 1) % initial clockwise
            idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj) & dataPMF.initialDirection==1);
            dataPlot = dataPMF(idx, :);
            [fitObj{jj, 1} gof{jj, 1}]= fit(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, myfittype);
            
            % raw data
            scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
            hold on
            % fitted line
            plot(xFit, fitObj{jj, 1}.a*(1-exp(-fitObj{jj, 1}.s*(xFit-fitObj{jj, 1}.ic))), '-k')
            %             plot(xFit, fitObj{jj, 1}.a*(1-exp(-(xFit/fitObj{jj, 1}.lambda).^fitObj{jj, 1}.k)), '-k')
            % get the PSE
            PSE(jj, 1) = log(1-0.5/fitObj{jj, 1}.a)/(-fitObj{jj, 1}.s)+fitObj{jj, 1}.ic;
            
            ylim([0, 1])
            xlabel('Flash Displacement (left-right, dva)')
            ylabel('Percentage of perceived left to be lower')
            title([num2str(cons{onsetIdx}(jj)), 's initial clockwise'])
            
            subplot(1, 2, 2) % initial counterclockwise
            idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj) & dataPMF.initialDirection==-1);
            dataPlot = dataPMF(idx, :);
            [fitObj{jj, 2} gof{jj, 2}]= fit(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, myfittype);
            
            % raw data
            scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
            hold on
            % fitted line
            plot(xFit, fitObj{jj, 2}.a*(1-exp(-fitObj{jj, 2}.s*(xFit-fitObj{jj, 2}.ic))), '-k')
            % plot(xFit, fitObj{jj, 2}.a*(1-exp(-(xFit/fitObj{jj, 2}.lambda).^fitObj{jj, 2}.k)), '-k')
            
            % get the PSE
            PSE(jj, 2) = log(1-0.5/fitObj{jj, 2}.a)/(-fitObj{jj, 2}.s)+fitObj{jj, 2}.ic;
            
            ylim([0, 1])
            xlabel('Flash Displacement (left-right, dva)')
            ylabel('Percentage of perceived left to be lower')
            title([num2str(cons{onsetIdx}(jj)), 's initial counterclockwise'])
            
            saveas(gca, [names{ii}, '_notMerged_onset', num2str(cons{onsetIdx}(jj)), '_fit.pdf'])
        end
    end
    
    %% Baseline data, flash onset was not important and merged
    if loadData==0
        tempI = 1; % index to add into the table of dataPMFbase
        
        comb = consBase{2};
        for tt = 1:size(comb, 1)
            dataPMFbase.sub(tempI, 1) = names(ii);
            idxAll = 1:size(dataRawBase, 1);
            for aa = 1:size(comb, 2)
                eval(['dataPMFbase.', conditionNames{aa+1}, '(tempI, 1) = ', num2str(comb(tt, aa)), ';'])
                eval(['idx = find(roundn(dataRawBase.', conditionNames{aa+1}, ', roundN)==', num2str(comb(tt, aa)), ');'])
                idxAll = intersect(idxAll, idx);
            end
            if merged==1
                idx = find(dataRawBase.perceivedLower(idxAll)==1);
            else
                idx = find(dataRawBase.perceivedLowerNotMerged(idxAll)==1);
            end
            dataPMFbase.percentLeftLower(tempI, 1) = length(idx)/length(idxAll);
            
            tempI = tempI+1;
        end
    end
    
    % draw plots
    if merged==1 % modify later
        %             % draw plots for each flash onset, initial direction merged
        %             idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj));
        %             dataPlot = dataPMF(idx, :);
        %
        %             figure
        %             scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
        %             ylim([0, 1])
        %             xlabel('Flash Displacement (left-right, dva)')
        %             ylabel('Percentage of following current motion')
        %             title(['flash onset ', num2str(12*cons{onsetIdx}(jj)), ' s'])
        %             saveas(gca, [names{ii}, '_merged_onset', num2str(12*cons{onsetIdx}(jj)), '.pdf'])
    else
        % draw plots for each flash onset, initial direction not merged
        figure
        box off
        dataPlot = dataPMFbase;
        [fitObjBase gofBase]= fit(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, myfittype);
        
        % raw data
        scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
        hold on
        % fitted line
        plot(xFitBase, fitObjBase.a*(1-exp(-fitObjBase.s*(xFitBase-fitObjBase.ic))), '-k')
        %         plot(xFit, fitObjBase.a*(1-exp(-(xFit/fitObjBase.lambda).^fitObjBase.k)), '-k')
        % get the PSE
        PSEbase = log(1-0.5/fitObjBase.a)/(-fitObjBase.s)+fitObjBase.ic;
        
        ylim([0, 1])
        xlabel('Flash Displacement (left-right, dva)')
        ylabel('Percentage of perceived left to be lower')
        title(['PSE=', num2str(PSEbase(1))])
        
        saveas(gca, [names{ii}, '_notMerged_baseline_fit.pdf'])
    end
    
    % plot for the fitted PSE of the experiment
    figure
    box off
    plot(cons{onsetIdx}, PSE(:, 1), '-b')
    hold on
    plot(cons{onsetIdx}, PSE(:, 2), '-r')
    plot(cons{onsetIdx}, repmat(PSEbase, size(cons{onsetIdx})), '--k')
    legend({'Initial clockwise', 'Initial counterclockwise', 'baseline'}, 'box', 'off', 'Location', 'northwest')
    xlabel('Flash Onset (s)')
    ylabel('Point of subjective equality, left-right')
    saveas(gca, [names{ii}, '_notMerged_PSE.pdf'])
    
    if loadData==0
        if merged==1
            save(['dataPMFmerged_', names{ii}], 'dataPMF', 'fitObj', 'gof', 'PSE') % experiment
            save(['dataPMFbaseMerged_', names{ii}], 'dataPMFbase', 'fitObjBase', 'gofBase', 'PSEbase') % baseline
        else
            save(['dataPMFnotMerged_', names{ii}], 'dataPMF', 'fitObj', 'gof', 'PSE') % experiment
            save(['dataPMFbaseNotMerged_', names{ii}], 'dataPMFbase', 'fitObjBase', 'gofBase', 'PSEbase') % baseline
        end
    end
    %
    %     % collapse data
    %     if ii==1
    %         dataPMFall = dataPMF; % experiment
    %         dataPMFbaseAll = dataPMFbase; % baseline
    %     else
    %         dataPMFall = [dataPMFall; dataPMF]; % experiment
    %         dataPMFbaseAll = [dataPMFbaseAll; dataPMFbase];  % baseline
    %     end
end
% % collapsed data
% if merged==1
%     save(['dataPMFmerged_all', num2str(size(names, 2))], 'dataPMFall') % experiment
%     save(['dataPMFbaseMerged_all', num2str(size(names, 2))], 'dataPMFbaseAll') % baseline
% else
%     save(['dataPMFnotMerged_all', num2str(size(names, 2))], 'dataPMFall') % experiment
%     save(['dataPMFbaseNotMerged_all', num2str(size(names, 2))], 'dataPMFbaseAll') % baseline
% end