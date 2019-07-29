% plot velocity traces, generate csv file for plotting in R, Exp3
% anticipatory torsion control
initializeParas;
startT = 1;
individualPlots = 0;
averagedPlots = 1;

%% Experimental trials
for subN = startT:size(names, 2)
    %% Eye velocity bar plots
    % anticipatory torsion/pursuit, right minus left moving trials
    % rows are subs, first column is baseline, second column is exp trials
    for trialTypeI = 1:size(trialTypeCons, 2)
        data = trialData(trialData.sub==subN & trialData.trialType==trialTypeCons(trialTypeI), :);
        leftIdx = find(data.translationalDirection==-1);
        rightIdx = find(data.translationalDirection==1);
        anticipatoryTorsion{trialTypeI}(subN, 1) = nanmean(data.anticipatoryTorsionVel(leftIdx));
        anticipatoryTorsion{trialTypeI}(subN, 2) = nanmean(data.anticipatoryTorsionVel(rightIdx));
        anticipatoryPursuit{trialTypeI}(subN, 1) = nanmean(data.anticipatoryPursuitHVel(leftIdx));
        anticipatoryPursuit{trialTypeI}(subN, 2) = nanmean(data.anticipatoryPursuitHVel(rightIdx));
        % trial info
        maxLength = max(length(leftIdx), length(rightIdx));
        atTrial{subN, trialTypeI} = NaN(maxLength, 2);
        atTrial{subN, trialTypeI}(1:length(leftIdx), 1) = data.anticipatoryTorsionVel(leftIdx);
        atTrial{subN, trialTypeI}(1:length(rightIdx), 2) = data.anticipatoryTorsionVel(rightIdx);
        apTrial{subN, trialTypeI} = NaN(maxLength, 2);
        apTrial{subN, trialTypeI}(1:length(leftIdx), 1) = data.anticipatoryPursuitHVel(leftIdx);
        apTrial{subN, trialTypeI}(1:length(rightIdx), 2) = data.anticipatoryPursuitHVel(rightIdx);
    end
    
    %% plots of individual data
    if individualPlots==1
        % torsion plots
        cd([torsionFolder '\individuals'])
        % anticipatory torsion, box plot of trials?...
        figure
        for trialTypeI = 1:size(trialTypeCons, 2)
            subplot(1, 2, trialTypeI)
            hold on
            % filtered mean velocity trace
            boxplot(atTrial{subN, trialTypeI}, {'left moving' 'right moving'})
            title([trialTypeNames{trialTypeI}])
            xlabel('Moving direction')
            ylabel('Anticipatory torsional velocity (deg/s)')
            % ylim([-0.5 0.5])
        end
        saveas(gca, ['anticipatoryT_', names{subN}, '.pdf'])
        
        cd([pursuitFolder '\individuals'])
        % anticipatory torsion, box plot of trials?...
        figure
        for trialTypeI = 1:size(trialTypeCons, 2)
            subplot(1, 2, trialTypeI)
            hold on
            % filtered mean velocity trace
            boxplot(apTrial{subN, trialTypeI}, {'left moving' 'right moving'})
            title([trialTypeNames{trialTypeI}])
            xlabel('Moving direction')
            ylabel('Anticipatory pursuit horizontal velocity (deg/s)')
            % ylim([-0.5 0.5])
        end
        saveas(gca, ['anticipatoryP_', names{subN}, '.pdf'])
    end
end

%% averaged plots
if averagedPlots==1
    % calculate the group mean and ste
    cd([torsionFolder])
    % define anticipatory torsion as difference between left and right--to
    % enlarge the tiny effect...
    % (exp r-l) - (baseline r-l)
    figure
    hold on
    for trialTypeI = 1:size(trialTypeCons, 2)
    diffAT(:, trialTypeI) = anticipatoryTorsion{trialTypeI}(:, 2)-anticipatoryTorsion{trialTypeI}(:, 1);
    end
    errorbar([1, 2], mean(diffAT), std(diffAT)/sqrt(length(names)))
    for subN = 1:length(names)
        p{subN} = plot([1, 2], diffAT(subN, :), '--')
    end    
    xlim([0.5, 2.5])
    legend([p{:}], names, 'location', 'best')
    set(gca, 'XTick', [1, 2], 'XTickLabels', {'without rotation', 'with rotation'})
    xlabel('Trial type')
    ylabel('Anticipatory torsion horizontal velocity right-left (deg/s)')
    %     ylim([-1 0.6])
    saveas(gca, ['anticipatoryT_diff_trialTypes_all.pdf'])
    
    % anticipatory torsion
    figure
    for trialTypeI = 1:size(trialTypeCons, 2)
        subplot(1, 2, trialTypeI)
        hold on
        errorbar([1, 2], mean(anticipatoryTorsion{trialTypeI}), std(anticipatoryTorsion{trialTypeI})/sqrt(length(names)))
        for subN = 1:length(names)
            p{subN} = plot([1, 2], anticipatoryTorsion{trialTypeI}(subN, :), '--')
        end
        xlim([0.5, 2.5])
        legend([p{:}], names, 'location', 'best')
        set(gca, 'XTick', [1, 2], 'XTickLabels', {'left moving', 'right moving'})
        title([trialTypeNames{trialTypeI}])
        xlabel('Moving direction')
        ylabel('Anticipatory torsion horizontal velocity (deg/s)')
        ylim([-1 0.6])
    end
    saveas(gca, ['anticipatoryT_all.pdf'])
    
    cd([pursuitFolder])
    % define anticipatory torsion as difference between left and right--to
    % enlarge the tiny effect...
    % (exp r-l) - (baseline r-l)
    figure
    hold on
    for trialTypeI = 1:size(trialTypeCons, 2)
    diffAP(:, trialTypeI) = anticipatoryPursuit{trialTypeI}(:, 2)-anticipatoryPursuit{trialTypeI}(:, 1);
    end
    errorbar([1, 2], mean(diffAP), std(diffAP)/sqrt(length(names)))
    for subN = 1:length(names)
        p{subN} = plot([1, 2], diffAP(subN, :), '--')
    end    
    xlim([0.5, 2.5])
    legend([p{:}], names, 'location', 'best')
    set(gca, 'XTick', [1, 2], 'XTickLabels', {'without rotation', 'with rotation'})
    xlabel('Trial type')
    ylabel('Anticipatory pursuit horizontal velocity right-left (deg/s)')
    %     ylim([-1 0.6])
    saveas(gca, ['anticipatoryP_diff_trialTypes_all.pdf'])
    
    % anticipatory pursuit
    figure
    for trialTypeI = 1:size(trialTypeCons, 2)
        subplot(1, 2, trialTypeI)
        hold on
        errorbar([1, 2], mean(anticipatoryPursuit{trialTypeI}), std(anticipatoryPursuit{trialTypeI})/sqrt(length(names)))
        for subN = 1:length(names)
            p{subN} = plot([1, 2], anticipatoryPursuit{trialTypeI}(subN, :), '--')
        end
        xlim([0.5, 2.5])
        legend([p{:}], names, 'location', 'best')
        set(gca, 'XTick', [1, 2], 'XTickLabels', {'left moving', 'right moving'})
        title([trialTypeNames{trialTypeI}])
        xlabel('Moving direction')
        ylabel('Anticipatory pursuit horizontal velocity (deg/s)')
        ylim([-2.5 2])
    end
    saveas(gca, ['anticipatoryP_all.pdf'])
end