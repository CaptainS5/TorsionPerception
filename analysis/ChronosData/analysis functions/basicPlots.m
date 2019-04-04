% Draw plots, Exp3
% Xiuyun Wu, 03/08/2019
clear all; close all; clc

names = {'XW3' 'DC3' 'AR3' 'JF3' 'PK3' 'AD3' 'PH3'};
conditions = [200]; % rotationSpeed
startT = 4; % start from which participant for individual plots
individualPlots = 1; % whether plot individual data
averagedPlots = 0;
% merged = 1;
dirCons = [-1 1]; % after reversal directions
headCons = [-1 0 1];
trialPerCon = 20; % for each head tilt, directions separated
eyeName = {'L' 'R'};
% endName = 'BeforeReversal'; % from beginning of stimulus to reversal
endName = 'AfterReversal';
colorPlot = [0 0 0; 0.5 0.5 0.5];
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
    headSub{t} = headIdx;
    for headI = 1:length(headIdx)
        for dirI = 1:2
            %                 hI = find(headCons==headIdx(headI));
            dataT = data(data.afterReversalD==(dirCons(dirI)) & data.headTilt==(headIdx(headI)), :);
            meanSub{t}.percept(headI, dirI) = mean(dataT.perceptualError);
            stdSub{t}.percept(headI, dirI) = std(dataT.perceptualError);
            meanSub{t}.torsionVelT(headI, dirI) = mean(dataT.torsionVelT.*dataT.afterReversalD);
            stdSub{t}.torsionVelT(headI, dirI) = std(dataT.torsionVelT.*dataT.afterReversalD);
            meanSub{t}.torsionAngle(headI, dirI) = mean(dataT.torsionAngle.*dataT.afterReversalD);
            stdSub{t}.torsionAngle(headI, dirI) = std(dataT.torsionAngle.*dataT.afterReversalD);
            meanSub{t}.torsionPosition(headI, dirI) = mean(dataT.torsionPosition.*dataT.afterReversalD);
            stdSub{t}.torsionPosition(headI, dirI) = std(dataT.torsionPosition.*dataT.afterReversalD);
        end
        dataT = data(data.headTilt==(headIdx(headI)), :);
        meanSubM{t}.percept(headI, 1) = mean(dataT.perceptualError);
        stdSubM{t}.percept(headI, 1) = std(dataT.perceptualError);
        meanSubM{t}.torsionVelT(headI, 1) = mean(dataT.torsionVelT.*dataT.afterReversalD);
        stdSubM{t}.torsionVelT(headI, 1) = std(dataT.torsionVelT.*dataT.afterReversalD);
        meanSubM{t}.torsionAngle(headI, 1) = mean(dataT.torsionAngle.*dataT.afterReversalD);
        stdSubM{t}.torsionAngle(headI, 1) = std(dataT.torsionAngle.*dataT.afterReversalD);
        meanSubM{t}.torsionPosition(headI, 1) = mean(dataT.torsionPosition.*dataT.afterReversalD);
        stdSubM{t}.torsionPosition(headI, 1) = std(dataT.torsionPosition.*dataT.afterReversalD);
    end
    
    %% plots of individual data
    if individualPlots==1
        cd([analysisF '\torsionPlots'])
%         % perceptual data
%         figure
%         eyeN = 2; % 2-right
%         errorbar(headIdx, meanSub{t}.percept(:, 1), stdSub{t}.percept(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
%         hold on
%         errorbar(headIdx, meanSub{t}.percept(:, 2), stdSub{t}.percept(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
%         legend({'afterD CCW' 'afterD CW'}, 'box', 'off', 'Location', 'northwest')
%         xlabel('Head tilt direction')
%         ylabel('Perceived shift in direction (?)')
%         set(gca, 'FontSize', 15, 'box', 'off')
%         %             xlim([0 420])
%         %         ylim([-25 25])
%         %         title([eyeName{eye}, ' eye'])
%         saveas(gca, ['perceptualError_' names{t} '.pdf'])
        
        % torsion velocity, direction not merged
        figure
        eyeN = 2; % 2-right
        errorbar(headIdx, meanSub{t}.torsionVelT(:, 1), stdSub{t}.torsionVelT(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        hold on
        errorbar(headIdx, meanSub{t}.torsionVelT(:, 2), stdSub{t}.torsionVelT(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        legend({'afterD CCW' 'afterD CW'}, 'box', 'off', 'Location', 'northwest')
        xlabel('Head tilt direction')
        ylabel('Torsional velocity (?/s)')
        set(gca, 'FontSize', 15, 'box', 'off')
        %             xlim([0 420])
        %         ylim([-25 25])
        title([endName])
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
        
        % torsion angle, direction not merged
        figure
        eyeN = 2; % 2-right
        errorbar(headIdx, meanSub{t}.torsionAngle(:, 1), stdSub{t}.torsionAngle(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        hold on
        errorbar(headIdx, meanSub{t}.torsionAngle(:, 2), stdSub{t}.torsionAngle(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        legend({'afterD CCW' 'afterD CW'}, 'box', 'off', 'Location', 'northwest')
        xlabel('Head tilt direction')
        ylabel('Torsional angle (deg)')
        set(gca, 'FontSize', 15, 'box', 'off')
        %             xlim([0 420])
        %         ylim([-25 25])
        title([endName])
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
        
        % torsion position, direction not merged
        figure
        eyeN = 2; % 2-right
        errorbar(headIdx, meanSub{t}.torsionPosition(:, 1), stdSub{t}.torsionPosition(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        hold on
        errorbar(headIdx, meanSub{t}.torsionPosition(:, 2), stdSub{t}.torsionPosition(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        legend({'afterD CCW' 'afterD CW'}, 'box', 'off', 'Location', 'northwest')
        xlabel('Head tilt direction')
        ylabel('Torsional position (deg)')
        set(gca, 'FontSize', 15, 'box', 'off')
        %             xlim([0 420])
        %         ylim([-25 25])
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
%         %         %         torsion velocity trial correlation with perception, merged direction
%         %         figure
%         %         eyeN = 2; % right eye
%         %         scatter(data.perceptualError, data.torsionVelT.*data.afterReversalD, 'LineWidth', 1)
%         %         xlabel('Perceptual errors (deg)')
%         %         ylabel('Torsion velocity (deg/s)')
%         %         set(gca, 'FontSize', 15, 'box', 'off')
%         %         %             xlim([0 420])
%         %         %             ylim([-2 2])
%         %         %         [rho pval] = corr(trialData.torsionVelTMerged(tempI, 1), trialData.perceptualError(tempI, 1));
%         %         %         title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
%         %         saveas(gca, ['trialCorrelationVelocity&Perception_dirMerged_' names{t} '_' endName '.pdf'])
%         
        % torsion velocity trial correlation with perception,
        % direction not merged
        figure
        eyeN = 2; % right eye
        subplot(1, 2, 1)
        tempI = find(data.afterReversalD==1);
        scatter(data.perceptualError(tempI, :), data.torsionVelT(tempI, :), 'LineWidth', 1)
        xlabel('Perceptual errors (deg)')
        ylabel('Torsion velocity (deg/s)')
        title('afterD CW')
        set(gca, 'FontSize', 15, 'box', 'off')
        axis square
        
        subplot(1, 2, 2)
        tempI = find(data.afterReversalD==-1);
        scatter(data.perceptualError(tempI, :), data.torsionVelT(tempI, :), 'LineWidth', 1)
        xlabel('Perceptual errors (deg)')
        ylabel('Torsion velocity (deg/s)')
        title('afterD CCW')
        set(gca, 'FontSize', 15, 'box', 'off')
        axis square
%         %             xlim([0 420])
%         %             ylim([-2 2])
%         %         [rho pval] = corr(trialData.torsionVelTMerged(tempI, 1), trialData.perceptualError(tempI, 1));
%         %         title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
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
% for t = startT:size(names, 2)
%     data = trialDataBase(trialDataBase.sub==t, :);
%     
%     % head tilt and direction separated
%     headIdx = unique(data.headTilt);
%     for headI = 1:length(headIdx)
%         for dirI = 1:2
%             dataT = data(data.afterReversalD==(dirCons(dirI)) & data.headTilt==(headIdx(headI)), :);
%             meanSub{t}.torsionVelT(headI, dirI) = mean(dataT.torsionVelT.*dataT.afterReversalD);
%             stdSub{t}.torsionVelT(headI, dirI) = std(dataT.torsionVelT.*dataT.afterReversalD);
%         end
%     end
%     cd([analysisF '\baselinePlots'])
%     % torsion velocity
%     figure
%     eyeN = 2; % 2-right
%     errorbar(headIdx, meanSub{t}.torsionVelT(:, 1), stdSub{t}.torsionVelT(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
%     hold on
%     errorbar(headIdx, meanSub{t}.torsionVelT(:, 2), stdSub{t}.torsionVelT(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
%     legend({'visual CCW' 'visual CW'}, 'box', 'off', 'Location', 'northwest')
%     xlabel('Head tilt direction')
%     ylabel('Torsional velocity (?/s)')
%     set(gca, 'FontSize', 15, 'box', 'off')
%     %             xlim([0 420])
%     %         ylim([-25 25])
%     saveas(gca, ['torsionVelTBase_' names{t} '.pdf'])
% end

%% averaged plots
if averagedPlots==1
    %     % torsionV/perceptual error/torsionVGain vs. speed, scatter
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
%     colorPlot = [232 71 12; 2 255 44; 12 76 150; 140 0 255; 255 212 13]/255;
    
    %% summary plots
        cd([analysisF '\summaryPlots'])
%     % perception
%     figure
%     box off
%     for subN = 1:size(names, 2)
%         hold on
%         p{subN} = errorbar(headSub{subN}, meanSubM{subN}.percept, stdSubM{subN}.percept, '-o', 'LineWidth', 1, 'color', markerC(subN, :));
%     end
%     legend([p{1}, p{2}, p{3}, p{4}], names, 'box', 'off', 'Location', 'northwest')
%     %         ylim([-25, 25])
%     xlim([-1.5 1.5])
%     xlabel('Head tilt direction')
%     ylabel('Perceived shift in direction (°)')
%     set(gca, 'FontSize', fontSize, 'box', 'off')
%     saveas(gca, ['all_perception_' endName '.pdf'])
    
    % torsion velocity
    figure
    box off
    for subN = 1:size(names, 2)
        hold on
        p{subN} = errorbar(headSub{subN}, meanSubM{subN}.torsionVelT, stdSubM{subN}.torsionVelT, '-o', 'LineWidth', 1, 'color', markerC(subN, :));
    end
    legend([p{1}, p{2}, p{3}, p{4}], names, 'box', 'off', 'Location', 'northwest')
    %         ylim([-25, 25])
    xlim([-1.5 1.5])
    xlabel('Head tilt direction')
    ylabel('Torsional velocity (°/s)')
    set(gca, 'FontSize', fontSize, 'box', 'off')
    saveas(gca, ['all_torsion_' endName '.pdf'])
    %
    %% Correlation of difference plots
    % calculate the difference between head up and head tilt conditions,
    % then plot to see is there a correlation... the current data is just
    % so weird...
    
    % directions separated
    for t = startT:size(names, 2)
        data = trialData(trialData.sub==t, :);
        
        % head tilt and direction separated
        headIdx = unique(data.headTilt);
        for headI = 1:length(headIdx)
            for dirI = 1:2
                dataT = data(data.afterReversalD==(dirCons(dirI)) & data.headTilt==(headIdx(headI)), :);
                meanSub{t}.torsionVelT(headI, dirI) = mean(dataT.torsionVelT);
                stdSub{t}.torsionVelT(headI, dirI) = std(dataT.torsionVelT);
                meanSub{t}.perceptualError(headI, dirI) = mean(dataT.perceptualError);
                stdSub{t}.perceptualError(headI, dirI) = std(dataT.perceptualError);
            end
        end
        if headIdx(1)==0
            % after reversal D CW
            meanDiffPercept(t, 1) = meanSub{t}.perceptualError(1, 2)-meanSub{t}.perceptualError(2, 2);
            meanDiffTorsion(t, 1) = meanSub{t}.torsionVelT(1, 2)-meanSub{t}.torsionVelT(2, 2);
            % after reversal D CCW
            meanDiffPercept(t, 2) = meanSub{t}.perceptualError(1, 1)-meanSub{t}.perceptualError(2, 1);
            meanDiffTorsion(t, 2) = meanSub{t}.torsionVelT(1, 1)-meanSub{t}.torsionVelT(2, 1);
        else
            % after reversal D CW
            meanDiffPercept(t, 1) = meanSub{t}.perceptualError(2, 2)-meanSub{t}.perceptualError(1, 2);
            meanDiffTorsion(t, 1) = meanSub{t}.torsionVelT(2, 2)-meanSub{t}.torsionVelT(1, 2);
            % after reversal D CCW
            meanDiffPercept(t, 2) = meanSub{t}.perceptualError(2, 1)-meanSub{t}.perceptualError(1, 1);
            meanDiffTorsion(t, 2) = meanSub{t}.torsionVelT(2, 1)-meanSub{t}.torsionVelT(1, 1);
        end
    end
    cd([analysisF '\correlationPlots'])
    % torsion velocity
    figure
    eyeN = 2; % 2-right
    
    subplot(1, 2, 1)
    scatter(meanDiffPercept(:, 1), meanDiffTorsion(:, 1))
    title('afterD CW')
    xlabel('Diff perception (?)')
    ylabel('Diff torsional velocity (?/s)')
    set(gca, 'FontSize', 15, 'box', 'off')
    
    subplot(1, 2, 2)
    scatter(meanDiffPercept(:, 2), meanDiffTorsion(:, 2))
    title('afterD CCW')
    %     legend({'afterD CW' 'afterD CCW'}, 'box', 'off', 'Location', 'northwest')
    xlabel('Diff perception (?)')
    ylabel('Diff torsional velocity (?/s)')
    set(gca, 'FontSize', 15, 'box', 'off')
    %             xlim([0 420])
    %         ylim([-25 25])
    saveas(gca, ['correlationDiffdirNotMerged_' endName '.pdf'])
    
    %         % directions merged
    %         for t = startT:size(names, 2)
    %             data = trialData(trialData.sub==t, :);
    %
    %             % head tilt and direction separated
    %             headIdx = unique(data.headTilt);
    %             for headI = 1:length(headIdx)
    %                 dataT = data(data.headTilt==(headIdx(headI)), :);
    %                 meanSubM{t}.torsionVelT(headI, 1) = mean(dataT.torsionVelT.*dataT.afterReversalD);
    %                 stdSubM{t}.torsionVelT(headI, 1) = std(dataT.torsionVelT.*dataT.afterReversalD);
    %                 meanSubM{t}.perceptualError(headI, 1) = mean(dataT.perceptualError);
    %                 stdSubM{t}.perceptualError(headI, 1) = std(dataT.perceptualError);
    %             end
    %             % difference is head up-head tilt
    %             if headIdx(1)==0
    %                 meanDiffPerceptM(t, 1) = meanSubM{t}.perceptualError(1, 1)-meanSubM{t}.perceptualError(2, 1);
    %                 meanDiffTorsion(t, 1) = meanSubM{t}.torsionVelT(1, 1)-meanSubM{t}.torsionVelT(2, 1);
    %             else
    %                 meanDiffPerceptM(t, 1) = meanSubM{t}.perceptualError(2, 1)-meanSubM{t}.perceptualError(1, 1);
    %                 meanDiffTorsionM(t, 1) = meanSubM{t}.torsionVelT(2, 1)-meanSubM{t}.torsionVelT(1, 1);
    %             end
    %         end
    %     cd([analysisF '\correlationPlots'])
    %     % torsion velocity
    %     figure
    %     eyeN = 2; % 2-right
    %
    %     scatter(meanDiffPerceptM, meanDiffTorsionM)
    %     xlabel('Diff perception (?)')
    %     ylabel('Diff torsional velocity (?/s)')
    %     set(gca, 'FontSize', 15, 'box', 'off')
    %     %             xlim([0 420])
    %     %         ylim([-25 25])
    %     saveas(gca, ['correlationDiffdirMerged_' endName '.pdf'])
end
