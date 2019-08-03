% tree plot of the effects of trial history...

%% Old data, Experiment 2, for anticipatory torsion
initializeParas;
cd(analysisFolder)
individualPlots = 1;
averagedPlots = 1;

load('torsionAnt_exp16') % anticipatory torsion
% to reconstruct trial order? read in log files first
logFiles = dir("subject*log.txt");
for subN = 1:size(logFiles, 1)
    fid = fopen(logFiles(subN).name);
    %skip 5 lines
    textscan(fid, '%*[^\n]', 5);
    allData = textscan(fid, '%d %d %d %d %f %d %f %f %f %f %f %f %d %f %*[^\n]', 600);
    log.translationalDir{subN} = allData{3}; % 0 = right, 1 = left
    log.rotationalDir{subN} = allData{4}; % 0 = no rotation, -1 = unnatural, 1 = natural
    fclose('all');
end

% use the same structure as the data, one for trial idx
trialIdx = NaN(200, 3, 12);
rotationalD = [ones(200, 1), -ones(200, 1), zeros(200, 1)];

for subN = 1:size(logFiles, 1)
    naI = 1; % index for natural, first column
    unI = 1; % index for unnatural, second column
    nrI = 1; % index for no rotation, third column
    for tI = 1:size(log.rotationalDir{subN}, 1)
        if ~isnan(torsionAnt(tI)) % if the trial is valid
            switch log.rotationalDir{subN}(tI)
                case 0
                    trialIdx(nrI, 3, subN) = tI;
                    nrI = nrI+1;
                case -1
                    trialIdx(unI, 2, subN) = tI;
                    unI = unI+1;
                case 1
                    trialIdx(naI, 1, subN) = tI;
                    naI = naI+1;
            end
        end
    end
    
    % calculate the nodes
    for dirN = 1:2 % natural and unnatural
        if dirN==1 % unnatural rotation
            dirIdx = find(rotationalD==-1);
        else % natural rotation
            dirIdx = find(rotationalD==1);
        end
        
        [lastT lastTstd idxOutL{dirN, subN}] = splitNode(trialIdx(:, :, subN), rotationalD, [-1 1], torsionAnt(:, :, subN), dirIdx, 1);
        
        [firstT(1:2, :) firstTstd(1:2, :) idxOutFd{dirN, subN}]= splitNode(trialIdx(:, :, subN), rotationalD, [-1 1], torsionAnt(:, :, subN), idxOutL{dirN, subN}{1}, 2); % different previous
        [firstT(3:4, :) firstTstd(3:4, :) idxOutFs{dirN, subN}]= splitNode(trialIdx(:, :, subN), rotationalD, [-1 1], torsionAnt(:, :, subN), idxOutL{dirN, subN}{2}, 2); % same previous
        
        treeNodesT{dirN, 1}(subN, 1:4) = firstT(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
        treeNodesT{dirN, 2}(subN, 1:2) = lastT(1:2, 1)'; % the second column, two nodes, n-1, diff, same
        treeNodesT{dirN, 3}(subN, 1) = lastT(1, 2); % the third column, 1 node, mean of all
        
        [nodesTmeanSub{dirN, subN}] = ...
            sortForPlot({treeNodesT{dirN, 1}(subN, :) treeNodesT{dirN, 2}(subN, :) treeNodesT{dirN, 3}(subN, :)}, 1, 2); % torsion
    end
    %% plots of individual data
    if individualPlots==1
        % torsion plots
        cd([torsionFolder '\individuals'])
        % anticipatory torsion
        drawPlot(subN, nodesTmeanSub, [], 'Trial', 'Anticipatory torsion velocity (deg/s)', {'natural' 'unnatural'}, 'anticipatoryTExp2_trialHistory_', ['s' num2str(subN)], [])
 
        %             close all
    end
end

% generate the lines for averaged data
for dirN = 1:size(trialTypeCons, 2)
    [nodesTmean{dirN, 1} nodesTste{dirN, 1}] = sortForPlot({treeNodesT{dirN, 1} treeNodesT{dirN, 2} treeNodesT{dirN, 3}}, sqrt(size(logFiles, 1)), 2); % torsion
end
% averaged plots
if averagedPlots==1
    % torsion plots
    cd(torsionFolder)
    % anticipatory torsion
    drawPlot(1, nodesTmean, nodesTste, 'Trial', 'Anticipatory torsion velocity (deg/s)', {'natural' 'unnatural'}, 'anticipatoryTExp2_trialHistory_', 'all', [])
end

%% New data, Experiment 3 (control)
initializeParas;
individualPlots = 1;
averagedPlots = 1;

% % first, flip all directions to left (positive)
% idxT = find(trialData.translationalDirection==1); % all right moving trials
% trialData.anticipatoryPursuitHVel(idxT) = -trialData.anticipatoryPursuitHVel(idxT);
% trialData.anticipatoryTorsionVel(idxT) = -trialData.anticipatoryTorsionVel(idxT);

%% Control experiment
for dirN = 1:2
    for subN = 1:size(names, 2)
        %% Eye velocity bar plots
        % anticipatory torsion/pursuit, right minus left moving trials
        % rows are subs, first column is baseline, second column is exp trials
        for trialTypeI = 1:size(trialTypeCons, 2)
            data = trialData(trialData.sub==subN & trialData.trialType==trialTypeCons(trialTypeI), :);  % select all trials in the block
            dirIdx = find(data.translationalDirection==transDirCons(dirN)); % only use trials in a certain direction
            [lastP lastPstd idxOutL{trialTypeI, subN}] = splitNode(data.trial, data.translationalDirection, [-1 1], data.anticipatoryPursuitHVel, dirIdx, 1); % the last two nodes in the tree plot
            [lastT lastTstd] = splitNode(data.trial, data.translationalDirection, [-1 1], data.anticipatoryTorsionVel, dirIdx, 1);
            
            [firstP(1:2, :) firstPstd(1:2, :) idxOutFd{trialTypeI, subN}]= splitNode(data.trial, data.translationalDirection, [-1 1], data.anticipatoryPursuitHVel, idxOutL{trialTypeI, subN}{1}, 2); % different previous
            [firstP(3:4, :) firstPstd(3:4, :) idxOutFs{trialTypeI, subN}]= splitNode(data.trial, data.translationalDirection, [-1 1], data.anticipatoryPursuitHVel, idxOutL{trialTypeI, subN}{2}, 2); % same previous
            [firstT(1:2, :) firstTstd(1:2, :)]= splitNode(data.trial, data.translationalDirection, [-1 1], data.anticipatoryTorsionVel, idxOutL{trialTypeI, subN}{1}, 2); % different previous
            [firstT(3:4, :) firstTstd(3:4, :)]= splitNode(data.trial, data.translationalDirection, [-1 1], data.anticipatoryTorsionVel, idxOutL{trialTypeI, subN}{2}, 2); % same previous
            treeNodesP{trialTypeI, 1}(subN, 1:4) = firstP(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
            treeNodesP{trialTypeI, 2}(subN, 1:2) = lastP(1:2, 1)'; % the second column, two nodes, n-1, diff, same
            treeNodesP{trialTypeI, 3}(subN, 1) = lastP(1, 2); % the third column, 1 node, mean of all
            treeNodesT{trialTypeI, 1}(subN, 1:4) = firstT(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
            treeNodesT{trialTypeI, 2}(subN, 1:2) = lastT(1:2, 1)'; % the second column, two nodes, n-1, diff, same
            treeNodesT{trialTypeI, 3}(subN, 1) = lastT(1, 2); % the third column, 1 node, mean of all
            
            % check for number of trials...
            trialNumber{trialTypeI, 1}(subN, 1:2) = [length(idxOutFd{trialTypeI, subN}{1}), ...
                length(idxOutFd{trialTypeI, subN}{2})];
            trialNumber{trialTypeI, 1}(subN, 3:4) = [length(idxOutFs{trialTypeI, subN}{1}), ...
                length(idxOutFs{trialTypeI, subN}{2})];
            trialNumber{trialTypeI, 2}(subN, 1:2) = [length(idxOutL{trialTypeI, subN}{1}), ...
                length(idxOutL{trialTypeI, subN}{2})];
            trialNumber{trialTypeI, 3}(subN, 1) = size(data, 1);
            %
            %             % check for the proportion of left trials in each bin...
            %             leftRate{trialTypeI, 1}(subN, 1:2) = [length(find(data.translationalDirection(idxOutFd{trialTypeI, subN}{1})==-1))/length(idxOutFd{trialTypeI, subN}{1}), ...
            %                 length(find(data.translationalDirection(idxOutFd{trialTypeI, subN}{2})==-1))/length(idxOutFd{trialTypeI, subN}{2})];
            %             leftRate{trialTypeI, 1}(subN, 3:4) = [length(find(data.translationalDirection(idxOutFs{trialTypeI, subN}{1})==-1))/length(idxOutFs{trialTypeI, subN}{1}), ...
            %                 length(find(data.translationalDirection(idxOutFs{trialTypeI, subN}{2})==-1))/length(idxOutFs{trialTypeI, subN}{2})];
            %             leftRate{trialTypeI, 2}(subN, 1:2) = [length(find(data.translationalDirection(idxOutL{trialTypeI, subN}{1})==-1))/length(idxOutL{trialTypeI, subN}{1}), ...
            %                 length(find(data.translationalDirection(idxOutL{trialTypeI, subN}{2})==-1))/length(idxOutL{trialTypeI, subN}{2})];
            %             leftRate{trialTypeI, 3}(subN, 1) = length(find(data.translationalDirection==-1))/size(dirIdx, 1);
            
            [nodesPmeanSub{trialTypeI, subN}] = ...
                sortForPlot({treeNodesP{trialTypeI, 1}(subN, :) treeNodesP{trialTypeI, 2}(subN, :) treeNodesP{trialTypeI, 3}(subN, :)}, 1, 2); % pursuit
            [nodesTmeanSub{trialTypeI, subN}] = ...
                sortForPlot({treeNodesT{trialTypeI, 1}(subN, :) treeNodesT{trialTypeI, 2}(subN, :) treeNodesT{trialTypeI, 3}(subN, :)}, 1, 2); % torsion
            [nodesTNmeanSub{trialTypeI, subN}] = ...
                sortForPlot({trialNumber{trialTypeI, 1}(subN, :) trialNumber{trialTypeI, 2}(subN, :) trialNumber{trialTypeI, 3}(subN, :)}, 1, 2); % trial number
            %             [nodesLRmeanSub{trialTypeI, subN}] = ...
            %                 sortForPlot({leftRate{trialTypeI, 1}(subN, :) leftRate{trialTypeI, 2}(subN, :) leftRate{trialTypeI, 3}(subN, :)}, 1); % proportion of left moving trials
        end
        
        %% plots of individual data
        if individualPlots==1
            % torsion plots
            cd([torsionFolder '\individuals'])
            % anticipatory torsion
            figure
            for trialTypeI = 1:2
                subplot(2, 1, trialTypeI)
                hold on
                % dashed--different direction
                p{1} = plot([1 2 3], nodesTmeanSub{trialTypeI, subN}(1, :)', '--k');
                plot([1 2], nodesTmeanSub{trialTypeI, subN}(2, 1:2)', '-k')
                plot([1 2], nodesTmeanSub{trialTypeI, subN}(3, 1:2)', '--k')
                p{2} = plot([1 2 3], nodesTmeanSub{trialTypeI, subN}(4, :)', '-ok');
                % circle dot--same direction
                plot([1], nodesTmeanSub{trialTypeI, subN}(2, 1)', 'ok')
                plot([2], nodesTmeanSub{trialTypeI, subN}(3, 2)', 'ok')
                
                xlim([0.5, 3.5])
                title([trialTypeNames(trialTypeI) ', ', names{subN}, ', ', dirConNames{dirN}])
                legend([p{:}], {'different dir', 'same dir'}, 'location', 'best')
                set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
                xlabel('Trial')
                ylabel('Anticipatory torsion velocity (deg/s)')
                %     ylim([-1 0.6])
            end
            saveas(gca, ['anticipatoryT_trialHistory_' names{subN} '_' dirConNames{dirN} '.pdf'])
            
            % pursuit plots
            cd([pursuitFolder '\individuals'])
            % anticipatory pursuit
            figure
            for trialTypeI = 1:2
                subplot(2, 1, trialTypeI)
                hold on
                % dashed--different direction
                p{1} = plot([1 2 3], nodesPmeanSub{trialTypeI, subN}(1, :)', '--k');
                plot([1 2], nodesPmeanSub{trialTypeI, subN}(2, 1:2)', '-k')
                plot([1 2], nodesPmeanSub{trialTypeI, subN}(3, 1:2)', '--k')
                p{2} = plot([1 2 3], nodesPmeanSub{trialTypeI, subN}(4, :)', '-ok');
                % circle dot--same direction
                plot([1], nodesPmeanSub{trialTypeI, subN}(2, 1)', 'ok')
                plot([2], nodesPmeanSub{trialTypeI, subN}(3, 2)', 'ok')
                
                xlim([0.5, 3.5])
                title([trialTypeNames(trialTypeI) ', ', names{subN}, ', ', dirConNames{dirN}])
                legend([p{:}], {'different dir', 'same dir'}, 'location', 'best')
                set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
                xlabel('Trial')
                ylabel('Anticipatory pursuit horizontal velocity (deg/s)')
                %     ylim([-1 0.6])
            end
            saveas(gca, ['anticipatoryP_trialHistory_' names{subN} '_' dirConNames{dirN} '.pdf'])
            
            % trian number
            figure
            for trialTypeI = 1:2
                subplot(2, 1, trialTypeI)
                hold on
                % dashed--different direction
                p{1} = plot([1 2 3], nodesTNmeanSub{trialTypeI, subN}(1, :)', '--k');
                plot([1 2], nodesTNmeanSub{trialTypeI, subN}(2, 1:2)', '-k')
                plot([1 2], nodesTNmeanSub{trialTypeI, subN}(3, 1:2)', '--k')
                p{2} = plot([1 2 3], nodesTNmeanSub{trialTypeI, subN}(4, :)', '-ok');
                % circle dot--same direction
                plot([1], nodesTNmeanSub{trialTypeI, subN}(2, 1)', 'ok')
                plot([2], nodesTNmeanSub{trialTypeI, subN}(3, 2)', 'ok')
                
                xlim([0.5, 3.5])
                title([trialTypeNames(trialTypeI) ', ', names{subN}, ', ', dirConNames{dirN}])
                legend([p{:}], {'different dir', 'same dir'}, 'location', 'best')
                set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
                xlabel('Trial')
                ylabel('Number of trials')
                %     ylim([-1 0.6])
            end
            saveas(gca, ['trialHistory_trialNumber_' names{subN} '_' dirConNames{dirN} '.pdf'])
            
            %             % left trial proportion
            %             figure
            %             for trialTypeI = 1:2
            %                 subplot(2, 1, trialTypeI)
            %                 hold on
            %                 % dashed--different direction
            %                 p{1} = plot([1 2 3], nodesLRmeanSub{trialTypeI, subN}(1, :)', '--k');
            %                 plot([1 2], nodesLRmeanSub{trialTypeI, subN}(2, 1:2)', '-k')
            %                 plot([1 2], nodesLRmeanSub{trialTypeI, subN}(3, 1:2)', '--k')
            %                 p{2} = plot([1 2 3], nodesLRmeanSub{trialTypeI, subN}(4, :)', '-ok');
            %                 % circle dot--same direction
            %                 plot([1], nodesLRmeanSub{trialTypeI, subN}(2, 1)', 'ok')
            %                 plot([2], nodesLRmeanSub{trialTypeI, subN}(3, 2)', 'ok')
            %
            %                 xlim([0.5, 3.5])
            %                 title([names{subN}, ', ', dirConNames{dirN}])
            %                 legend([p{:}], {'different dir', 'same dir'}, 'location', 'best')
            %                 set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
            %                 xlabel('Trial')
            %                 ylabel('Proportion of left trials')
            %                 %     ylim([-1 0.6])
            %             end
            %             saveas(gca, ['trialHistory_leftProportion_' names{subN} '_' dirConNames{dirN} '.pdf'])
            
            close all
        end
    end
    
    % generate the lines for averaged data
    for trialTypeI = 1:size(trialTypeCons, 2)
        [nodesPmean{trialTypeI} nodesPste{trialTypeI}] = sortForPlot({treeNodesP{trialTypeI, 1} treeNodesP{trialTypeI, 2} treeNodesP{trialTypeI, 3}}, sqrt(size(names, 2)), 2); % pursuit
        [nodesTmean{trialTypeI} nodesTste{trialTypeI}] = sortForPlot({treeNodesT{trialTypeI, 1} treeNodesT{trialTypeI, 2} treeNodesT{trialTypeI, 3}}, sqrt(size(names, 2)), 2); % torsion
        [nodesTNmean{trialTypeI} nodesTNste{trialTypeI}] = sortForPlot({trialNumber{trialTypeI, 1} trialNumber{trialTypeI, 2} trialNumber{trialTypeI, 3}}, sqrt(size(names, 2)), 2); % trial number
        %         [nodesLRmean{trialTypeI} nodesLRste{trialTypeI}] = sortForPlot({leftRate{trialTypeI, 1} leftRate{trialTypeI, 2} leftRate{trialTypeI, 3}}, sqrt(size(names, 2))); % proportion of left moving trials
    end
    %% averaged plots
    if averagedPlots==1
        % torsion plots
        cd(torsionFolder)
        % anticipatory torsion
        figure
        for trialTypeI = 1:2
            subplot(2, 1, trialTypeI)
            hold on
            % dashed--different direction
            p{1} = errorbar([1 2 3], nodesTmean{trialTypeI}(1, :)', nodesTste{trialTypeI}(1, :)', '--k');
            errorbar([1 2], nodesTmean{trialTypeI}(2, 1:2)', nodesTste{trialTypeI}(2, 1:2)', '-k')
            errorbar([1 2], nodesTmean{trialTypeI}(3, 1:2)', nodesTste{trialTypeI}(3, 1:2)', '--k')
            p{2} = errorbar([1 2 3], nodesTmean{trialTypeI}(4, :)', nodesTste{trialTypeI}(4, :)', '-ok');
            % circle dot--same direction
            plot([1], nodesTmean{trialTypeI}(2, 1)', 'ok')
            plot([2], nodesTmean{trialTypeI}(3, 2)', 'ok')
            
            xlim([0.5, 3.5])
            title([trialTypeNames(trialTypeI) ' all, ' dirConNames{dirN}])
            legend([p{:}], {'different dir', 'same dir'}, 'location', 'best')
            set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
            xlabel('Trial')
            ylabel('Anticipatory torsion velocity (deg/s)')
            %     ylim([-1 0.6])
        end
        saveas(gca, ['anticipatoryT_trialHistory_all_' dirConNames{dirN} '.pdf'])
        
        % pursuit plots
        cd(pursuitFolder)
        % anticipatory pursuit
        figure
        for trialTypeI = 1:2
            subplot(2, 1, trialTypeI)
            hold on
            % dashed--different direction
            p{1} = errorbar([1 2 3], nodesPmean{trialTypeI}(1, :)', nodesPste{trialTypeI}(1, :)', '--k');
            errorbar([1 2], nodesPmean{trialTypeI}(2, 1:2)', nodesPste{trialTypeI}(2, 1:2)', '-k')
            errorbar([1 2], nodesPmean{trialTypeI}(3, 1:2)', nodesPste{trialTypeI}(3, 1:2)', '--k')
            p{2} = errorbar([1 2 3], nodesPmean{trialTypeI}(4, :)', nodesPste{trialTypeI}(4, :)', '-ok');
            % circle dot--same direction
            plot([1], nodesPmean{trialTypeI}(2, 1)', 'ok')
            plot([2], nodesPmean{trialTypeI}(3, 2)', 'ok')
            
            xlim([0.5, 3.5])
            title([trialTypeNames(trialTypeI) ' all, ' dirConNames{dirN}])
            legend([p{:}], {'different dir', 'same dir'}, 'location', 'best')
            set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
            xlabel('Trial')
            ylabel('Anticipatory pursuit horizontal velocity (deg/s)')
            %     ylim([-1 0.6])
        end
        saveas(gca, ['anticipatoryP_trialHistory_all_' dirConNames{dirN} '.pdf'])
        
        % trian number
        figure
        for trialTypeI = 1:2
            subplot(2, 1, trialTypeI)
            hold on
            % dashed--different direction
            p{1} = errorbar([1 2 3], nodesTNmean{trialTypeI}(1, :)', nodesTNste{trialTypeI}(1, :)', '--k');
            errorbar([1 2], nodesTNmean{trialTypeI}(2, 1:2)', nodesTNste{trialTypeI}(2, 1:2)', '-k')
            errorbar([1 2], nodesTNmean{trialTypeI}(3, 1:2)', nodesTNste{trialTypeI}(3, 1:2)', '--k')
            p{2} = errorbar([1 2 3], nodesTNmean{trialTypeI}(4, :)', nodesTNste{trialTypeI}(4, :)', '-ok');
            % circle dot--same direction
            plot([1], nodesTNmean{trialTypeI}(2, 1)', 'ok')
            plot([2], nodesTNmean{trialTypeI}(3, 2)', 'ok')
            
            xlim([0.5, 3.5])
            title([trialTypeNames(trialTypeI) ' all, ' dirConNames{dirN}])
            legend([p{:}], {'different dir', 'same dir'}, 'location', 'best')
            set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
            xlabel('Trial')
            ylabel('Number of trials')
            %     ylim([-1 0.6])
        end
        saveas(gca, ['trialHistory_trialNumber_all_' dirConNames{dirN} '.pdf'])
        
        %         % left trial proportion
        %         figure
        %         for trialTypeI = 1:2
        %             subplot(2, 1, trialTypeI)
        %             hold on
        %             % dashed--different direction
        %             p{1} = errorbar([1 2 3], nodesLRmean{trialTypeI}(1, :)', nodesLRste{trialTypeI}(1, :)', '--k');
        %             errorbar([1 2], nodesLRmean{trialTypeI}(2, 1:2)', nodesLRste{trialTypeI}(2, 1:2)', '-k')
        %             errorbar([1 2], nodesLRmean{trialTypeI}(3, 1:2)', nodesLRste{trialTypeI}(3, 1:2)', '--k')
        %             p{2} = errorbar([1 2 3], nodesLRmean{trialTypeI}(4, :)', nodesLRste{trialTypeI}(4, :)', '-ok');
        %             % circle dot--same direction
        %             plot([1], nodesLRmean{trialTypeI}(2, 1)', 'ok')
        %             plot([2], nodesLRmean{trialTypeI}(3, 2)', 'ok')
        %
        %             xlim([0.5, 3.5])
        %             title(['all, ' dirConNames{dirN}])
        %             legend([p{:}], {'different dir', 'same dir'}, 'location', 'best')
        %             set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
        %             xlabel('Trial')
        %             ylabel('Proportion of left trials')
        %             %     ylim([-1 0.6])
        %         end
        %         saveas(gca, ['trialHistory_leftProportion_all_' dirConNames{dirN} '.pdf'])
    end
end

%% functions used
function [outputMean outputStd idxOut] = splitNode(trialIdx, x, xCons, y, validI, n)
% calculate mean of all trials, and mean of all trials splitted by moving
% direction of the previous trial (if possible)
% Input:
%   trialIdx-to trace back trials
%   x-split based on values in x
% 	xCon-values for each condition to split
%   y-values to calculate mean
%   validI-only use y from these trials; but can search previous trials in
%   the whole table...
%   n-to split by the n_th trial back
% Output:
%   output-length(xCons) x 2 matrix; the first column is the mean of splitted trials;
%       the second column is the mean of all trials (should be identical numbers)
%   idxOut-each cell contains the idx of each split condition
outputMean(:, 2) = repmat(nanmean(y(validI)), length(xCons), 1);
outputStd(:, 2) = repmat(nanstd(y(validI)), length(xCons), 1);

tempY = cell(1, length(xCons));
idxOut = cell(1, length(xCons));
for idxT = 1:length(validI) % loop through all trials
    nBackI = find(trialIdx==(trialIdx(validI(idxT))-n));
    if nBackI % sort by the n-back trial
        conI = find(xCons==x(nBackI)*x(validI(idxT))); % if the directions are the same
        if conI
            tempY{conI} = [tempY{conI}; y(validI(idxT))];
            idxOut{conI} = [idxOut{conI}; validI(idxT)];
        end
    end
end

for conI = 1:length(xCons)
    outputMean(conI, 1) = nanmean(tempY{conI});
    outputStd(conI, 1) = nanstd(tempY{conI});
end
end

function [nodesMean nodesSte] = sortForPlot(treeNodes, sqrtN, n) % mainly for average plot
% --treeNodes is the outputMean calculated by splitNode
% --sqrtN is used to calculate standard error, N equals number of
%   participants
% --n is how many conditions a node is splitted by
nodesMean(1:2*n, 1) = mean(treeNodes{1}, 1)';
nodesSte(1:2*n, 1) = std(treeNodes{1}, 0, 1)'/sqrtN;

meanTemp = repmat(mean(treeNodes{2}, 1), 2, 1);
nodesMean(1:2*n, 2) = meanTemp(:);
stdTemp = repmat(std(treeNodes{2}, 0, 1), 2, 1);
nodesSte(1:2*n, 2) = stdTemp(:)/sqrtN;

nodesMean(1:2*n, 3) = repmat(mean(treeNodes{3}, 1), 4, 1);
nodesSte(1:2*n, 3) = repmat(std(treeNodes{3}, 0, 1), 4, 1)/sqrtN;
end

function drawPlot(subN, meanY, steY, xlabelName, ylabelName, subConNames, pdfName, subName, dirConName)
% --subN is the index of the current participant; use 1 for average across
%   participants
% --meanY and steY should be sorted by the previous functions...
figure
for subConI = 1:length(subConNames)
    subplot(length(subConNames), 1, subConI)
    hold on
    if ~isempty(steY)
        % dashed--different direction
        p{1} = errorbar([1 2 3], meanY{subConI, subN}(1, :)', steY{subConI, subN}(1, :)', '--k');
        errorbar([1 2], meanY{subConI, subN}(2, 1:2)', steY{subConI, subN}(2, 1:2)', '-k')
        errorbar([1 2], meanY{subConI, subN}(3, 1:2)', steY{subConI, subN}(3, 1:2)', '--k')
        p{2} = errorbar([1 2 3], meanY{subConI, subN}(4, :)', steY{subConI, subN}(4, :)', '-ok');
    else
        % dashed--different direction
        p{1} = plot([1 2 3], meanY{subConI, subN}(1, :)', '--k');
        plot([1 2], meanY{subConI, subN}(2, 1:2)', '-k')
        plot([1 2], meanY{subConI, subN}(3, 1:2)', '--k')
        p{2} = plot([1 2 3], meanY{subConI, subN}(4, :)', '-ok');
    end
    % circle dot--same direction
    plot([1], meanY{subConI, subN}(2, 1)', 'ok')
    plot([2], meanY{subConI, subN}(3, 2)', 'ok')
    
    xlim([0.5 3.5])
    title([subConNames(subConI) ' ', subName, ' ', dirConName])
    legend([p{:}], {'different dir', 'same dir'}, 'location', 'best')
    set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
    xlabel(xlabelName)
    ylabel(ylabelName)
    %     ylim([-1 0.6])
end
saveas(gca, [pdfName subName dirConName '.pdf'])
end