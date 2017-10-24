function arrangeRandomization(info)
% randomly design the conditions for each trial in disp
% each cell is a table of conditions for each block

global prm disp
% if info.expType==0
%     varNames = {'gratingRadiusIdx', 'flashOnset', 'flashDisplaceLeft'};
%     
%     % all blocks together
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
%         disp{ii} = table(gratingRadiusIdx(idxR(idx)), flashOnset(idxR(idx)), flashDisplaceLeft(idxR(idx)), 'VariableNames', varNames);
%     end
%     
%     save([prm.fileName.folder, '\randomAssignment_', info.subID{1}], 'disp')
%     
% elseif info.expType==1
    varNames = {'gratingRadiusIdx', 'flashOnset', 'flashDisplaceLeft'};
    
    % all blocks together
    % index for the gratingRadius (for the texture); true number for the
    % other parameters
    gratingRadiusIdx = repmat([1:length(prm.grating.outerRadius)]', prm.trialPerCondition*prm.conditionN/length(prm.grating.outerRadius), 1);
    gratingRadiusIdx = sort(gratingRadiusIdx);
    flashOnset = repmat(prm.flash.onsetInterval', length(gratingRadiusIdx)/length(prm.grating.outerRadius)/length(prm.flash.onsetInterval), 1);
    flashDisplaceLeft = repmat(prm.flash.displacement', length(flashOnset)/length(prm.flash.onsetInterval)/length(prm.flash.displacement), 1);
    
    flashOnset = sort(flashOnset);
    flashOnset = repmat(flashOnset, length(prm.grating.outerRadius), 1);
    flashDisplaceLeft = sort(flashDisplaceLeft);
    flashDisplaceLeft = repmat(flashDisplaceLeft, length(prm.grating.outerRadius)*length(prm.flash.onsetInterval), 1);
    
    % generate randomized indices, size blocked
    idxR = [];
    sizeTrials = prm.trialPerCondition*prm.conditionN/length(prm.grating.outerRadius); % number of trials for each size
    for ii = 1:length(prm.grating.outerRadius)
        temp = randperm(sizeTrials)+(ii-1)*sizeTrials;
        idxR = [idxR; temp'];
    end
    
    % assign to each block
    for ii = 1:prm.blockN
        % corresponding idx of trial no. in idxR
        idx = (ii-1)*prm.trialPerBlock+1:ii*prm.trialPerBlock;
        % assign to the final parameter
        disp{ii} = table(gratingRadiusIdx(idxR(idx)), flashOnset(idxR(idx)), flashDisplaceLeft(idxR(idx)), 'VariableNames', varNames);
    end
    
    save([prm.fileName.folder, '\randomAssignment_', info.subID{1}], 'disp')
% end

end