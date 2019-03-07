function arrangeRandomization(info)
% randomly design the conditions for each trial in display
% each cell is a table of conditions for each block
% each block has the same trials, just different in order

global prm display

varNames = {'gratingRadiusIdx', 'flashOnset', 'flashDisplaceLeft', 'initialDirection', 'rotationSpeed'};

%% Each block has the same trials, just different in order
copyN = prm.trialPerCondition/prm.blockN; % number of trials for each condition in each block
cons = genCombinations([1:length(prm.grating.outerRadius)]', prm.flash.onsetInterval');
cons = genCombinations(cons, prm.flash.displacement');
cons = genCombinations(cons, prm.rotation.initialDirection');
cons = genCombinations(cons, prm.rotation.freq');
trialsBlock = repmat(cons, copyN, 1);
headTilt = prm.headTilt;

% assign to each block
    for ii = 1:prm.blockN
        tempI = randperm(size(trialsBlock, 1));
        % assign to the final parameter
        display{ii} = table(trialsBlock(tempI, 1), trialsBlock(tempI, 2), trialsBlock(tempI, 3), trialsBlock(tempI, 4), trialsBlock(tempI, 5), 'VariableNames', varNames);
        display{ii}.headTilt = repmat(headTilt(ii), size(display{ii}.rotationSpeed, 1), 1);
    end

%% All blocks together, then randomly assign into each block; each block is different in trials
%     % index for the gratingRadius (for the texture); true number for the
%     % other parameters
%     gratingRadiusIdx = repmat([1:length(prm.grating.outerRadius)]', prm.trialPerCondition*prm.conditionN/length(prm.grating.outerRadius), 1);
%     gratingRadiusIdx = sort(gratingRadiusIdx);
%     flashOnset = repmat(prm.flash.onsetInterval', length(gratingRadiusIdx)/length(prm.grating.outerRadius)/length(prm.flash.onsetInterval), 1);
%     flashDisplaceLeft = repmat(prm.flash.displacement', length(flashOnset)/length(prm.flash.onsetInterval)/length(prm.flash.displacement), 1);
%
%     flashOnset = sort(flashOnset);
%     flashOnset = repmat(flashOnset, length(prm.grating.outerRadius), 1);
%     flashDisplaceLeft = sort(flashDisplaceLeft);
%     flashDisplaceLeft = repmat(flashDisplaceLeft, length(prm.grating.outerRadius)*length(prm.flash.onsetInterval), 1);
%
%     % generate randomized indices, size blocked
%     idxR = [];
%     sizeTrials = prm.trialPerCondition*prm.conditionN/length(prm.grating.outerRadius); % number of trials for each size
%     for ii = 1:length(prm.grating.outerRadius)
%         temp = randperm(sizeTrials)+(ii-1)*sizeTrials;
%         idxR = [idxR; temp'];
%     end
%
%     % assign to each block
%     for ii = 1:prm.blockN
%         % corresponding idx of trial no. in idxR
%         idx = (ii-1)*prm.trialPerBlock+1:ii*prm.trialPerBlock;
%         % assign to the final parameter
%         display{ii} = table(gratingRadiusIdx(idxR(idx)), flashOnset(idxR(idx)), flashDisplaceLeft(idxR(idx)), 'VariableNames', varNames);
%     end

save([prm.fileName.folder, '\randomAssignment_', info.subID{1}], 'display')

% end