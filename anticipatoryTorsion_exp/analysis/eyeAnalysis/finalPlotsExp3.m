% anova and plots for the manuscript
initializeParas;
trialData.translationalDirection = double(trialData.translationalDirection);

%% plots and ANOVA for the manuscript, directions merged
for subN = 1:size(names, 2)
    %% Eye velocity bar plots
    % anticipatory torsion/pursuit, right minus left moving trials
    % rows are subs, first column is baseline, second column is exp trials
    for trialTypeI = 1:size(trialTypeCons, 2)
        data = trialData(trialData.sub==subN & trialData.trialType==trialTypeCons(trialTypeI), :);
        anticipatoryT(subN, trialTypeI) = nanmean(data.anticipatoryTorsionVel.*data.translationalDirection); % collapsed to cw, positive (1=cw)
        anticipatoryP(subN, trialTypeI) = nanmean(-data.anticipatoryPursuitHVel.*data.translationalDirection); % collapsed to left, positive (-1=left)
    end
end

%% ANOVA 
%% anticipatory pursuit
%% ANOVA for exp 3
antiPtable = table();
% antiPtable.sub = names';
antiPtable.neutral = anticipatoryP(:, 1);
antiPtable.natural = anticipatoryP(:, 2);
Meas = table([1 2]','VariableNames',{'Rotation'});
rm = fitrm(antiPtable,'neutral-natural~1','WithinDesign',Meas);
ranovatbl = ranova(rm)
etaSquared = ranovatbl.SumSq(1)/sum(ranovatbl.SumSq)

%% ANOVA comparing mean anticipatory pursuit velocity in exp1, 2, and 3
data1 = load('horizontalAnt_exp14');
data2 = load('horizontalAnt_exp16');
aspAlltable = table();
aspIdx = 1;
for subN = 1:size(data1.horizontalAnt, 3)
    if subN~=7 && subN~=11 && subN~=12
        aspAlltable.exp(aspIdx, 1) = 1;
        temp = data1.horizontalAnt(:, :, subN);
        if subN==2
            temp2 = data1.horizontalAnt(:, :, 12);
            aspAlltable.asp(aspIdx, 1) = mean(abs([nanmean(temp) nanmean(temp2)]));
        elseif subN==3
            temp2 = data1.horizontalAnt(:, :, 7);
            aspAlltable.asp(aspIdx, 1) = mean(abs([nanmean(temp) nanmean(temp2)]));
        elseif subN==4
            temp2 = data1.horizontalAnt(:, :, 11);
            aspAlltable.asp(aspIdx, 1) = mean(abs([nanmean(temp) nanmean(temp2)]));
        else
            aspAlltable.asp(aspIdx, 1) = abs(mean(nanmean(temp)));
        end
        aspIdx = aspIdx+1;
    end
% if subN~=7 && subN~=11 && subN~=12
%     aspAlltable.exp(aspIdx, 1) = 1;
%     temp = data1.horizontalAnt(:, :, subN);
%     if subN==2
%         temp2 = data1.horizontalAnt(:, :, 12);
%         aspAlltable.asp(aspIdx, 1) = mean(abs([nanmean(temp(:)) nanmean(temp2(:))]));
%     elseif subN==3
%         temp2 = data1.horizontalAnt(:, :, 7);
%         aspAlltable.asp(aspIdx, 1) = mean(abs([nanmean(temp(:)) nanmean(temp2(:))]));
%     elseif subN==4
%         temp2 = data1.horizontalAnt(:, :, 11);
%         aspAlltable.asp(aspIdx, 1) = mean(abs([nanmean(temp(:)) nanmean(temp2(:))]));
%     else
%         aspAlltable.asp(aspIdx, 1) = abs(mean(nanmean(temp)));
%     end
%     aspIdx = aspIdx+1;
% end
end
for subN = 1:size(data2.horizontalAnt, 3)
    aspAlltable.exp(aspIdx, 1) = 2;
    temp = data2.horizontalAnt(:, :, subN);
    aspAlltable.asp(aspIdx, 1) = abs(mean(nanmean(temp)));
%         aspAlltable.asp(aspIdx, 1) = abs(nanmean(temp(:)));
    aspIdx = aspIdx+1;
end
for subN = 1:size(anticipatoryP, 1)
    aspAlltable.exp(aspIdx, 1) = 3;
    aspAlltable.asp(aspIdx, 1) = nanmean(anticipatoryP(subN, :));
    aspIdx = aspIdx+1;
end
[p, tbl, stats] = anovan(aspAlltable.asp, aspAlltable.exp);
etaSquared = tbl{2, 2}/tbl{4, 2}

%% Anova in experiment 1
aspTable1 = table();
subIdx = 1;
for subN = 1:size(data1.horizontalAnt, 3)
    if subN~=7 && subN~=11 && subN~=12
        if subN==2
            neutral1 = abs(nanmean(data1.horizontalAnt(:, 3, subN)));
            natural1 = abs(nanmean(data1.horizontalAnt(:, 1, subN)));
            unnatural1 = abs(nanmean(data1.horizontalAnt(:, 2, subN)));
            neutral2 = abs(nanmean(data1.horizontalAnt(:, 3, 12)));
            natural2 = abs(nanmean(data1.horizontalAnt(:, 1, 12)));
            unnatural2 = abs(nanmean(data1.horizontalAnt(:, 2, 12)));
            
            aspTable1.neutral(subIdx, 1) = mean([neutral1 neutral2]);
            aspTable1.natural(subIdx, 1) = mean([natural1 natural2]);
            aspTable1.unnatural(subIdx, 1) = mean([unnatural1 unnatural2]);
        elseif subN==3
            neutral1 = abs(nanmean(data1.horizontalAnt(:, 3, subN)));
            natural1 = abs(nanmean(data1.horizontalAnt(:, 1, subN)));
            unnatural1 = abs(nanmean(data1.horizontalAnt(:, 2, subN)));
            neutral2 = abs(nanmean(data1.horizontalAnt(:, 3, 7)));
            natural2 = abs(nanmean(data1.horizontalAnt(:, 1, 7)));
            unnatural2 = abs(nanmean(data1.horizontalAnt(:, 2, 7)));
            
            aspTable1.neutral(subIdx, 1) = mean([neutral1 neutral2]);
            aspTable1.natural(subIdx, 1) = mean([natural1 natural2]);
            aspTable1.unnatural(subIdx, 1) = mean([unnatural1 unnatural2]);
        elseif subN==4
            neutral1 = abs(nanmean(data1.horizontalAnt(:, 3, subN)));
            natural1 = abs(nanmean(data1.horizontalAnt(:, 1, subN)));
            unnatural1 = abs(nanmean(data1.horizontalAnt(:, 2, subN)));
            neutral2 = abs(nanmean(data1.horizontalAnt(:, 3, 11)));
            natural2 = abs(nanmean(data1.horizontalAnt(:, 1, 11)));
            unnatural2 = abs(nanmean(data1.horizontalAnt(:, 2, 11)));
            
            aspTable1.neutral(subIdx, 1) = mean([neutral1 neutral2]);
            aspTable1.natural(subIdx, 1) = mean([natural1 natural2]);
            aspTable1.unnatural(subIdx, 1) = mean([unnatural1 unnatural2]);
        else
            aspTable1.neutral(subIdx, 1) = abs(nanmean(data1.horizontalAnt(:, 3, subN)));
            aspTable1.natural(subIdx, 1) = abs(nanmean(data1.horizontalAnt(:, 1, subN)));
            aspTable1.unnatural(subIdx, 1) = abs(nanmean(data1.horizontalAnt(:, 2, subN)));
        end
        subIdx = subIdx+1;
    end
end
Meas = table([1 2 3]','VariableNames',{'Rotation'});
rm = fitrm(aspTable1,'neutral-unnatural~1','WithinDesign',Meas);
ranovatbl = ranova(rm)
etaSquared = ranovatbl.SumSq(1)/sum(ranovatbl.SumSq)

%% Anova in experiment 2
aspTable2 = table();
for subN = 1:size(data2.horizontalAnt, 3)
    aspTable2.neutral(subN, 1) = abs(nanmean(data2.horizontalAnt(:, 3, subN)));
    aspTable2.natural(subN, 1) = abs(nanmean(data2.horizontalAnt(:, 1, subN)));
    aspTable2.unnatural(subN, 1) = abs(nanmean(data2.horizontalAnt(:, 2, subN)));
end
Meas = table([1 2 3]','VariableNames',{'Rotation'});
rm = fitrm(aspTable2,'neutral-unnatural~1','WithinDesign',Meas);
ranovatbl = ranova(rm)
etaSquared = ranovatbl.SumSq(1)/sum(ranovatbl.SumSq)

%% anticipatory torsion
%% ANOVA in experiment 2
dataT2 = load('torsionAnt_exp16');
atTable2 = table();
for subN = 1:size(dataT2.torsionAnt, 3)
    atTable2.neutral(subN, 1) = abs(nanmean(dataT2.torsionAnt(:, 3, subN)));
    atTable2.natural(subN, 1) = abs(nanmean(dataT2.torsionAnt(:, 1, subN)));
    atTable2.unnatural(subN, 1) = abs(nanmean(dataT2.torsionAnt(:, 2, subN)));
end
Meas = table([1 2 3]','VariableNames',{'Rotation'});
rm = fitrm(atTable2,'neutral-unnatural~1','WithinDesign',Meas);
ranovatbl = ranova(rm)
etaSquared = ranovatbl.SumSq(1)/sum(ranovatbl.SumSq)

%% ANOVA in exp3
antiTtable = table();
% antiTtable.sub = names';
antiTtable.neutral = anticipatoryT(:, 1);
antiTtable.natural = anticipatoryT(:, 2);
Meas = table([1 2]','VariableNames',{'Rotation'});
rm = fitrm(antiTtable,'neutral-natural~1','WithinDesign',Meas);
ranovatbl = ranova(rm)
etaSquared = ranovatbl.SumSq(1)/sum(ranovatbl.SumSq)

%% bar plots
% calculate the group mean and ste
meanT = fliplr(mean(anticipatoryT)); % natural first, no rotation second
steT = fliplr(std(anticipatoryT)./sqrt(size(names, 2)));
meanP = fliplr(mean(anticipatoryP)); % natural first, no rotation second
steP = fliplr(std(anticipatoryP)./sqrt(size(names, 2)));

% anticipatory torsion
cd([torsionFolder])
figure
hold on
objB = bar([1 2], meanT, 0.5);
box off;
errorbar([1 2], meanT, steT, '.k')
for trialTypeI = 1:size(trialTypeCons, 2) % jittered individual data points
    x = (3-trialTypeI)*ones(size(names))-0.05+0.1*rand(size(names));
    plot(x, anticipatoryT(:, trialTypeI), '.k', 'MarkerSize', 10)
end
ylabel('Anticipatory torsional eye velocity (deg/s)')
ylim([-1 1])
xlim([0.5 2.5])
set(gca, 'XTick', [1 2], 'XTickLabel', {'Natural' 'No rotation'}, 'YTick', [-1 -0.5 0 0.5 1])
saveas(gca, ['anticipatoryT_bar_manuscript.pdf'])

% anticipatory pursuit
cd([pursuitFolder])
figure
hold on
objB = bar([1 2], meanP, 0.5);
box off;
errorbar([1 2], meanP, steP, '.k')
for trialTypeI = 1:size(trialTypeCons, 2) % jittered individual data points
    x = (3-trialTypeI)*ones(size(names))-0.05+0.1*rand(size(names));
    plot(x, anticipatoryP(:, trialTypeI), '.k', 'MarkerSize', 10)
end
ylabel('Anticipatory horizontal eye velocity (deg/s)')
ylim([0 4])
xlim([0.5 2.5])
set(gca, 'XTick', [1 2], 'XTickLabel', {'Natural' 'No rotation'}, 'YTick', [0 1 2 3 4])
saveas(gca, ['anticipatoryP_bar_manuscript.pdf'])

%% accumulative plots
for trialTypeI = 1:size(trialTypeCons, 2)
    accumT{trialTypeI} = NaN(size(names, 2), 200);
    accumP{trialTypeI} = NaN(size(names, 2), 200);
    for subN = 1:size(names, 2)
        data = trialData(trialData.sub==subN & trialData.trialType==trialTypeCons(trialTypeI), :); % all data of the participant
        for trialI = 1:200
            lastTrial = max(find(data.trial<=trialI));
            if isempty(lastTrial) % not having the first few trials
                accumT{trialTypeI}(subN, trialI) = NaN;
                accumP{trialTypeI}(subN, trialI) = NaN;
            else
                accumT{trialTypeI}(subN, trialI) = nanmean(data.anticipatoryTorsionVel(1:lastTrial).*data.translationalDirection(1:lastTrial));
                accumP{trialTypeI}(subN, trialI) = nanmean(-data.anticipatoryPursuitHVel(1:lastTrial).*data.translationalDirection(1:lastTrial));
            end
        end
    end
end

figure
% anticipatory torsion
cd([torsionFolder])
figure
hold on
box off;
for trialTypeI = 1:size(trialTypeCons, 2) % jittered individual data points
    plot(nanmean(accumT{trialTypeI}), 'color', colorPlot(trialTypeI, :))
end
line([0 200], [0 0], 'LineStyle', '--')
legend({'no rotation' 'natural'}, ...
    'location', 'northwest')
ylabel('Anticipatory torsional eye velocity (deg/s)')
ylim([-0.5 1])
xlim([0 200])
set(gca, 'XTick', [0:50:200], 'YTick', [-0.5:0.5:1])
saveas(gca, ['anticipatoryT_accumulative_manuscript.pdf'])

% anticipatory pursuit
cd([pursuitFolder])
figure
hold on
box off;
for trialTypeI = 1:size(trialTypeCons, 2) % jittered individual data points
    plot(nanmean(accumP{trialTypeI}), 'color', colorPlot(trialTypeI, :))
end
legend({'no rotation' 'natural'}, ...
    'location', 'northwest')
ylabel('Anticipatory horizontal eye velocity (deg/s)')
ylim([0 3])
xlim([0 200])
set(gca, 'XTick', [0:50:200], 'YTick', [0 1 2 3])
saveas(gca, ['anticipatoryP_accumulative_manuscript.pdf'])

%% correlation plots
% calculate mean of each sub
antiTCor = NaN(size(names, 2), 1);
vgTCor = NaN(size(names, 2), 1);
% first flip the orientations
for subN = 1:size(names, 2)
    idx = find(trialData.sub==subN & trialData.trialType==1); % natural rotation
    antiTCor(subN, 1) = nanmean(trialData.anticipatoryTorsionVel(idx).*trialData.translationalDirection(idx));
    vgTCor(subN, 1) = nanmean(trialData.torsionVel(idx).*trialData.translationalDirection(idx));
end
[rho pvalue] = corr(vgTCor, antiTCor)

cd(analysisFolder)
figure
hold on
box off; 
plot(vgTCor, antiTCor, '^') % only natural
lsline
line([-5 5], [0 0], 'LineStyle', '--')
line([0 0], [-1.5 1.5], 'LineStyle', '--')
xlabel('Visually-guided torsion (deg/s)')
ylabel('Anticipatory torsion (deg/s)')
ylim([-1.5 1.5])
xlim([-5 5])
set(gca, 'XTick', [-5:2.5:5], 'YTick', [-1.5:0.5:1.5])
saveas(gca, ['corr_antiT&T_manuscript.pdf'])

%% psychometric function
% fitting settings
PF = @PAL_Logistic;  %Alternatives: PAL_Gumbel, PAL_Weibull,
%PAL_Quick, PAL_logQuick, PAL_Logistic
%PAL_CumulativeNormal, PAL_HyperbolicSecant
%Threshold, Slope, and lapse rate are free parameters, guess is fixed
paramsFree = [1 1 0 1];  %1: free parameter, 0: fixed parameter
%Parameter grid defining parameter space through which to perform a
%brute-force search for values to be used as initial guesses in iterative
%parameter search.
searchGrid.alpha = 0.01:.001:.11;
searchGrid.beta = logspace(0,3,101);
searchGrid.gamma = 0;  %scalar here (since fixed) but may be vector
searchGrid.lambda = 0:0.001:0.05;  %ditto

numbRightSub = NaN(size(names, 2), 5);
outOfNumSub = NaN(size(names, 2), 5);
for subN = 1:size(names, 2)
    data = trialData(trialData.sub==subN & trialData.trialType==1, :); % rotation trials
    data.rotationSpeed = round(data.rotationSpeed);
    speedCons = unique(data.rotationSpeed);
    for speedI = 1:length(speedCons)
        idx = find(data.rotationSpeed==speedCons(speedI));
        outOfNumSub(subN, speedI) = length(idx);
        idxR = find(data.rotationSpeed==speedCons(speedI) & data.choice==1); % report faster
        numbRightSub(subN, speedI) = length(idxR);
    end
end

% fit and plot all
numbRight = round(nanmean(numbRightSub./outOfNumSub)*100); % calculate the percentage
outOfNum = 100*ones(size(numbRight));
paramsValues = PAL_PFML_Fit(speedCons, numbRight', outOfNum', searchGrid, paramsFree, PF);

% plotting
ProportionCorrectObserved=numbRight./outOfNum;
StimLevelsFineGrain=[min(speedCons):max(speedCons)./1000:max(speedCons)];
ProportionCorrectModel = PF(paramsValues,StimLevelsFineGrain);

cd(analysisFolder)
% plot
figure
hold on
plot(StimLevelsFineGrain, ProportionCorrectModel,'-', 'linewidth', 2);
plot(repmat(speedCons', size(names, 2), 1), numbRightSub./outOfNumSub, '^')
set(gca, 'fontsize',16);
set(gca, 'Xtick', speedCons);
ylim([0 1])
xlabel('Stimulus Intensity');
ylabel('Proportion right');
hold off
saveas(gcf, ['pf_all.pdf'])
