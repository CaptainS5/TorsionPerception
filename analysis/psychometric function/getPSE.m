% function getPSE
% Calculate psychometric function for each flash onset, initial
% direction merged
% Then save the data, and draw the plots

% 10/13/2017, Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc

% basic setting
names = {'XW2'};
conditionNames = {'flashOnset', 'flashDisplaceLeft', 'initialDirection'}; % which conditions are different
merged = 0; % whether initial direction is merged; 1=merged
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot

% load raw data collapsed
cd ..
load(['dataRaw_all', num2str(size(names, 2))])
% back into the folder
cd('psychometric function')

dataPMFall = table();
for ii = 1:size(names, 2)
    % initialize data points for the psychometric function
    dataPMF = table();
    
    % locate data for each individual
    idx = find(strcmp(dataRawAll.sub, names{ii}));
    dataRaw = dataRawAll(idx,:);
    % get the levels of each condition
    for jj = 1:size(conditionNames, 2)
        eval(['cons{jj} = unique(roundn(dataRaw.', conditionNames{jj}, ', roundN));']) 
    end
    
    tempI = 1; % index to add into the table of dataPMF
    
    onsetIdx = find(strcmp(conditionNames, 'flashOnset'));
    for jj = 1:length(cons{onsetIdx}) % each flash onset interval
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
        
        if merged==1
            %         draw plots for each flash onset, initial direction merged
            idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj));
            dataPlot = dataPMF(idx, :);
            figure
            scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
            ylim([0, 1])
            xlabel('Flash Displacement (left-right, dva)')
            ylabel('Percentage of perceived left to be lower')
            title(['flash onset ', num2str(12*cons{onsetIdx}(jj)), ' s'])
            saveas(gca, [names{ii}, '_merged_onset', num2str(12*cons{onsetIdx}(jj)), '.pdf'])
        else
            % draw plots for each flash onset, initial direction not merged
            figure
            
            subplot(1, 2, 1)            
            idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj) & dataPMF.initialDirection==1);
            dataPlot = dataPMF(idx, :);
            
            scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
            ylim([0, 1])
            xlabel('Flash Displacement (left-right, dva)')
            ylabel('Percentage of perceived left to be lower')
            title(['initial clockwise'])
            
            subplot(1, 2, 2)
            idx = find(dataPMF.flashOnset==cons{onsetIdx}(jj) & dataPMF.initialDirection==-1);
            dataPlot = dataPMF(idx, :);
            
            scatter(dataPlot.flashDisplaceLeft, dataPlot.percentLeftLower, 'filled');
            ylim([0, 1])
            xlabel('Flash Displacement (left-right, dva)')
            ylabel('Percentage of perceived left to be lower')
            title(['initial counterclockwise'])
            
            saveas(gca, [names{ii}, '_notMerged_onset', num2str(cons{onsetIdx}(jj)), '.pdf'])
        end
    end
    if merged==1
        save(['dataPMFmerged_', names{ii}], 'dataPMF')
    else
        save(['dataPMFnotMerged_', names{ii}], 'dataPMF')
    end
    
    % collapse data
    if ii==1
        dataPMFall = dataPMF;
    else
        dataPMFall = [dataPMFall; dataPMF];
    end
end
if merged==1
    save(['dataPMFmerged_all', num2str(size(names, 2))], 'dataPMFall')
else
    save(['dataPMFnotMerged_all', num2str(size(names, 2))], 'dataPMFall')
end

% end