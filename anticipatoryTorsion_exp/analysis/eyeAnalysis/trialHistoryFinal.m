% analysis including the old experiments, mostly tree plots

%% calculate number of excluded trials
% initializeParas;
% cd(analysisFolder)
% exclusion = [];
%
% % from the old experiments 1 and 2
% exp14 = load('horizontalAnt_exp14.mat');
% exp16 = load('horizontalAnt_exp16.mat');
% for subN = 1:9
%     temp14 = length(find(isnan(exp14.horizontalAnt(:, :, 1))));
%     temp16 = length(find(isnan(exp16.horizontalAnt(:, :, 1))));
%     exclusion = [exclusion; temp14/600];
%     exclusion = [exclusion; temp16/600];
% end
%
% % from exp 3
% for subN = 1:5
%     temp = length(find(trialData.sub==subN));
%     exclusion = [exclusion; 1-temp/400];
% end
% % mean and range
% mean(exclusion)
% min(exclusion)
% max(exclusion)

%% tree plots of the effects of trial history...
%% Old data, Experiment 2, for anticipatory torsion
% always left to right, so natural = CW, unnatural = CCW
initializeParas;
cd(analysisFolder)
individualPlots = 0;
averagedPlots = 1;

load('torsionAnt_exp16') % anticipatory torsion
% to reconstruct trial order? read in log files first
logFiles = dir("subject*log.txt");
for subN = 1:size(logFiles, 1)
    fid = fopen(logFiles(subN).name);
    %skip 5 lines
    textscan(fid, '%*[^\n]', 5);
    allData = textscan(fid, '%d %d %d %d %f %d %f %f %f %f %f %f %d %f %*[^\n]', 600);
    log.block{subN} = allData{1};
    log.translationalDir{subN} = allData{3}; % 0 = right, 1 = left
    log.rotationalDir{subN} = allData{4}; % 0 = no rotation, -1 = unnatural, 1 = natural
    fclose('all');
end

% load the error files
cd('errorFiles')
errorFiles = dir("Exp16_Subject*.mat");
for subN = 1:size(logFiles, 1)
    log.errorStatus{subN} = [];
    for blockN = 1:6 % block 2, 4, 6, 8, 10, 12
        load(errorFiles((subN-1)*6+blockN).name)
        log.errorStatus{subN} = [log.errorStatus{subN}; errorStatus];
    end
end
cd ..

% use the same structure as the data, one for trial idx
trialIdx = NaN(200, 3, 12);
blockIdx = NaN(200, 3, 12);
rotationalD = [ones(200, 1), -ones(200, 1), zeros(200, 1)];

for subN = 1:size(logFiles, 1)
    naI = 1; % index for natural, first column
    unI = 1; % index for unnatural, second column
    nrI = 1; % index for no rotation, third column
    for tI = 1:size(log.rotationalDir{subN}, 1)
        if log.errorStatus{subN}(tI)==0 % if the trial is valid
            switch log.rotationalDir{subN}(tI)
                case 0
                    trialIdx(nrI, 3, subN) = tI;
                    blockIdx(nrI, 3, subN) = log.block{subN}(tI);
                    nrI = nrI+1;
                case -1
                    trialIdx(unI, 2, subN) = tI;
                    blockIdx(unI, 2, subN) = log.block{subN}(tI);
                    unI = unI+1;
                case 1
                    trialIdx(naI, 1, subN) = tI;
                    blockIdx(naI, 1, subN) = log.block{subN}(tI);
                    naI = naI+1;
            end
        end
    end
    
    % calculate the nodes
% %     %     to flip the directions and merge together...
% %     torsionAnt(:, :, subN) = torsionAnt(:, :, subN).*rotationalD;
%     %     now calculate nodes, directions together
%     dirIdx = find(rotationalD~=0); % trials with rotation...
%     [lastT lastTstd idxOutL{subN} trialsT1back{subN}] = splitNode(trialIdx(:, :, subN), blockIdx(:, :, subN), rotationalD, [-1 1], torsionAnt(:, :, subN), dirIdx, 1);
%     
%     [firstT(1:2, :) firstTstd(1:2, :) idxOutFd{subN}]= splitNode(trialIdx(:, :, subN), blockIdx(:, :, subN), rotationalD, [-1 1], torsionAnt(:, :, subN), idxOutL{subN}{1}, 2); % different previous
%     [firstT(3:4, :) firstTstd(3:4, :) idxOutFs{subN}]= splitNode(trialIdx(:, :, subN), blockIdx(:, :, subN), rotationalD, [-1 1], torsionAnt(:, :, subN), idxOutL{subN}{2}, 2); % same previous
%     
%     treeNodesT{1}(subN, 1:4) = firstT(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
%     treeNodesT{2}(subN, 1:2) = lastT(1:2, 1)'; % the second column, two nodes, n-1, diff, same
%     treeNodesT{3}(subN, 1) = lastT(1, 2); % the third column, 1 node, mean of all
%     
%     [nodesTmeanSub{subN}] = ...
%         sortForPlot({treeNodesT{1}(subN, :) treeNodesT{2}(subN, :) treeNodesT{3}(subN, :)}, 1, 2); % torsion
% %     format after sortForPlot:
% %     different dir (n-2) -- different dir (n-1) -- n
% %     same dir (n-2)      -- different dir (n-1) -- n
% %     different dir (n-2) -- same dir (n-1)      -- n
% %     same (n-2)          -- same dir (n-1)      -- n
%     
% %     individual std
%     treeNodesTstd{1}(subN, 1:4) = firstTstd(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
%     treeNodesTstd{2}(subN, 1:2) = lastTstd(1:2, 1)'; % the second column, two nodes, n-1, diff, same
%     treeNodesTstd{3}(subN, 1) = lastTstd(1, 2); % the third column, 1 node, mean of all
%     
%     [nodesTstdSub{subN}] = ...
%         sortForPlot({treeNodesTstd{1}(subN, :) treeNodesTstd{2}(subN, :) treeNodesTstd{3}(subN, :)}, 1, 2); % torsion
%         %% Anova for individual data, should use merged direction...
%     [p{subN}, tbl{subN}, stats{subN}] = anovan(trialsT1back{subN}.data, {trialsT1back{subN}.dirBack, trialsT1back{subN}.dirCurrent}); 
%     etaSquaredPartial(subN) = tbl{subN}{2, 2}/(tbl{subN}{2, 2}+tbl{subN}{4, 2});
%     idxTemp = find(trialsT1back{subN}.dirBack==-1);
%     means1back(subN, 1) = nanmean(trialsT1back{subN}.data(idxTemp));
%     idxTemp = find(trialsT1back{subN}.dirBack==1);
%     means1back(subN, 2) = nanmean(trialsT1back{subN}.data(idxTemp)); % first column is different, second column is same direction
%     
    % this is to plot directions separately
    for dirN = 1:2 % natural and unnatural
        if dirN==1 % natural rotation, CW
            dirIdx = find(rotationalD==1);
        else % unnatural rotation, CCW
            dirIdx = find(rotationalD==-1);
        end
        
        [lastT lastTstd idxOutL{dirN, subN}] = splitNode(trialIdx(:, :, subN), blockIdx(:, :, subN), rotationalD, [-1 1], torsionAnt(:, :, subN), dirIdx, 1);
        
        [firstT(1:2, :) firstTstd(1:2, :) idxOutFd{dirN, subN}]= splitNode(trialIdx(:, :, subN), blockIdx(:, :, subN), rotationalD, [-1 1], torsionAnt(:, :, subN), idxOutL{dirN, subN}{1}, 2); % different previous
        [firstT(3:4, :) firstTstd(3:4, :) idxOutFs{dirN, subN}]= splitNode(trialIdx(:, :, subN), blockIdx(:, :, subN), rotationalD, [-1 1], torsionAnt(:, :, subN), idxOutL{dirN, subN}{2}, 2); % same previous
        
        treeNodesT{dirN, 1}(subN, 1:4) = firstT(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
        treeNodesT{dirN, 2}(subN, 1:2) = lastT(1:2, 1)'; % the second column, two nodes, n-1, diff, same
        treeNodesT{dirN, 3}(subN, 1) = lastT(1, 2); % the third column, 1 node, mean of all
        
        [nodesTmeanSub{dirN, subN}] = ...
            sortForPlot({treeNodesT{dirN, 1}(subN, :) treeNodesT{dirN, 2}(subN, :) treeNodesT{dirN, 3}(subN, :)}, 1, 2); % torsion
        % format after sortForPlot:
        % different dir (n-2) -- different dir (n-1) -- n
        % same dir (n-2)      -- different dir (n-1) -- n
        % different dir (n-2) -- same dir (n-1)      -- n
        % same (n-2)          -- same dir (n-1)      -- n
        
        % individual std
        treeNodesTstd{dirN, 1}(subN, 1:4) = firstTstd(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
        treeNodesTstd{dirN, 2}(subN, 1:2) = lastTstd(1:2, 1)'; % the second column, two nodes, n-1, diff, same
        treeNodesTstd{dirN, 3}(subN, 1) = lastTstd(1, 2); % the third column, 1 node, mean of all
        
        [nodesTstdSub{dirN, subN}] = ...
            sortForPlot({treeNodesTstd{dirN, 1}(subN, :) treeNodesTstd{dirN, 2}(subN, :) treeNodesTstd{dirN, 3}(subN, :)}, 1, 2); % torsion
    end
    %% plots of individual data
    if individualPlots==1
        % torsion plots
        cd([torsionFolder '\individuals'])
        % anticipatory torsion
        drawPlot(subN, nodesTmeanSub, nodesTstdSub, 'Trial', 'Anticipatory torsion velocity (deg/s)', {'CW' 'CCW'}, 'trialHistory_anticipatoryTExp2_', ['s' num2str(subN)], [], [])
        
        %             close all
    end
end
% save('anovaTreeplotExp2.mat', 'tbl', 'etaSquaredPartial', 'means1back')
% 
% generate the lines for averaged data
% directions separated
for dirN = 1:size(transDirCons, 2)
    [nodesTmean{dirN, 1} nodesTste{dirN, 1}] = sortForPlot({treeNodesT{dirN, 1} treeNodesT{dirN, 2} treeNodesT{dirN, 3}}, sqrt(size(logFiles, 1)), 2); % torsion
end
% % direction merged
% [nodesTmean{1} nodesTste{1}] = sortForPlot({treeNodesT{1} treeNodesT{2} treeNodesT{3}}, sqrt(size(logFiles, 1)), 2); % torsion

% averaged plots
if averagedPlots==1
    % torsion plots
    cd(torsionFolder)
    % anticipatory torsion
    drawPlot(1, nodesTmean, nodesTste, 'Trial', 'Anticipatory torsion velocity (deg/s)', {'CW' 'CCW'}, 'trialHistory_anticipatoryT_', 'Exp2_all', [], [-0.8 0.6])
end
cd(analysisFolder)

%% New data, Experiment 3 (control)
initializeParas;
individualPlots = 0;
averagedPlots = 1;

for subN = 1:size(names, 2)
    dataP = trialData(trialData.sub==subN, :); % select all trials in the block
    dataT = trialData(trialData.sub==subN & trialData.trialType==1, :);  % select all rotation trials
    
    % directions separated
    for dirN = 1:2
        dirIdxP = find(dataP.translationalDirection==transDirCons(dirN));
        dirIdxT = find(dataT.translationalDirection==transDirCons(dirN)); % only use trials in a certain direction
        [lastP lastPstd idxOutPL{dirN, subN}] = splitNode(dataP.trial, dataP.trialType, dataP.translationalDirection, [-1 1], dataP.anticipatoryPursuitHVel, dirIdxP, 1); % the last two nodes in the tree plot
        [lastT lastTstd idxOutTL{dirN, subN}] = splitNode(dataT.trial, dataT.trialType, dataT.translationalDirection, [-1 1], dataT.anticipatoryTorsionVel, dirIdxT, 1);
    
        [firstP(1:2, :) firstPstd(1:2, :) idxOutPFd{dirN, subN}]= splitNode(dataP.trial, dataP.trialType, dataP.translationalDirection, [-1 1], dataP.anticipatoryPursuitHVel, idxOutPL{dirN, subN}{1}, 2); % different previous
        [firstP(3:4, :) firstPstd(3:4, :) idxOutPFs{dirN, subN}]= splitNode(dataP.trial, dataP.trialType, dataP.translationalDirection, [-1 1], dataP.anticipatoryPursuitHVel, idxOutPL{dirN, subN}{2}, 2); % same previous
        [firstT(1:2, :) firstTstd(1:2, :) idxOutTFd{dirN, subN}]= splitNode(dataT.trial, dataT.trialType, dataT.translationalDirection, [-1 1], dataT.anticipatoryTorsionVel, idxOutTL{dirN, subN}{1}, 2); % different previous
        [firstT(3:4, :) firstTstd(3:4, :) idxOutTFs{dirN, subN}]= splitNode(dataT.trial, dataT.trialType, dataT.translationalDirection, [-1 1], dataT.anticipatoryTorsionVel, idxOutTL{dirN, subN}{2}, 2); % same previous
        treeNodesP{dirN, 1}(subN, 1:4) = firstP(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
        treeNodesP{dirN, 2}(subN, 1:2) = lastP(1:2, 1)'; % the second column, two nodes, n-1, diff, same
        treeNodesP{dirN, 3}(subN, 1) = lastP(1, 2); % the third column, 1 node, mean of all
        treeNodesT{dirN, 1}(subN, 1:4) = firstT(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
        treeNodesT{dirN, 2}(subN, 1:2) = lastT(1:2, 1)'; % the second column, two nodes, n-1, diff, same
        treeNodesT{dirN, 3}(subN, 1) = lastT(1, 2); % the third column, 1 node, mean of all
    
        treeNodesPstd{dirN, 1}(subN, 1:4) = firstPstd(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
        treeNodesPstd{dirN, 2}(subN, 1:2) = lastPstd(1:2, 1)'; % the second column, two nodes, n-1, diff, same
        treeNodesPstd{dirN, 3}(subN, 1) = lastPstd(1, 2); % the third column, 1 node, mean of all
        treeNodesTstd{dirN, 1}(subN, 1:4) = firstTstd(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
        treeNodesTstd{dirN, 2}(subN, 1:2) = lastTstd(1:2, 1)'; % the second column, two nodes, n-1, diff, same
        treeNodesTstd{dirN, 3}(subN, 1) = lastTstd(1, 2); % the third column, 1 node, mean of all
    
        [nodesPmeanSub{dirN, subN}] = ...
            sortForPlot({treeNodesP{dirN, 1}(subN, :) treeNodesP{dirN, 2}(subN, :) treeNodesP{dirN, 3}(subN, :)}, 1, 2);
        [nodesPstdSub{dirN, subN}] = ...
            sortForPlot({treeNodesPstd{dirN, 1}(subN, :) treeNodesPstd{dirN, 2}(subN, :) treeNodesPstd{dirN, 3}(subN, :)}, 1, 2);% pursuit
        [nodesTmeanSub{dirN, subN}] = ...
            sortForPlot({treeNodesT{dirN, 1}(subN, :) treeNodesT{dirN, 2}(subN, :) treeNodesT{dirN, 3}(subN, :)}, 1, 2);
        [nodesTstdSub{dirN, subN}] = ...
            sortForPlot({treeNodesTstd{dirN, 1}(subN, :) treeNodesTstd{dirN, 2}(subN, :) treeNodesTstd{dirN, 3}(subN, :)}, 1, 2); % torsion
        end

% %     % flip and merge the directions
% %     trialData.rotationalDirection = double(trialData.rotationalDirection);
% %     trialData.translationalDirection = double(trialData.translationalDirection);
% %     trialData.anticipatoryTorsionVel = trialData.anticipatoryTorsionVel.*trialData.rotationalDirection;
% %     trialData.anticipatoryPursuitHVel = -trialData.anticipatoryPursuitHVel.*trialData.translationalDirection;
% 
%     dirIdxP = 1:size(dataP, 1); %find(dataP.translationalDirection==transDirCons(dirN));
%     dirIdxT = 1:size(dataT, 1); %find(dataT.translationalDirection==transDirCons(dirN)); % only use trials in a certain direction
% 
%     [lastP lastPstd idxOutPL{subN} trialsP1back{subN}] = splitNode(dataP.trial, dataP.trialType, dataP.translationalDirection, [-1 1], dataP.anticipatoryPursuitHVel, dirIdxP, 1); % the last two nodes in the tree plot
%     [lastT lastTstd idxOutTL{subN} trialsT1back{subN}] = splitNode(dataT.trial, dataT.trialType, dataT.translationalDirection, [-1 1], dataT.anticipatoryTorsionVel, dirIdxT, 1);
% 
%     [firstP(1:2, :) firstPstd(1:2, :) idxOutPFd{subN}]= splitNode(dataP.trial, dataP.trialType, dataP.translationalDirection, [-1 1], dataP.anticipatoryPursuitHVel, idxOutPL{subN}{1}, 2); % different previous
%     [firstP(3:4, :) firstPstd(3:4, :) idxOutPFs{subN}]= splitNode(dataP.trial, dataP.trialType, dataP.translationalDirection, [-1 1], dataP.anticipatoryPursuitHVel, idxOutPL{subN}{2}, 2); % same previous
%     [firstT(1:2, :) firstTstd(1:2, :) idxOutTFd{subN}]= splitNode(dataT.trial, dataT.trialType, dataT.translationalDirection, [-1 1], dataT.anticipatoryTorsionVel, idxOutTL{subN}{1}, 2); % different previous
%     [firstT(3:4, :) firstTstd(3:4, :) idxOutTFs{subN}]= splitNode(dataT.trial, dataT.trialType, dataT.translationalDirection, [-1 1], dataT.anticipatoryTorsionVel, idxOutTL{subN}{2}, 2); % same previous
%     treeNodesP{1}(subN, 1:4) = firstP(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
%     treeNodesP{2}(subN, 1:2) = lastP(1:2, 1)'; % the second column, two nodes, n-1, diff, same
%     treeNodesP{3}(subN, 1) = lastP(1, 2); % the third column, 1 node, mean of all
%     treeNodesT{1}(subN, 1:4) = firstT(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
%     treeNodesT{2}(subN, 1:2) = lastT(1:2, 1)'; % the second column, two nodes, n-1, diff, same
%     treeNodesT{3}(subN, 1) = lastT(1, 2); % the third column, 1 node, mean of all
% 
%     treeNodesPstd{1}(subN, 1:4) = firstPstd(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
%     treeNodesPstd{2}(subN, 1:2) = lastPstd(1:2, 1)'; % the second column, two nodes, n-1, diff, same
%     treeNodesPstd{3}(subN, 1) = lastPstd(1, 2); % the third column, 1 node, mean of all
%     treeNodesTstd{1}(subN, 1:4) = firstTstd(1:4, 1)'; % the first column, four nodes, n-2, diff-diff, same-diff, diff-same, same-same
%     treeNodesTstd{2}(subN, 1:2) = lastTstd(1:2, 1)'; % the second column, two nodes, n-1, diff, same
%     treeNodesTstd{3}(subN, 1) = lastTstd(1, 2); % the third column, 1 node, mean of all
% 
%     [nodesPmeanSub{subN}] = ...
%         sortForPlot({treeNodesP{1}(subN, :) treeNodesP{2}(subN, :) treeNodesP{3}(subN, :)}, 1, 2);
%     [nodesPstdSub{subN}] = ...
%         sortForPlot({treeNodesPstd{1}(subN, :) treeNodesPstd{2}(subN, :) treeNodesPstd{3}(subN, :)}, 1, 2);% pursuit
%     [nodesTmeanSub{subN}] = ...
%         sortForPlot({treeNodesT{1}(subN, :) treeNodesT{2}(subN, :) treeNodesT{3}(subN, :)}, 1, 2);
%     [nodesTstdSub{subN}] = ...
%         sortForPlot({treeNodesTstd{1}(subN, :) treeNodesTstd{2}(subN, :) treeNodesTstd{3}(subN, :)}, 1, 2); % torsion
%     %% Anova for individual data, should use merged direction...
%     % torsion
%     [pT{subN}, tblT{subN}, statsT{subN}] = anovan(trialsT1back{subN}.data, {trialsT1back{subN}.dirBack, trialsT1back{subN}.dirCurrent});
%     etaSquaredTpartial(subN) = tblT{subN}{2, 2}/(tblT{subN}{2, 2}+tblT{subN}{4, 2});
%     idxTemp = find(trialsT1back{subN}.dirBack==-1);
%     means1backT(subN, 1) = nanmean(trialsT1back{subN}.data(idxTemp));
%     idxTemp = find(trialsT1back{subN}.dirBack==1);
%     means1backT(subN, 2) = nanmean(trialsT1back{subN}.data(idxTemp)); % first column is CCW back, second column is CW back
%     
%     % pursuit
%     [pP{subN}, tblP{subN}, statsP{subN}] = anovan(trialsP1back{subN}.data, {trialsP1back{subN}.dirBack, trialsP1back{subN}.dirCurrent});
%     etaSquaredPpartial(subN) = tblP{subN}{2, 2}/(tblP{subN}{2, 2}+tblP{subN}{4, 2});
%     idxTemp = find(trialsP1back{subN}.dirBack==-1);
%     means1backP(subN, 1) = nanmean(trialsP1back{subN}.data(idxTemp));
%     idxTemp = find(trialsP1back{subN}.dirBack==1);
%     means1backP(subN, 2) = nanmean(trialsP1back{subN}.data(idxTemp)); % first column is CCW back, second column is CW back

    %% plots of individual data
    if individualPlots==1
        % torsion plots
        cd([torsionFolder '\individuals'])
        % anticipatory torsion
        drawPlot(subN, nodesTmeanSub, nodesTstdSub, 'Trial', 'Anticipatory torsion velocity (deg/s)', {'CCW' 'CW'}, 'trialHistory_anticipatoryTExp3_', names{subN}, [], [])

        % pursuit plots
        cd([pursuitFolder '\individuals'])
        % anticipatory pursuit
        drawPlot(subN, nodesPmeanSub, nodesPstdSub, 'Trial', 'Anticipatory pursuit velocity (deg/s)', {'Left' 'Right'}, 'trialHistory_anticipatoryPExp3_', names{subN}, [], [])

        %         close all
    end
end
% save('anovaTreeplotExp3.mat', 'tblT', 'etaSquaredTpartial', 'means1backT', 'tblP', 'etaSquaredPpartial', 'means1backP')

%% averaged plots
if averagedPlots==1
    % generate the lines for averaged data
    % directions separated
    for dirN = 1:size(transDirCons, 2)
        [nodesPmean{dirN, 1} nodesPste{dirN, 1}] = sortForPlot({treeNodesP{dirN, 1} treeNodesP{dirN, 2} treeNodesP{dirN, 3}}, sqrt(size(names, 2)), 2); % pursuit
        [nodesTmean{dirN, 1} nodesTste{dirN, 1}] = sortForPlot({treeNodesT{dirN, 1} treeNodesT{dirN, 2} treeNodesT{dirN, 3}}, sqrt(size(names, 2)), 2); % torsion
    end
    % % directions merged
    % [nodesPmean{1} nodesPste{1}] = sortForPlot({treeNodesP{1} treeNodesP{2} treeNodesP{3}}, sqrt(size(names, 2)), 2); % pursuit
    % [nodesTmean{1} nodesTste{1}] = sortForPlot({treeNodesT{1} treeNodesT{2} treeNodesT{3}}, sqrt(size(names, 2)), 2); % torsion
    
    %     % torsion plots
    cd(torsionFolder)
    % anticipatory torsion
    drawPlot(1, nodesTmean, nodesTste, 'Trial', 'Anticipatory torsion velocity (deg/s)', {'CCW' 'CW'}, 'trialHistory_anticipatoryT_', 'Exp3_all', [], [-0.8 0.6])
    
    % pursuit plots
    cd(pursuitFolder)
    % anticipatory pursuit
    drawPlot(1, nodesPmean, nodesPste, 'Trial', 'Anticipatory pursuit velocity (deg/s)', {'Left' 'Right'}, 'trialHistory_anticipatoryP_', 'Exp3_all', [], [-2.5 2.5])
end

%% functions used
function [outputMean outputStd idxOut trials] = splitNode(trialIdx, blockIdx, x, xCons, y, validI, n)
% calculate mean of all trials, and mean of all trials splitted by moving
% direction of the previous trial (if possible)
% Input:
%   trialIdx-to trace back trials
%   blockIdx-to trace back block info; only valid if the preceeding trial
%   is within the same block
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
%   trials-contains individual trial data and the directions
outputMean(:, 2) = repmat(nanmean(y(validI)), length(xCons), 1);
outputStd(:, 2) = repmat(nanstd(y(validI)), length(xCons), 1);
trials = table();
idxTrials = 1;

trialY = cell(1, length(xCons));
idxOut = cell(1, length(xCons));
for idxT = 1:length(validI) % loop through all trials
    nBackI = find(trialIdx==(trialIdx(validI(idxT))-n));
    if nBackI % sort by the n-back trial
        for ii = 1:length(nBackI)
            if blockIdx(nBackI(ii))==blockIdx(validI(idxT)) % in the same block
                conI = find(xCons==x(nBackI(ii))*x(validI(idxT))); % if the directions are the same
                if conI
                    trialY{conI} = [trialY{conI}; y(validI(idxT))];
                    idxOut{conI} = [idxOut{conI}; validI(idxT)];
                    trials.data(idxTrials, 1) = y(validI(idxT));
                    trials.dirBack(idxTrials, 1) = x(nBackI(ii));
                    trials.dirCurrent(idxTrials, 1) = x(validI(idxT));
                    idxTrials = idxTrials+1;
                end
            end
        end
    end
end

for conI = 1:length(xCons)
    outputMean(conI, 1) = nanmean(trialY{conI});
    outputStd(conI, 1) = nanstd(trialY{conI});
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

function drawPlot(subN, meanY, steY, xlabelName, ylabelName, subConNames, pdfName, subName, dirConName, yRange)
% --subN is the index of the current participant; use 1 for average across
%   participants
% --meanY and steY should be sorted by the previous functions...
figure
for subConI = 1:length(subConNames)
    subplot(1, length(subConNames), subConI)
    hold on
    if strcmp(subConNames(subConI), 'CW') || strcmp(subConNames(subConI), 'Left')
        % different direction, CCW or right, negative--dashed and circle dot
        p{1} = errorbar([1 2 3], meanY{subConI, subN}(1, :)', steY{subConI, subN}(1, :)', '--ok');
        errorbar([1 2], meanY{subConI, subN}(2, 1:2)', steY{subConI, subN}(2, 1:2)', '-k')
        errorbar([1 2], meanY{subConI, subN}(3, 1:2)', steY{subConI, subN}(3, 1:2)', '--ok')
        p{2} = errorbar([1 2 3], meanY{subConI, subN}(4, :)', steY{subConI, subN}(4, :)', '-ok', 'MarkerFaceColor', 'k'); % all same, positive
        
        % same direction, CW or Left, positive--solid dot
        plot([1], meanY{subConI, subN}(2, 1)', 'ok', 'MarkerFaceColor', 'k')
    else
        % same direction, CCW or right, negative--dashed and circle dot
        p{1} = errorbar([1 2 3], meanY{subConI, subN}(4, :)', steY{subConI, subN}(4, :)', '--ok');
        errorbar([1 2], meanY{subConI, subN}(2, 1:2)', steY{subConI, subN}(2, 1:2)', '--ok')
        errorbar([1 2], meanY{subConI, subN}(3, 1:2)', steY{subConI, subN}(3, 1:2)', '-k')
        p{2} = errorbar([1 2 3], meanY{subConI, subN}(1, :)', steY{subConI, subN}(1, :)', '-ok', 'MarkerFaceColor', 'k'); % all different, positive
        
        % different direction, CW or left, positive--solid dot
        plot([1], meanY{subConI, subN}(3, 1)', 'ok', 'MarkerFaceColor', 'k')
    end
    % % directions merged
    % % different direction, CCW or right, negative--dashed and circle dot
    % p{1} = errorbar([1 2 3], meanY{subN}(1, :)', steY{subN}(1, :)', '--ok');
    % errorbar([1 2], meanY{subN}(2, 1:2)', steY{subN}(2, 1:2)', '-k')
    % errorbar([1 2], meanY{subN}(3, 1:2)', steY{subN}(3, 1:2)', '--ok')
    % p{2} = errorbar([1 2 3], meanY{subN}(4, :)', steY{subN}(4, :)', '-ok', 'MarkerFaceColor', 'k'); % all same, positive
    %
    % % same direction, CW or Left, positive--solid dot
    % plot([1], meanY{subN}(2, 1)', 'ok', 'MarkerFaceColor', 'k')
    
    xlim([0.9 3.1])
    %     ylim([-0.5 0.8])
%     title([subConNames(subConI) ' ' subName ' ' dirConName])
    % title([subName ' ' dirConName])
    legend([p{:}], {'Right/CCW (negative)' 'Left/CW (positive)'}, 'location', 'best')
    set(gca, 'XTick', [1, 2, 3], 'XTickLabels', {'n-2', 'n-1', 'n'})
    xlabel([xlabelName, subConNames(subConI)])
    ylabel(ylabelName)
    if ~isempty(yRange)
        ylim(yRange)
    end
end
saveas(gca, [pdfName subName dirConName '.pdf'])
end