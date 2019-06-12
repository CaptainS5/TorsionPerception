% Draw plots, Exp3
% Xiuyun Wu, 03/08/2019
clear all; close all; clc

names = {'XW3' 'DC3' 'AR3' 'JF3' 'PK3' 'AD3' 'PH3'};
conditions = [200]; % rotationSpeed
startT = 1; % start from which participant for individual plots
individualPlots = 0; % whether plot individual data
averagedPlots = 0;
baselinePlots = 1;
% merged = 1;
dirCons = [-1 1]; % after reversal directions
dirNames = {'CCW' 'CW'};
headCons = [-1 0 1];
trialPerCon = 20; % for each head tilt, directions separated
eyeName = {'L' 'R'};
endName = 'BeforeReversal'; % from beginning of stimulus to reversal
% endName = 'AfterReversal';
colorPlot = [0 0 0; 0.5 0.5 0.5];
for t = 1:size(names, 2)
        if t<=2
            markerC(t, :) = (t+2)/4*[77 255 202]/255;
        elseif t<=4
            markerC(t, :) = (t)/4*[70 95 232]/255;
        elseif t<=6
            markerC(t, :) = (t-2)/4*[232 123 70]/255;
        elseif t<=8
            markerC(t, :) = (t-4)/4*[255 231 108]/255;
        elseif t<=10
            markerC(t, :) = (t-6)/4*[255 90 255]/255;
        end
    end
fontSize = 15;

% if merged==0
%     mergeName = 'notMerged';
% else
%     mergeName = 'merged';
% end
load(['dataLong', endName, '.mat'])
load(['dataLongBase.mat'])

cd ..
analysisF = pwd;

%% Experimental trials
for t = startT:size(names, 2)
    data = trialData(trialData.sub==t, :);
    
    %% Perception and torsion plots
    % head tilt and direction separated
    headIdx = unique(data.headTilt);
    if headIdx(1)==0
        headIdx= [1 0];
    end
    headSub{t} = headIdx;
    for headI = 1:length(headIdx)
        for dirI = 1:2
            %                 hI = find(headCons==headIdx(headI));
            dataT = data(data.afterReversalD==(dirCons(dirI)) & data.headTilt==(headIdx(headI)), :);
            meanSub{t}.percept(headI, dirI) = mean(dataT.perceptualError);
            medianSub{t}.percept(headI, dirI) = median(dataT.perceptualError);
            stdSub{t}.percept(headI, dirI) = std(dataT.perceptualError);
            meanSub{t}.torsionVelT(headI, dirI) = mean(dataT.torsionVelT.*dataT.afterReversalD);
            stdSub{t}.torsionVelT(headI, dirI) = std(dataT.torsionVelT.*dataT.afterReversalD);
            meanSub{t}.torsionAngle(headI, dirI) = mean(dataT.torsionAngle.*dataT.afterReversalD);
            stdSub{t}.torsionAngle(headI, dirI) = std(dataT.torsionAngle.*dataT.afterReversalD);
            meanSub{t}.torsionPosition(headI, dirI) = mean(dataT.torsionPosition.*dataT.afterReversalD);
            stdSub{t}.torsionPosition(headI, dirI) = std(dataT.torsionPosition.*dataT.afterReversalD);
        end
        dataT = data(data.headTilt==(headIdx(headI)), :);
        meanSubM.percept(t, headI) = mean(dataT.perceptualError);
        medianSubM.percept(t, headI) = median(dataT.perceptualError);
        %         meanSubM.percept(t, headI) = mean(meanSub{t}.percept(headI, :));
        %         medianSubM.percept(t, headI) = mean(medianSub{t}.percept(headI, :));
        stdSubM.percept(t, headI) = std(dataT.perceptualError);
        meanSubM.torsionVelT(t, headI) = mean(dataT.torsionVelT.*dataT.afterReversalD);
        stdSubM.torsionVelT(t, headI) = std(dataT.torsionVelT.*dataT.afterReversalD);
        meanSubM.torsionAngle(t, headI) = mean(dataT.torsionAngle.*dataT.afterReversalD);
        stdSubM.torsionAngle(t, headI) = std(dataT.torsionAngle.*dataT.afterReversalD);
        meanSubM.torsionPosition(t, headI) = mean(dataT.torsionPosition.*dataT.afterReversalD);
        stdSubM.torsionPosition(t, headI) = std(dataT.torsionPosition.*dataT.afterReversalD);
    end
    
    %% plots of individual data
    if individualPlots==1
        cd([analysisF '\torsionPlots'])
        % perceptual data
        figure
        eyeN = 2; % 2-right
        errorbar(headIdx, meanSub{t}.percept(:, 1), stdSub{t}.percept(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        hold on
        errorbar(headIdx, meanSub{t}.percept(:, 2), stdSub{t}.percept(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        plot(headIdx, medianSub{t}.percept(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(2, :))
        plot(headIdx, medianSub{t}.percept(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(2, :))
        legend({'afterD CCW-mean' 'afterD CW-mean' 'afterD CCW-median' 'afterD CW-median'}, 'box', 'off', 'Location', 'northwest')
        xlabel('Head tilt direction')
        ylabel('Perceived shift in direction (deg)')
        set(gca, 'FontSize', 15, 'box', 'off')
        %             xlim([0 420])
        %         ylim([-25 25])
        %         title([eyeName{eye}, ' eye'])
        saveas(gca, ['perceptualError_' names{t} '.pdf'])
        
        %         % torsion velocity, direction not merged
        %         figure
        %         eyeN = 2; % 2-right
        %         errorbar(headIdx, meanSub{t}.torsionVelT(:, 1), stdSub{t}.torsionVelT(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         hold on
        %         errorbar(headIdx, meanSub{t}.torsionVelT(:, 2), stdSub{t}.torsionVelT(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         legend({'afterD CCW' 'afterD CW'}, 'box', 'off', 'Location', 'northwest')
        %         xlabel('Head tilt direction')
        %         ylabel('Torsional velocity (?/s)')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         %             xlim([0 420])
        %         %         ylim([-25 25])
        %         title([endName])
        %         saveas(gca, ['torsionVelT_notMerged_' names{t} '_' endName '.pdf'])
        
        %         % torsion velocity, direction merged
        %         figure
        %         eyeN = 2; % 2-right
        %         errorbar(headIdx, abs(meanSubM{t}.torsionVelT(:, 1)), stdSubM{t}.torsionVelT(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         xlabel('Head tilt direction')
        %         ylabel('Torsional velocity (abs) (?/s)')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         %             xlim([0 420])
        %         %         ylim([-25 25])
        %         title([endName])
        %         saveas(gca, ['torsionVelT_merged_' names{t} '_' endName '.pdf'])
        
        %         % torsion angle, direction not merged
        %         figure
        %         eyeN = 2; % 2-right
        %         errorbar(headIdx, meanSub{t}.torsionAngle(:, 1), stdSub{t}.torsionAngle(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         hold on
        %         errorbar(headIdx, meanSub{t}.torsionAngle(:, 2), stdSub{t}.torsionAngle(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         legend({'afterD CCW' 'afterD CW'}, 'box', 'off', 'Location', 'northwest')
        %         xlabel('Head tilt direction')
        %         ylabel('Torsional angle (deg)')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         %             xlim([0 420])
        %         %         ylim([-25 25])
        %         title([endName])
        %         saveas(gca, ['torsionAngle_notMerged_' names{t} '_' endName '.pdf'])
        
        %         % torsion angle, direction merged
        %         figure
        %         eyeN = 2; % 2-right
        %         errorbar(headIdx, abs(meanSubM{t}.torsionAngle(:, 1)), stdSubM{t}.torsionAngle(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         xlabel('Head tilt direction')
        %         ylabel('Torsional angle (abs) (deg)')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         %             xlim([0 420])
        %         %         ylim([-25 25])
        %         title([endName])
        %         saveas(gca, ['torsionAngle_merged_' names{t} '_' endName '.pdf'])
        
        %         % torsion position, direction not merged
        %         figure
        %         eyeN = 2; % 2-right
        %         errorbar(headIdx, meanSub{t}.torsionPosition(:, 1), stdSub{t}.torsionPosition(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         hold on
        %         errorbar(headIdx, meanSub{t}.torsionPosition(:, 2), stdSub{t}.torsionPosition(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         legend({'afterD CCW' 'afterD CW'}, 'box', 'off', 'Location', 'northwest')
        %         xlabel('Head tilt direction')
        %         ylabel('Torsional position (deg)')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         %             xlim([0 420])
        %         %         ylim([-25 25])
        %         saveas(gca, ['torsionPosition_notMerged_' names{t} '.pdf'])
        
        %         % torsion position, direction merged
        %         figure
        %         eyeN = 2; % 2-right
        %         errorbar(headIdx, abs(meanSubM{t}.torsionPosition(:, 1)), stdSubM{t}.torsionPosition(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         xlabel('Head tilt direction')
        %         ylabel('Torsional position (deg)')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         %             xlim([0 420])
        %         %         ylim([-25 25])
        %         saveas(gca, ['torsionPosition_merged_' names{t} '.pdf'])
        
        %% Correlation plots
        %         cd([analysisF '\correlationPlots\individual'])
        %         %         torsion velocity trial correlation with perception, merged direction
        %         figure
        %         eyeN = 2; % right eye
        %         scatter(data.perceptualError, data.torsionVelT.*data.afterReversalD, 'LineWidth', 1)
        %         xlabel('Perceptual errors (deg)')
        %         ylabel('Torsion velocity (deg/s)')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         %             xlim([0 420])
        %         %             ylim([-2 2])
        %         %         [rho pval] = corr(trialData.torsionVelTMerged(tempI, 1), trialData.perceptualError(tempI, 1));
        %         %         title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
        %         saveas(gca, ['trialCorrelationVelocity&Perception_dirMerged_' names{t} '_' endName '.pdf'])
        %         %
        %         % torsion velocity trial correlation with perception,
        %         % direction not merged
        %         figure
        %         eyeN = 2; % right eye
        %         subplot(1, 2, 1)
        %         tempI = find(data.afterReversalD==1);
        %         scatter(data.perceptualError(tempI, :), data.torsionVelT(tempI, :), 'LineWidth', 1)
        %         xlabel('Perceptual errors (deg)')
        %         ylabel('Torsion velocity (deg/s)')
        %         title('afterD CW')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         axis square
        %
        %         subplot(1, 2, 2)
        %         tempI = find(data.afterReversalD==-1);
        %         scatter(data.perceptualError(tempI, :), data.torsionVelT(tempI, :), 'LineWidth', 1)
        %         xlabel('Perceptual errors (deg)')
        %         ylabel('Torsion velocity (deg/s)')
        %         title('afterD CCW')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         axis square
        %         %         %             xlim([0 420])
        %         %         %             ylim([-2 2])
        %         %         %         [rho pval] = corr(trialData.torsionVelTMerged(tempI, 1), trialData.perceptualError(tempI, 1));
        %         %         %         title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
        %         saveas(gca, ['trialCorrelationVelocity&Perception_dirNotMerged_' names{t} '_' endName '.pdf'])
        %         %
        %         %         % torsion angle trial correlation with perception, merged direction
        %         %         figure
        %         %         for eye = 1:size(eyeName, 2)
        %         %             subplot(1, size(eyeName, 2), eye)
        %         %             if strcmp(eyeName{eye}, 'L')
        %         %                 eyeN = 1; % 1-left,
        %         %             elseif strcmp(eyeName{eye}, 'R')
        %         %                 eyeN = 2; % 2-right
        %         %             end
        %         %
        %         %             tempI = find(trialData.sub==t & trialData.eye==eyeN); % clockwise
        %         %
        %         %             scatter(trialData.torsionAngleMerged(tempI, 1), trialData.perceptualError(tempI, 1), 'LineWidth', 1)
        %         %             ylabel('Perceptual errors (deg)')
        %         %             xlabel('Torsion angle (deg)')
        %         %             set(gca, 'FontSize', 15, 'box', 'off')
        %         %             %             xlim([0 420])
        %         %             %             ylim([-2 2])
        %         %             [rho pval] = corr(trialData.torsionAngleMerged(tempI, 1), trialData.perceptualError(tempI, 1));
        %         %             title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
        %         %         end
        %         %         saveas(gca, ['trialCorrelationAngle&perception_' names{t} '_' endName '.pdf'])
        
        %% Saccade plots
        %         cd([analysisF '\SaccadePlots'])
        %         close all
    end
end
%% Baseline plots
if baselinePlots==1    
    for t = startT:size(names, 2)
        data = trialDataBase(trialDataBase.sub==t, :);
        
        % head tilt and direction separated
        headIdx = unique(data.headTilt);
        if headIdx(1)==0
            headIdx= [1 0];
        end
        for headI = 1:length(headIdx)
            for dirI = 1:2
                dataT = data(data.afterReversalD==(dirCons(dirI)) & data.headTilt==(headIdx(headI)), :);
                meanSubBase{t}.torsionVelT(headI, dirI) = mean(dataT.torsionVelT.*dataT.afterReversalD);
                stdSubBase{t}.torsionVelT(headI, dirI) = std(dataT.torsionVelT.*dataT.afterReversalD);
            end
            dataT = data(data.headTilt==(headIdx(headI)), :);
            meanSubBaseM.torsionVelT(t, headI) = mean(dataT.torsionVelT.*dataT.afterReversalD);
            stdSubBaseM.torsionVelT(t, headI) = std(dataT.torsionVelT.*dataT.afterReversalD);
        end
        % % individual plots
%         cd([analysisF '\baselinePlots'])
        %     % torsion velocity
        %     figure
        %     eyeN = 2; % 2-right
        %     errorbar(headIdx, meanSubBase{t}.torsionVelT(:, 1), stdSubBase{t}.torsionVelT(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %     hold on
        %     errorbar(headIdx, meanSubBase{t}.torsionVelT(:, 2), stdSubBase{t}.torsionVelT(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %     legend({'visual CCW' 'visual CW'}, 'box', 'off', 'Location', 'northwest')
        %     xlabel('Head tilt direction')
        %     ylabel('Torsional velocity (?/s)')
        %     set(gca, 'FontSize', 15, 'box', 'off')
        %     %             xlim([0 420])
        %     %         ylim([-25 25])
        %     saveas(gca, ['torsionVelTBase_' names{t} '.pdf'])
    end
    
    % summary plots
    cd([analysisF '\summaryPlots'])
    % torsionV, directions merged based on physical CW and CCW
    % all participants have CW data eventually
    figure
    box off
    for subN = 1:size(names, 2)
        hold on
        p{subN} = plot([-1 0], meanSubBaseM.torsionVelT(subN, :), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
%         p{subN} = errorbar([-1 0], meanSubBaseM.torsionVelT(subN, :), stdSubBaseM.torsionVelT(subN, :), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
    end
    p{subN+1} = errorbar([-1 0], mean(meanSubBaseM.torsionVelT), std(meanSubBaseM.torsionVelT), '-x', 'LineWidth', 1, 'color', [0 0 0]);
    legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}, p{8}], [names {'mean'}], 'box', 'off', 'Location', 'northwest')
    ylim([0 3])
%     ylim([-3 0])
    xlim([-1.5 0.5])
    xlabel('Head tilt direction')
    ylabel('Torsional velocity (°/s)')
    set(gca, 'FontSize', fontSize, 'box', 'off')
    saveas(gca, ['all_torsionVBase_merged.pdf'])
    
    % torsionV, directions not merged, grouped by physical dir
    figure
    box off
    for dirI = 1:2
        subplot(1, 2, dirI)
        for subN = 1:size(names, 2)
            hold on
%             p{subN} = errorbar([-1 0], meanSubBase{subN}.torsionVelT(:, dirI), stdSubBase{subN}.torsionVelT(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
            p{subN} = plot([-1 0], meanSubBase{subN}.torsionVelT(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
            tempSub{dirI}(subN, :) = meanSubBase{subN}.torsionVelT(:, dirI);
        end
        p{subN+1} = errorbar([-1 0], mean(tempSub{dirI}), std(tempSub{dirI}), '-x', 'LineWidth', 1, 'color', [0 0 0]);
%         legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}, p{8}], [names {'mean'}], 'box', 'off', 'Location', 'northwest')
        ylim([0 3])
%         ylim([-3 0])
        xlim([-1.5 0.5])
        title(['visual dir ' dirNames{dirI}])
        xlabel('Head tilt direction')
        ylabel('Torsional velocity (°/s)')
        set(gca, 'FontSize', fontSize, 'box', 'off')
    end
    saveas(gca, ['all_torsionVBase_notMergedPhysicalDir.pdf'])
    
    % torsionV, directions not merged, grouped by consistency with
    % OCR
    figure
    box off
    for dirC = 1:2
        subplot(1, 2, dirC)
        for subN = 1:size(names, 2)
            hold on
            if headSub{subN}(1)==1 % OCR CCW
                headSubTemp = [-1 0];
                if dirC==1
                    dirI = 1; % visual CCW
                else
                    dirI = 2;
                end
            elseif headSub{subN}(1)==-1 % OCR CW
                if dirC==1
                    dirI = 2; % visual CW
                else
                    dirI = 1;
                end
            end
            p{subN} = plot([-1 0], meanSubBase{subN}.torsionVelT(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
%             p{subN} = errorbar([-1 0], meanSubBase{subN}.torsionVelT(:, dirI), stdSubBase{subN}.torsionVelT(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
            tempSub{dirC}(subN, :) = meanSubBase{subN}.torsionVelT(:, dirI);
        end
        p{subN+1} = errorbar([-1 0], mean(tempSub{dirC}), std(tempSub{dirC}), '-x', 'LineWidth', 1, 'color', [0 0 0]);
%         legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}, p{8}], [names {'mean'}], 'box', 'off', 'Location', 'northwest')
        ylim([0 3])
%         ylim([-3 0])
        xlim([-1.5 0.5])
        if dirC==1
            title(['visual dir in OCR'])
        else
            title(['visual dir against OCR'])
        end
        xlabel('Head tilt direction')
        ylabel('Torsional velocity (°/s)')
        set(gca, 'FontSize', fontSize, 'box', 'off')
    end
    saveas(gca, ['all_torsionVBase_notMergedOCR.pdf'])
end

%% averaged plots
if averagedPlots==1
    %     % torsionV/perceptual error/torsionVGain vs. speed, scatter
    %     colorPlot = [232 71 12; 2 255 44; 12 76 150; 140 0 255; 255 212 13]/255;
    
    %% summary plots
    cd([analysisF '\summaryPlots'])
    %     % perception, directions merged based on physical CW and CCW
    %     % all participants have CW data eventually
    %     figure
    %     box off
    %     for subN = 1:size(names, 2)
    %         hold on
    %         if headSub{subN}(1)==1
    %             headSubTemp = [-1 0];
    %             p{subN} = plot(headSubTemp, meanSubM.percept(subN, :), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
    %         elseif headSub{subN}(1)==-1
    %             p{subN} = plot(headSub{subN}, meanSubM.percept(subN, :), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
    %         end
    %     end
    %     p{subN+1} = errorbar([-1 0], mean(meanSubM.percept), std(meanSubM.percept), '-x', 'LineWidth', 1, 'color', [0 0 0]);
    %     legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}, p{8}], [names {'mean of means'}], 'box', 'off', 'Location', 'northwest')
    %     %         ylim([-25, 25])
    %     xlim([-1.5 0.5])
    %     xlabel('Head tilt direction')
    %     ylabel('Perceived shift in direction (°)')
    %     set(gca, 'FontSize', fontSize, 'box', 'off')
    %     saveas(gca, ['all_perception_merged_meanMean.pdf'])
    
    % % perception, directions not merged, grouped by physical dir
    %     figure
    %     box off
    %     for dirI = 1:2
    %         subplot(1, 2, dirI)
    %         for subN = 1:size(names, 2)
    %             hold on
    %             if headSub{subN}(1)==1
    %                 headSubTemp = [-1 0];
    %                 p{subN} = plot(headSubTemp, meanSub{subN}.percept(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
    %             elseif headSub{subN}(1)==-1
    %                 p{subN} = plot(headSub{subN}, meanSub{subN}.percept(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
    %             end
    %             tempSub{dirI}(subN, :) = meanSub{subN}.percept(:, dirI);
    %         end
    %         p{subN+1} = errorbar([-1 0], mean(tempSub{dirI}), std(tempSub{dirI}), '-x', 'LineWidth', 1, 'color', [0 0 0]);
    %         legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}, p{8}], [names {'mean of means'}], 'box', 'off', 'Location', 'northwest')
    %         ylim([-1, 20])
    %         xlim([-1.5 0.5])
    %         title(['visual dir ' dirNames{dirI}])
    %         xlabel('Head tilt direction')
    %         ylabel('Perceived shift in direction (°)')
    %         set(gca, 'FontSize', fontSize, 'box', 'off')
    %     end
    %     saveas(gca, ['all_perception_notMergedPhysicalDirMean.pdf'])
    %
    % % perception, directions not merged, grouped by consistency with
    %     % OCR
    %     figure
    %     box off
    %     for dirC = 1:2
    %         subplot(1, 2, dirC)
    %         for subN = 1:size(names, 2)
    %             hold on
    %             if headSub{subN}(1)==1 % OCR CCW
    %                 headSubTemp = [-1 0];
    %                 if dirC==1
    %                     dirI = 1; % visual CCW
    %                 else
    %                     dirI = 2;
    %                 end
    %                 p{subN} = plot(headSubTemp, meanSub{subN}.percept(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
    %             elseif headSub{subN}(1)==-1 % OCR CW
    %                 if dirC==1
    %                     dirI = 2; % visual CW
    %                 else
    %                     dirI = 1;
    %                 end
    %                 p{subN} = plot(headSub{subN}, meanSub{subN}.percept(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
    %             end
    %             tempSub{dirC}(subN, :) = meanSub{subN}.percept(:, dirI);
    %         end
    %         p{subN+1} = errorbar([-1 0], mean(tempSub{dirC}), std(tempSub{dirC}), '-x', 'LineWidth', 1, 'color', [0 0 0]);
    %         legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}, p{8}], [names {'mean of means'}], 'box', 'off', 'Location', 'northwest')
    %         ylim([-1, 20])
    %         xlim([-1.5 0.5])
    %         if dirC==1
    %             title(['visual dir in OCR'])
    %         else
    %             title(['visual dir against OCR'])
    %         end
    %         xlabel('Head tilt direction')
    %         ylabel('Perceived shift in direction (°)')
    %         set(gca, 'FontSize', fontSize, 'box', 'off')
    %     end
    %     saveas(gca, ['all_perception_notMergedOCRmean.pdf'])
    
%         % torsionV, directions merged based on physical CW and CCW
%         % all participants have CW data eventually
%         figure
%         box off
%         for subN = 1:size(names, 2)
%             hold on
%                     p{subN} = plot([-1 0], meanSubM.torsionVelT(subN, :), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
%     %         p{subN} = errorbar([-1 0], meanSubM.torsionVelT(subN, :), stdSubM.torsionVelT(subN, :), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
%         end
%         p{subN+1} = errorbar([-1 0], mean(meanSubM.torsionVelT), std(meanSubM.torsionVelT), '-x', 'LineWidth', 1, 'color', [0 0 0]);
%         legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}, p{8}], [names {'mean'}], 'box', 'off', 'Location', 'northwest')
%         %             ylim([0 3])
%         ylim([-3 0])
%         xlim([-1.5 0.5])
%         xlabel('Head tilt direction')
%         ylabel('Torsional velocity (°/s)')
%         set(gca, 'FontSize', fontSize, 'box', 'off')
%         saveas(gca, ['all_torsionV_merged' endName '.pdf'])
%     
%         % torsionV, directions not merged, grouped by physical dir
%         figure
%         box off
%         for dirI = 1:2
%             subplot(1, 2, dirI)
%             for subN = 1:size(names, 2)
%                 hold on
%     %             p{subN} = errorbar([-1 0], meanSub{subN}.torsionVelT(:, dirI), stdSub{subN}.torsionVelT(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
%                 p{subN} = plot([-1 0], meanSub{subN}.torsionVelT(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
%                 tempSub{dirI}(subN, :) = meanSub{subN}.torsionVelT(:, dirI);
%             end
%             p{subN+1} = errorbar([-1 0], mean(tempSub{dirI}), std(tempSub{dirI}), '-x', 'LineWidth', 1, 'color', [0 0 0]);
%             legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}, p{8}], [names {'mean'}], 'box', 'off', 'Location', 'northwest')
%             %             ylim([0 3])
%             ylim([-3 0])
%             xlim([-1.5 0.5])
%             title(['visual dir ' dirNames{dirI}])
%             xlabel('Head tilt direction')
%             ylabel('Torsional velocity (°/s)')
%             set(gca, 'FontSize', fontSize, 'box', 'off')
%         end
%         saveas(gca, ['all_torsionV_notMergedPhysicalDir' endName '.pdf'])
%     
%         % torsionV, directions not merged, grouped by consistency with
%         % OCR
%         figure
%         box off
%         for dirC = 1:2
%             subplot(1, 2, dirC)
%             for subN = 1:size(names, 2)
%                 hold on
%                 if headSub{subN}(1)==1 % OCR CCW
%                     headSubTemp = [-1 0];
%                     if dirC==1
%                         dirI = 1; % visual CCW
%                     else
%                         dirI = 2;
%                     end
%                 elseif headSub{subN}(1)==-1 % OCR CW
%                     if dirC==1
%                         dirI = 2; % visual CW
%                     else
%                         dirI = 1;
%                     end
%                 end
%                                 p{subN} = plot([-1 0], meanSub{subN}.torsionVelT(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
%     %             p{subN} = errorbar([-1 0], meanSub{subN}.torsionVelT(:, dirI), stdSub{subN}.torsionVelT(:, dirI), '--o', 'LineWidth', 1, 'color', markerC(subN, :));
%                 tempSub{dirC}(subN, :) = meanSub{subN}.torsionVelT(:, dirI);
%             end
%             p{subN+1} = errorbar([-1 0], mean(tempSub{dirC}), std(tempSub{dirC}), '-x', 'LineWidth', 1, 'color', [0 0 0]);
%             legend([p{1}, p{2}, p{3}, p{4}, p{5}, p{6}, p{7}, p{8}], [names {'mean'}], 'box', 'off', 'Location', 'northwest')
%             %             ylim([0 3])
%             ylim([-3 0])
%             xlim([-1.5 0.5])
%             if dirC==1
%                 title(['visual dir in OCR'])
%             else
%                 title(['visual dir against OCR'])
%             end
%             xlabel('Head tilt direction')
%             ylabel('Torsional velocity (°/s)')
%             set(gca, 'FontSize', fontSize, 'box', 'off')
%         end
%         saveas(gca, ['all_torsionV_notMergedOCR' endName '.pdf'])
    
    %% Correlation of difference plots
%     % calculate the difference between head up and head tilt conditions,
%     % then plot to see is there a correlation... the current data is just
%     % so weird...
%     cd([analysisF '\correlationPlots'])
%     
%     % directions separated
%     for t = startT:size(names, 2)
%         % after reversal D CW
%         meanDiffPercept(t, 1) = meanSub{t}.percept(2, 2)-meanSub{t}.percept(1, 2);
%         meanDiffTorsion(t, 1) = meanSub{t}.torsionVelT(2, 2)-meanSub{t}.torsionVelT(1, 2);
%         % after reversal D CCW
%         meanDiffPercept(t, 2) = meanSub{t}.percept(2, 1)-meanSub{t}.percept(1, 1);
%         meanDiffTorsion(t, 2) = meanSub{t}.torsionVelT(2, 1)-meanSub{t}.torsionVelT(1, 1);
%     end
%     
%     % torsion velocity
%     % directions not merged
%     figure
%     eyeN = 2; % 2-right
%     subplot(1, 2, 1)
%     scatter(meanDiffPercept(:, 1), meanDiffTorsion(:, 1))
%     title('afterD CW')
%     xlabel('Diff perception (deg)')
%     ylabel('Diff torsional velocity (deg/s)')
%     set(gca, 'FontSize', 15, 'box', 'off')
%     axis square
%     subplot(1, 2, 2)
%     scatter(meanDiffPercept(:, 2), meanDiffTorsion(:, 2))
%     title('afterD CCW')
%     %     legend({'afterD CW' 'afterD CCW'}, 'box', 'off', 'Location', 'northwest')
%     xlabel('Diff perception (deg)')
%     ylabel('Diff torsional velocity (deg/s)')
%     set(gca, 'FontSize', 15, 'box', 'off')
%     axis square
%     %             xlim([0 420])
%     %         ylim([-25 25])
%     saveas(gca, ['correlationDiffNotMerged_' endName '.pdf'])
%     
%     % directions merged
%     % after reversal D CW
%     meanDiffPerceptM = meanSubM.percept(:, 2)-meanSubM.percept(:, 1);
%     meanDiffTorsionM = meanSubM.torsionVelT(:, 2)-meanSubM.torsionVelT(:, 1);
%     
%     figure
%     eyeN = 2; % 2-right
%     scatter(meanDiffPerceptM, meanDiffTorsionM)
%     xlabel('Diff perception (deg)')
%     ylabel('Diff torsional velocity (deg/s)')
%     set(gca, 'FontSize', 15, 'box', 'off')
%     %             xlim([0 420])
%     %         ylim([-25 25])
%     saveas(gca, ['correlationDiffMerged_' endName '.pdf'])
end
