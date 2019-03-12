% Draw plots, Exp3
% Xiuyun Wu, 03/08/2019
clear all; close all; clc

names = {'tJF' 'AD'};
conditions = [200]; % rotationSpeed
startT = 1; % start from which participant for individual plots
individualPlots = 1; % whether plot individual data
averagedPlots = 0;
% merged = 1;
dirCons = [-1 1]; % after reversal directions
headCons = [-1 0 1];
trialPerCon = 20; % for each head tilt, directions separated
eyeName = {'L' 'R'};
endName = 'BeforeReversal'; % from beginning of stimulus to reversal
% endName = 'AfterReversal';
colorPlot = [0 0 0; 0.5 0.5 0.5];

% if merged==0
%     mergeName = 'notMerged';
% else
%     mergeName = 'merged';
% end
load(['dataLong', endName, '.mat'])
load(['dataLongBase.mat'])

cd ..
analysisF = pwd;

%% plots of individual data
if individualPlots==1
    %% Experimental trials
    for t = startT:size(names, 2)
        data = trialData(trialData.sub==t, :);
        
        %% Perception and torsion plots
        % head tilt and direction separated
        headIdx = unique(data.headTilt);
        for headI = 1:length(headIdx)
            for dirI = 1:2
                %                 hI = find(headCons==headIdx(headI));
                dataT = data(data.afterReversalD==(dirCons(dirI)) & data.headTilt==(headIdx(headI)), :);
                meanSub{t}.percept(headI, dirI) = mean(dataT.perceptualError);
                stdSub{t}.percept(headI, dirI) = std(dataT.perceptualError);
                meanSub{t}.torsionVelT(headI, dirI) = mean(dataT.RtorsionVelT);
                stdSub{t}.torsionVelT(headI, dirI) = std(dataT.RtorsionVelT);
            end
        end
        cd([analysisF '\torsionPlots'])
        %         % perceptual data
        %         figure
        %         eyeN = 2; % 2-right
        %         errorbar(headIdx, meanSub{t}.percept(:, 1), stdSub{t}.percept(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         hold on
        %         errorbar(headIdx, meanSub{t}.percept(:, 2), stdSub{t}.percept(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        %         legend({'visual CCW' 'visual CW'}, 'box', 'off', 'Location', 'northwest')
        %         xlabel('Head tilt direction')
        %         ylabel('Perceived shift in direction (°)')
        %         set(gca, 'FontSize', 15, 'box', 'off')
        %         %             xlim([0 420])
        % %         ylim([-25 25])
        % %         title([eyeName{eye}, ' eye'])
        %         saveas(gca, ['perceptualError_' names{t} '.pdf'])
        
        % torsion velocity
        figure
        eyeN = 2; % 2-right
        errorbar(headIdx, meanSub{t}.torsionVelT(:, 1), stdSub{t}.torsionVelT(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        hold on
        errorbar(headIdx, meanSub{t}.torsionVelT(:, 2), stdSub{t}.torsionVelT(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        legend({'visual CCW' 'visual CW'}, 'box', 'off', 'Location', 'northwest')
        xlabel('Head tilt direction')
        ylabel('Torsional velocity (°/s)')
        set(gca, 'FontSize', 15, 'box', 'off')
        %             xlim([0 420])
        %         ylim([-25 25])
        title([endName])
        saveas(gca, ['torsionVelT_' names{t} '_' endName '.pdf'])
        
        %% Correlation plots
        %         cd([analysisF '\correlationPlots\individual'])
        %         % torsion velocity trial correlation with perception, merged direction
        %         figure
        %         for eye = 1:size(eyeName, 2)
        %             subplot(1, size(eyeName, 2), eye)
        %             if strcmp(eyeName{eye}, 'L')
        %                 eyeN = 1; % 1-left,
        %             elseif strcmp(eyeName{eye}, 'R')
        %                 eyeN = 2; % 2-right
        %             end
        %
        %             tempI = find(trialData.sub==t & trialData.eye==eyeN); % clockwise
        %
        %             scatter(trialData.torsionVelTMerged(tempI, 1), trialData.perceptualError(tempI, 1), 'LineWidth', 1)
        %             ylabel('Perceptual errors (deg)')
        %             xlabel('Torsion velocity (deg/s)')
        %             set(gca, 'FontSize', 15, 'box', 'off')
        %             %             xlim([0 420])
        %             %             ylim([-2 2])
        %             [rho pval] = corr(trialData.torsionVelTMerged(tempI, 1), trialData.perceptualError(tempI, 1));
        %             title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
        %         end
        %         saveas(gca, ['trialCorrelationVelocity&perception_' names{t} '_' endName '.pdf'])
        %
        %         % torsion angle trial correlation with perception, merged direction
        %         figure
        %         for eye = 1:size(eyeName, 2)
        %             subplot(1, size(eyeName, 2), eye)
        %             if strcmp(eyeName{eye}, 'L')
        %                 eyeN = 1; % 1-left,
        %             elseif strcmp(eyeName{eye}, 'R')
        %                 eyeN = 2; % 2-right
        %             end
        %
        %             tempI = find(trialData.sub==t & trialData.eye==eyeN); % clockwise
        %
        %             scatter(trialData.torsionAngleMerged(tempI, 1), trialData.perceptualError(tempI, 1), 'LineWidth', 1)
        %             ylabel('Perceptual errors (deg)')
        %             xlabel('Torsion angle (deg)')
        %             set(gca, 'FontSize', 15, 'box', 'off')
        %             %             xlim([0 420])
        %             %             ylim([-2 2])
        %             [rho pval] = corr(trialData.torsionAngleMerged(tempI, 1), trialData.perceptualError(tempI, 1));
        %             title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
        %         end
        %         saveas(gca, ['trialCorrelationAngle&perception_' names{t} '_' endName '.pdf'])
        
        %         % for per speed trial by trial correlation
        %         speedN = unique(trialData.rotationSpeed);
        %         for ii = 1:length(speedN)
        %             % torsion velocity trial correlation with perception, merged direction
        %             figure
        %             for eye = 1:size(eyeName, 2)
        %                 subplot(1, size(eyeName, 2), eye)
        %                 if strcmp(eyeName{eye}, 'L')
        %                     eyeN = 1; % 1-left,
        %                 elseif strcmp(eyeName{eye}, 'R')
        %                     eyeN = 2; % 2-right
        %                 end
        %
        %                 tempI = find(trialData.sub==t & trialData.eye==eyeN & trialData.rotationSpeed==speedN(ii));
        %
        %                 scatter(trialData.torsionVelTMerged(tempI, 1), trialData.perceptualError(tempI, 1), 'LineWidth', 1)
        %                 ylabel('Perceptual errors (deg)')
        %                 xlabel('Torsion velocity (deg/s)')
        %                 set(gca, 'FontSize', 15, 'box', 'off')
        %                 %             xlim([0 420])
        %                 %             ylim([-2 2])
        %                 [rho pval] = corr(trialData.torsionVelTMerged(tempI, 1), trialData.perceptualError(tempI, 1));
        %                 title([eyeName{eye}, ', ', num2str(speedN(ii)), '°/s, rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
        %             end
        %             saveas(gca, ['trialCorrelationVelocity&perception', num2str(speedN(ii)), '_' names{t} '_' endName '.pdf'])
        %
        %             % torsion angle trial correlation with perception, merged direction
        %             figure
        %             for eye = 1:size(eyeName, 2)
        %                 subplot(1, size(eyeName, 2), eye)
        %                 if strcmp(eyeName{eye}, 'L')
        %                     eyeN = 1; % 1-left,
        %                 elseif strcmp(eyeName{eye}, 'R')
        %                     eyeN = 2; % 2-right
        %                 end
        %
        %                 tempI = find(trialData.sub==t & trialData.eye==eyeN & trialData.rotationSpeed==speedN(ii));
        %
        %                 scatter(trialData.torsionAngleMerged(tempI, 1), trialData.perceptualError(tempI, 1), 'LineWidth', 1)
        %                 ylabel('Perceptual errors (deg)')
        %                 xlabel('Torsion angle (deg)')
        %                 set(gca, 'FontSize', 15, 'box', 'off')
        %                 %             xlim([0 420])
        %                 %             ylim([-2 2])
        %                 [rho pval] = corr(trialData.torsionAngleMerged(tempI, 1), trialData.perceptualError(tempI, 1));
        %                 title([eyeName{eye}, ', ', num2str(speedN(ii)), '°/s, rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
        %             end
        %             saveas(gca, ['trialCorrelationAngle&perception', num2str(speedN(ii)), '_' names{t} '_' endName '.pdf'])
        %         end
        
        %% Saccade plots
        %         cd([analysisF '\SaccadePlots'])
        %         close all
    end
    
    %% Baseline plots
    for t = startT:size(names, 2)
        data = trialDataBase(trialDataBase.sub==t, :);
        
        %% Perception and torsion plots
        % head tilt and direction separated
        headIdx = unique(data.headTilt);
        for headI = 1:length(headIdx)
            for dirI = 1:2
                dataT = data(data.afterReversalD==(dirCons(dirI)) & data.headTilt==(headIdx(headI)), :);
                meanSub{t}.torsionVelT(headI, dirI) = mean(dataT.RtorsionVelT);
                stdSub{t}.torsionVelT(headI, dirI) = std(dataT.RtorsionVelT);
            end
        end
        cd([analysisF '\baselinePlots'])
        % torsion velocity
        figure
        eyeN = 2; % 2-right
        errorbar(headIdx, meanSub{t}.torsionVelT(:, 1), stdSub{t}.torsionVelT(:, 1), '--o', 'LineWidth', 1, 'color', colorPlot(1, :))
        hold on
        errorbar(headIdx, meanSub{t}.torsionVelT(:, 2), stdSub{t}.torsionVelT(:, 2), '-o', 'LineWidth', 1, 'color', colorPlot(1, :))
        legend({'visual CCW' 'visual CW'}, 'box', 'off', 'Location', 'northwest')
        xlabel('Head tilt direction')
        ylabel('Torsional velocity (°/s)')
        set(gca, 'FontSize', 15, 'box', 'off')
        %             xlim([0 420])
        %         ylim([-25 25])
        saveas(gca, ['torsionVelTBase_' names{t} '_' endName '.pdf'])
    end
end

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
end