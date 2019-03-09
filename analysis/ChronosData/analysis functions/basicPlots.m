% Draw plots, Exp3
% Xiuyun Wu, 03/08/2019
clear all; close all; clc

names = {'tXW0'};
conditions = [200]; % rotationSpeed
startT = 1; % start from which participant for individual plots
individualPlots = 1; % whether plot individual data
averagedPlots = 0;
merged = 1;
dirCons = [-1 1]; % after reversal directions
headCons = [-1 0 1];
trialPerCon = 20; % for each head tilt, directions separated
eyeName = {'L' 'R'};
% endName = 'BeforeReversal'; % from beginning of stimulus to reversal
endName = 'AfterReversal';
colorPlot = [0 0 0; 0.5 0.5 0.5];

% if merged==0
%     mergeName = 'notMerged';
% else
%     mergeName = 'merged';
% end
load(['dataLong', endName, '.mat'])

cd ..
analysisF = pwd;

%% plots of individual data
if individualPlots==1
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
    
    %% scatter plots
    cd([analysisF '\correlationPlots'])
    %     %     %     each speed, scatter torsion vs. perceptual error
    %     %     speedN = unique(conData.rotationSpeed);
    %     %     %     for ii = 1:length(speedN)
    %     figure
    %     for eye = 1:size(eyeName, 2)
    %         subplot(1, size(eyeName, 2), eye)
    %         if strcmp(eyeName{eye}, 'L')
    %             eyeN = 1; % 1-left,
    %         elseif strcmp(eyeName{eye}, 'R')
    %             eyeN = 2; % 2-right
    %         end
    %         for t = 1:size(names, 2)
    %             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0);
    %             if ~isempty(tempI)
    %                 scatter(conData.torsionVelTMean(tempI, 1), conData.perceptualErrorMean(tempI, 1), 'LineWidth', 2,...
    %                     'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
    %                 hold on
    %             end
    %             xlabel('Torsional velocity (deg/s)')
    %             ylabel('Perceptual bias (deg)')
    %             %                 title(['Speed ', num2str(speedN(ii)), ', ', eyeName{eye}])
    %             %                 xlim([-4 4])
    %             %                 ylim([-4 4])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             axis square
    %         end
    %         tempI = find(conData.eye==eyeN & conData.afterReversalD==0);
    %         [rho pval] = partialcorr([conData.torsionVelTMean(tempI, 1) conData.perceptualErrorMean(tempI, 1)], conData.rotationSpeed(tempI, 1));
    %         title([eyeName{eye}, ', rho=', num2str(rho(1, 2), '%.2f'), ', p=', num2str(pval(1, 2), '%.3f')])
    %         %         [rho pval] = corr(conData.torsionVelTMean(tempI, 1), conData.perceptualErrorMean(tempI, 1));
    %         %         title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
    %     end
    %     %             saveas(gca, ['torsionVSperceptNorm_speed', num2str(speedN(ii)), '.pdf'])
    %     saveas(gca, ['torsionVelocityVSperceptPartialCorr_' endName '.pdf'])
    %
    %     figure
    %     for eye = 1:size(eyeName, 2)
    %         subplot(1, size(eyeName, 2), eye)
    %         if strcmp(eyeName{eye}, 'L')
    %             eyeN = 1; % 1-left,
    %         elseif strcmp(eyeName{eye}, 'R')
    %             eyeN = 2; % 2-right
    %         end
    %         for t = 1:size(names, 2)
    %             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0);
    %             if ~isempty(tempI)
    %                 scatter(conData.torsionAngleTotalMean(tempI, 1), conData.perceptualErrorMean(tempI, 1), 'LineWidth', 2,...
    %                     'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
    %                 hold on
    %             end
    %             xlabel('Torsional angle (deg)')
    %             ylabel('Perceptual bias (deg)')
    %             %                 title(['Speed ', num2str(speedN(ii)), ', ', eyeName{eye}])
    %             %                 xlim([-4 4])
    %             %                 ylim([-4 4])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             axis square
    %         end
    %         tempI = find(conData.eye==eyeN & conData.afterReversalD==0);
    %         [rho pval] = partialcorr([conData.torsionAngleTotalMean(tempI, 1) conData.perceptualErrorMean(tempI, 1)], conData.rotationSpeed(tempI, 1));
    %         title([eyeName{eye}, ', rho=', num2str(rho(1, 2), '%.2f'), ', p=', num2str(pval(1, 2), '%.3f')])
    %         %         [rho pval] = corr(conData.torsionAngleMean(tempI, 1), conData.perceptualErrorMean(tempI, 1));
    %         %         title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
    %     end
    %     %         saveas(gca, ['torsionVSperceptNorm_speed', num2str(speedN(ii)), '.pdf'])
    %     saveas(gca, ['torsionAngleTotalVSperceptPartialCorr_' endName '.pdf'])
    %
    % using two eye's data together--if target is on the left, use
    % left eye data; if target is on the right, use right eye data
    % first sort data...
    figure
    ax1 = subplot(2, 2, 1);
    ax2 = subplot(2, 2, 2);
    ax3 = subplot(2, 2, 3);
    ax4 = subplot(2, 2, 4);
    hold(ax1, 'on')
    hold(ax2, 'on')
    hold(ax3, 'on')
    hold(ax4, 'on')
    for t = 4:4%1:size(names, 2)
        dataBoth = trialData(trialData.sub==t, :);
        for sI = 1:4
            tempIL = find(dataBoth.eye==1 & dataBoth.targetSide==-1 & dataBoth.rotationSpeed==conditions(sI));
            tempIR = find(dataBoth.eye==2 & dataBoth.targetSide==1 & dataBoth.rotationSpeed==conditions(sI));
            tempAll = [tempIL; tempIR];
            velMean(t, sI) = mean(dataBoth.torsionVelTMerged(tempAll));
            angleSameMean(t, sI) = mean(dataBoth.torsionAngleTSameMerged(tempAll));
            angleAntiMean(t, sI) = mean(dataBoth.torsionAngleTAntiMerged(tempAll));
            angleTotalMean(t, sI) = mean(dataBoth.torsionAngleTotal(tempAll));
            perceptMean(t, sI) = mean(dataBoth.perceptualError(tempAll));
            sacNumTMean(t, sI) = mean(dataBoth.sacNumT(tempAll));
            sacAmpSumTMean(t, sI) = mean(dataBoth.sacAmpSumT(tempAll));
        end
        scatter(ax1, velMean(t, :), perceptMean(t, :), 'LineWidth', 2,...
            'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
        scatter(ax2, angleSameMean(t, :), perceptMean(t, :), 'LineWidth', 2,...
            'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
        scatter(ax3, angleAntiMean(t, :), perceptMean(t, :), 'LineWidth', 2,...
            'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
        scatter(ax4, angleTotalMean(t, :), perceptMean(t, :), 'LineWidth', 2,...
            'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
    end
    speedCorrIdx = [25*ones(t, 1) 50*ones(t, 1) 100*ones(t, 1) 200*ones(t, 1)];
    xlabel(ax1, 'Torsional velocity (deg/s)')
    ylabel(ax1, 'Perceptual bias (deg)')
    %     legend(names)
    [rho pval] = partialcorr([velMean(:) perceptMean(:)], speedCorrIdx(:));
    title(ax1, [', rho=', num2str(rho(1, 2), '%.2f'), ', p=', num2str(pval(1, 2), '%.3f')])
    
    xlabel(ax2, 'Torsional angle same (deg/s)')
    ylabel(ax2, 'Perceptual bias (deg)')
    [rho pval] = partialcorr([angleSameMean(:) perceptMean(:)], speedCorrIdx(:));
    title(ax2, [', rho=', num2str(rho(1, 2), '%.2f'), ', p=', num2str(pval(1, 2), '%.3f')])
    
    xlabel(ax3, 'Torsional angle anti (deg/s)')
    ylabel(ax3, 'Perceptual bias (deg)')
    [rho pval] = partialcorr([angleAntiMean(:) perceptMean(:)], speedCorrIdx(:));
    title(ax3, [', rho=', num2str(rho(1, 2), '%.2f'), ', p=', num2str(pval(1, 2), '%.3f')])
    
    xlabel(ax4, 'Torsional angle total (deg/s)')
    ylabel(ax4, 'Perceptual bias (deg)')
    [rho pval] = partialcorr([angleTotalMean(:) perceptMean(:)], speedCorrIdx(:));
    title(ax4, [', rho=', num2str(rho(1, 2), '%.2f'), ', p=', num2str(pval(1, 2), '%.3f')])
    
    saveas(gca, ['correlationBothEyes_' endName '.pdf'])
    
    %% mean of participants
    cd([analysisF '\summaryPlots'])
    % both eyes together
    %         figure
    %         errorbar(conditions, mean(angleSameMean), ...
    %             std(angleSameMean), 'LineStyle', 'None', ...
    %             'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %         hold on
    %         errorbar(conditions, abs(mean(angleAntiMean)), ...
    %             abs(std(angleAntiMean)), 'LineStyle', 'None', ...
    %             'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %         legend({'TSame(CW)-both eye' 'TAnti(CCW)-both eye'}, 'box', 'off')
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Torsion angle abs (deg)')
    %         xlim([0 220])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         saveas(gca, ['meanSpeedTorsionAngleBothEye_', mergeName, '_' endName '.pdf'])
    %
    %         figure
    %         errorbar(conditions, mean(velMean), ...
    %             std(velMean), 'LineStyle', 'None', ...
    %             'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Torsion velocity (deg)')
    %         xlim([0 220])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         saveas(gca, ['meanSpeedTorsionVelocityBothEye_', mergeName, '_' endName '.pdf'])
    
    %         figure
    %         errorbar(conditions, mean(sacNumTMean), ...
    %             std(sacNumTMean), 'LineStyle', 'None', ...
    %             'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Saccade number')
    %         xlim([0 220])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         saveas(gca, ['meanSpeedSacNumBothEye_', mergeName, '_' endName '.pdf'])
    %
    %         figure
    %         errorbar(conditions, mean(sacAmpSumTMean), ...
    %             std(sacAmpSumTMean), 'LineStyle', 'None', ...
    %             'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Saccade amplitude sum (deg)')
    %         xlim([0 220])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         saveas(gca, ['meanSpeedSacAmpSumBothEye_', mergeName, '_' endName '.pdf'])
    
    %         figure
    %         for eye = 1:size(eyeName, 2)
    %             subplot(1, size(eyeName, 2), eye)
    %             if strcmp(eyeName{eye}, 'L')
    %                 eyeN = 1; % 1-left,
    %             elseif strcmp(eyeName{eye}, 'R')
    %                 eyeN = 2; % 2-right
    %             end
    %
    %             if merged==0
    %                 tempIc = find(conData.eye==eyeN & conData.afterReversalD==1); % CW
    %                 tempIcc = find(conData.eye==eyeN & conData.afterReversalD==-1); % CCW
    %
    %                 dataTc = conData(tempIc, :);
    %                 dataTcc = conData(tempIcc, :);
    %                 onset = unique(dataTc.rotationSpeed);
    %                 for ll = 1:length(onset)
    %                     dataTc.flashOnsetIdx(dataTc.rotationSpeed==onset(ll), 1) = ll;
    %                     dataTcc.flashOnsetIdx(dataTcc.rotationSpeed==onset(ll), 1) = ll;
    %                 end
    %                 meanPerceptualErrorC = accumarray(dataTc.flashOnsetIdx, dataTc.perceptualErrorMean, [], @mean);
    %                 stdPerceptualErrorC = accumarray(dataTc.flashOnsetIdx, dataTc.perceptualErrorMean, [], @std);
    %
    %                 meanPerceptualErrorCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.perceptualErrorMean, [], @mean);
    %                 stdPerceptualErrorCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.perceptualErrorMean, [], @std);
    %
    %                 errorbar(onset, meanPerceptualErrorC, ...
    %                     stdPerceptualErrorC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 hold on
    %                 errorbar(onset, meanPerceptualErrorCC, ...
    %                     stdPerceptualErrorCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             else
    %                 tempI = find(conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %                 dataT = conData(tempI, :);
    %                 onset = unique(dataT.rotationSpeed);
    %                 for ll = 1:length(onset)
    %                     dataT.flashOnsetIdx(dataT.rotationSpeed==onset(ll), 1) = ll;
    %                 end
    %                 meanPerceptualError = accumarray(dataT.flashOnsetIdx, dataT.perceptualErrorMean, [], @mean);
    %                 stdPerceptualError = accumarray(dataT.flashOnsetIdx, dataT.perceptualErrorMean, [], @std);
    %
    %                 errorbar(onset, meanPerceptualError, ...
    %                     stdPerceptualError, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             end
    %             xlabel('Rotation speed(deg/s)')
    %             ylabel('Perceptual error (deg)')
    %             xlim([0 220])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             title([eyeName{eye}, ' eye'])
    %         end
    %         saveas(gca, ['meanSpeedPerceptREye_', mergeName, '.pdf'])
    
    %         % eyes seperated
    %         figure
    %         for eye = 1:size(eyeName, 2)
    %             subplot(1, size(eyeName, 2), eye);
    %             if strcmp(eyeName{eye}, 'L')
    %                 eyeN = 1; % 1-left,
    %             elseif strcmp(eyeName{eye}, 'R')
    %                 eyeN = 2; % 2-right
    %             end
    %
    %             if merged==0
    %                 tempIc = find(conData.eye==eyeN & conData.afterReversalD==1); % CW
    %                 tempIcc = find(conData.eye==eyeN & conData.afterReversalD==-1); % CCW
    %
    %                 dataTc = conData(tempIc, :);
    %                 dataTcc = conData(tempIcc, :);
    %                 onset = unique(dataTc.rotationSpeed);
    %                 for ll = 1:length(onset)
    %                     dataTc.flashOnsetIdx(dataTc.rotationSpeed==onset(ll), 1) = ll;
    %                     dataTcc.flashOnsetIdx(dataTcc.rotationSpeed==onset(ll), 1) = ll;
    %                 end
    %                 meanTorsionVelTC = accumarray(dataTc.flashOnsetIdx, dataTc.torsionVelTMean, [], @mean);
    %                 stdTorsionVelTC = accumarray(dataTc.flashOnsetIdx, dataTc.torsionVelTMean, [], @std);
    %
    %                 meanTorsionVelTCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.torsionVelTMean, [], @mean);
    %                 stdTorsionVelTCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.torsionVelTMean, [], @std);
    %
    %                 errorbar(onset, meanTorsionVelTC, ...
    %                     stdTorsionVelTC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 hold on
    %                 errorbar(onset, meanTorsionVelTCC, ...
    %                     stdTorsionVelTCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             else
    %             tempI = find(conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %             dataT = conData(tempI, :);
    %             onset = unique(dataT.rotationSpeed);
    %             for ll = 1:length(onset)
    %                 dataT.flashOnsetIdx(dataT.rotationSpeed==onset(ll), 1) = ll;
    %             end
    %             meanTorsionVelTError = accumarray(dataT.flashOnsetIdx, dataT.torsionVelTMean, [], @mean);
    %             stdTorsionVelTError = accumarray(dataT.flashOnsetIdx, dataT.torsionVelTMean, [], @std);
    %
    %             errorbar(onset, meanTorsionVelTError, ...
    %                 stdTorsionVelTError, 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             end
    %             xlabel('Rotation speed(deg/s)')
    %             ylabel('Torsional velocity (deg/s)')
    %             xlim([0 220])
    %             %         ylim([-2 2])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             title([eyeName{eye}, ' eye'])
    %         end
    %         saveas(gca, ['meanSpeedTorsionV_' endName '_' mergeName '.pdf'])
    %
    %         figure
    %         for eye = 1:size(eyeName, 2)
    %             subplot(1, size(eyeName, 2), eye);
    %             if strcmp(eyeName{eye}, 'L')
    %                 eyeN = 1; % 1-left,
    %             elseif strcmp(eyeName{eye}, 'R')
    %                 eyeN = 2; % 2-right
    %             end
    %
    %             if merged==0
    %                 tempIc = find(conData.eye==eyeN & conData.afterReversalD==1); % CW
    %                 tempIcc = find(conData.eye==eyeN & conData.afterReversalD==-1); % CCW
    %
    %                 dataTc = conData(tempIc, :);
    %                 dataTcc = conData(tempIcc, :);
    %                 onset = unique(dataTc.rotationSpeed);
    %                 for ll = 1:length(onset)
    %                     dataTc.flashOnsetIdx(dataTc.rotationSpeed==onset(ll), 1) = ll;
    %                     dataTcc.flashOnsetIdx(dataTcc.rotationSpeed==onset(ll), 1) = ll;
    %                 end
    %                 meanTorsionAngleTSameC = accumarray(dataTc.flashOnsetIdx, dataTc.torsionAngleTSameMean, [], @mean);
    %                 stdTorsionAngleTSameC = accumarray(dataTc.flashOnsetIdx, dataTc.torsionAngleTSameMean, [], @std);
    %
    %                 meanTorsionAngleTSameCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.torsionAngleTSameMean, [], @mean);
    %                 stdTorsionAngleTSameCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.torsionAngleTSameMean, [], @std);
    %
    %                 meanTorsionAngleTAntiC = accumarray(dataTc.flashOnsetIdx, dataTc.torsionAngleTAntiMean, [], @mean);
    %                 stdTorsionAngleTAntiC = accumarray(dataTc.flashOnsetIdx, dataTc.torsionAngleTAntiMean, [], @std);
    %
    %                 meanTorsionAngleTAntiCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.torsionAngleTAntiMean, [], @mean);
    %                 stdTorsionAngleTAntiCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.torsionAngleTAntiMean, [], @std);
    %
    %                 errorbar(onset, meanTorsionAngleTSameC, ...
    %                     stdTorsionAngleTSameC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 hold on
    %                 errorbar(onset, meanTorsionAngleTSameCC, ...
    %                     stdTorsionAngleTSameCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %
    %                 errorbar(onset, meanTorsionAngleTAntiC, ...
    %                     stdTorsionAngleTAntiC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 errorbar(onset, meanTorsionAngleTAntiCC, ...
    %                     stdTorsionAngleTAntiCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 legend({'T-CW-Same' 'T-CCW-Same' 'T-CW-Anti' 'T-CCW-Anti'}, 'box', 'off')
    %             else
    %             tempI = find(conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %             dataT = conData(tempI, :);
    %             onset = unique(dataT.rotationSpeed);
    %             for ll = 1:length(onset)
    %                 dataT.flashOnsetIdx(dataT.rotationSpeed==onset(ll), 1) = ll;
    %             end
    %             meanTorsionAngleTSameError = accumarray(dataT.flashOnsetIdx, dataT.torsionAngleTSameMean, [], @mean);
    %             stdTorsionAngleTSameError = accumarray(dataT.flashOnsetIdx, dataT.torsionAngleTSameMean, [], @std);
    %
    %             meanTorsionAngleTAntiError = accumarray(dataT.flashOnsetIdx, dataT.torsionAngleTAntiMean, [], @mean);
    %             stdTorsionAngleTAntiError = accumarray(dataT.flashOnsetIdx, dataT.torsionAngleTAntiMean, [], @std);
    %
    %             errorbar(onset, meanTorsionAngleTSameError, ...
    %                 stdTorsionAngleTSameError, 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %             errorbar(onset, meanTorsionAngleTAntiError, ...
    %                 stdTorsionAngleTAntiError, 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             end
    %
    %             xlabel('Rotation speed(deg/s)')
    %             ylabel('Torsional angle (deg)')
    %             xlim([0 220])
    %             %         ylim([-2 2])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             title([eyeName{eye}, ' eye'])
    %         end
    %         saveas(gca, ['meanSpeedTorsionAngleTRef_' endName '_' mergeName '.pdf'])
    
    % % saccade num
    % figure
    %         for eye = 1:size(eyeName, 2)
    %             subplot(1, size(eyeName, 2), eye);
    %             if strcmp(eyeName{eye}, 'L')
    %                 eyeN = 1; % 1-left,
    %             elseif strcmp(eyeName{eye}, 'R')
    %                 eyeN = 2; % 2-right
    %             end
    %
    %             if merged==0
    %                 tempIc = find(conData.eye==eyeN & conData.afterReversalD==1); % CW
    %                 tempIcc = find(conData.eye==eyeN & conData.afterReversalD==-1); % CCW
    %
    %                 dataTc = conData(tempIc, :);
    %                 dataTcc = conData(tempIcc, :);
    %                 onset = unique(dataTc.rotationSpeed);
    %                 for ll = 1:length(onset)
    %                     dataTc.flashOnsetIdx(dataTc.rotationSpeed==onset(ll), 1) = ll;
    %                     dataTcc.flashOnsetIdx(dataTcc.rotationSpeed==onset(ll), 1) = ll;
    %                 end
    %                 meanSacNumTTSameC = accumarray(dataTc.flashOnsetIdx, dataTc.sacNumTTSameMean, [], @mean);
    %                 stdSacNumTTSameC = accumarray(dataTc.flashOnsetIdx, dataTc.sacNumTTSameMean, [], @std);
    %
    %                 meanSacNumTTSameCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacNumTTSameMean, [], @mean);
    %                 stdSacNumTTSameCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacNumTTSameMean, [], @std);
    %
    %                 meanSacNumTTAntiC = accumarray(dataTc.flashOnsetIdx, dataTc.sacNumTTAntiMean, [], @mean);
    %                 stdSacNumTTAntiC = accumarray(dataTc.flashOnsetIdx, dataTc.sacNumTTAntiMean, [], @std);
    %
    %                 meanSacNumTTAntiCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacNumTTAntiMean, [], @mean);
    %                 stdSacNumTTAntiCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacNumTTAntiMean, [], @std);
    %
    %                 errorbar(onset, meanSacNumTTSameC, ...
    %                     stdSacNumTTSameC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 hold on
    %                 errorbar(onset, meanSacNumTTSameCC, ...
    %                     stdSacNumTTSameCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %
    %                 errorbar(onset, meanSacNumTTAntiC, ...
    %                     stdSacNumTTAntiC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 errorbar(onset, meanSacNumTTAntiCC, ...
    %                     stdSacNumTTAntiCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 legend({'T-CW-Same' 'T-CCW-Same' 'T-CW-Anti' 'T-CCW-Anti'}, 'box', 'off')
    %             else
    %             tempI = find(conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %             dataT = conData(tempI, :);
    %             onset = unique(dataT.rotationSpeed);
    %             for ll = 1:length(onset)
    %                 dataT.flashOnsetIdx(dataT.rotationSpeed==onset(ll), 1) = ll;
    %             end
    %             meanSacNumTTSame = accumarray(dataT.flashOnsetIdx, dataT.sacNumTTSameMean, [], @mean);
    %             stdSacNumTTSame = accumarray(dataT.flashOnsetIdx, dataT.sacNumTTSameMean, [], @std);
    %
    %             meanSacNumTTAnti = accumarray(dataT.flashOnsetIdx, dataT.sacNumTTAntiMean, [], @mean);
    %             stdSacNumTTAnti = accumarray(dataT.flashOnsetIdx, dataT.sacNumTTAntiMean, [], @std);
    %
    %             errorbar(onset, meanSacNumTTSame, ...
    %                 stdSacNumTTSame, 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %             errorbar(onset, meanSacNumTTAnti, ...
    %                 stdSacNumTTAnti, 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             legend({'Same as target(CW)' 'Opposite to target(CCW)'}, 'box', 'off')
    %             end
    %
    %             xlabel('Rotation speed(deg/s)')
    %             ylabel('Saccade number (deg)')
    %             xlim([0 220])
    %             %         ylim([-2 2])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             title([eyeName{eye}, ' eye'])
    %         end
    %         saveas(gca, ['meanSpeedSacNumTTRef_' endName '_' mergeName '.pdf'])
    %
    %         % saccade amp sum
    %         figure
    %         for eye = 1:size(eyeName, 2)
    %             subplot(1, size(eyeName, 2), eye);
    %             if strcmp(eyeName{eye}, 'L')
    %                 eyeN = 1; % 1-left,
    %             elseif strcmp(eyeName{eye}, 'R')
    %                 eyeN = 2; % 2-right
    %             end
    %
    %             if merged==0
    %                 tempIc = find(conData.eye==eyeN & conData.afterReversalD==1); % CW
    %                 tempIcc = find(conData.eye==eyeN & conData.afterReversalD==-1); % CCW
    %
    %                 dataTc = conData(tempIc, :);
    %                 dataTcc = conData(tempIcc, :);
    %                 onset = unique(dataTc.rotationSpeed);
    %                 for ll = 1:length(onset)
    %                     dataTc.flashOnsetIdx(dataTc.rotationSpeed==onset(ll), 1) = ll;
    %                     dataTcc.flashOnsetIdx(dataTcc.rotationSpeed==onset(ll), 1) = ll;
    %                 end
    %                 meansacAmpSumTTSameC = accumarray(dataTc.flashOnsetIdx, dataTc.sacAmpSumTTSameMean, [], @mean);
    %                 stdsacAmpSumTTSameC = accumarray(dataTc.flashOnsetIdx, dataTc.sacAmpSumTTSameMean, [], @std);
    %
    %                 meansacAmpSumTTSameCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacAmpSumTTSameMean, [], @mean);
    %                 stdsacAmpSumTTSameCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacAmpSumTTSameMean, [], @std);
    %
    %                 meansacAmpSumTTAntiC = accumarray(dataTc.flashOnsetIdx, dataTc.sacAmpSumTTAntiMean, [], @mean);
    %                 stdsacAmpSumTTAntiC = accumarray(dataTc.flashOnsetIdx, dataTc.sacAmpSumTTAntiMean, [], @std);
    %
    %                 meansacAmpSumTTAntiCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacAmpSumTTAntiMean, [], @mean);
    %                 stdsacAmpSumTTAntiCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacAmpSumTTAntiMean, [], @std);
    %
    %                 errorbar(onset, meansacAmpSumTTSameC, ...
    %                     stdsacAmpSumTTSameC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 hold on
    %                 errorbar(onset, meansacAmpSumTTSameCC, ...
    %                     stdsacAmpSumTTSameCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %
    %                 errorbar(onset, meansacAmpSumTTAntiC, ...
    %                     stdsacAmpSumTTAntiC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 errorbar(onset, meansacAmpSumTTAntiCC, ...
    %                     stdsacAmpSumTTAntiCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 legend({'T-CW-Same' 'T-CCW-Same' 'T-CW-Anti' 'T-CCW-Anti'}, 'box', 'off')
    %             else
    %             tempI = find(conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %             dataT = conData(tempI, :);
    %             onset = unique(dataT.rotationSpeed);
    %             for ll = 1:length(onset)
    %                 dataT.flashOnsetIdx(dataT.rotationSpeed==onset(ll), 1) = ll;
    %             end
    %             meansacAmpSumTTSame = accumarray(dataT.flashOnsetIdx, dataT.sacAmpSumTTSameMean, [], @mean);
    %             stdsacAmpSumTTSame = accumarray(dataT.flashOnsetIdx, dataT.sacAmpSumTTSameMean, [], @std);
    %
    %             meansacAmpSumTTAnti = accumarray(dataT.flashOnsetIdx, dataT.sacAmpSumTTAntiMean, [], @mean);
    %             stdsacAmpSumTTAnti = accumarray(dataT.flashOnsetIdx, dataT.sacAmpSumTTAntiMean, [], @std);
    %
    %             errorbar(onset, meansacAmpSumTTSame, ...
    %                 stdsacAmpSumTTSame, 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %             errorbar(onset, meansacAmpSumTTAnti, ...
    %                 stdsacAmpSumTTAnti, 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             legend({'Same as target(CW)' 'Opposite to target(CCW)'}, 'box', 'off')
    %             end
    %
    %             xlabel('Rotation speed(deg/s)')
    %             ylabel('Saccade number (deg)')
    %             xlim([0 220])
    %             %         ylim([-2 2])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             title([eyeName{eye}, ' eye'])
    %         end
    %         saveas(gca, ['meanSpeedsacAmpSumTTRef_' endName '_' mergeName '.pdf'])
    %
    %         % saccade amp mean
    %         figure
    %         for eye = 1:size(eyeName, 2)
    %             subplot(1, size(eyeName, 2), eye);
    %             if strcmp(eyeName{eye}, 'L')
    %                 eyeN = 1; % 1-left,
    %             elseif strcmp(eyeName{eye}, 'R')
    %                 eyeN = 2; % 2-right
    %             end
    %
    %             if merged==0
    %                 tempIc = find(conData.eye==eyeN & conData.afterReversalD==1); % CW
    %                 tempIcc = find(conData.eye==eyeN & conData.afterReversalD==-1); % CCW
    %
    %                 dataTc = conData(tempIc, :);
    %                 dataTcc = conData(tempIcc, :);
    %                 onset = unique(dataTc.rotationSpeed);
    %                 for ll = 1:length(onset)
    %                     dataTc.flashOnsetIdx(dataTc.rotationSpeed==onset(ll), 1) = ll;
    %                     dataTcc.flashOnsetIdx(dataTcc.rotationSpeed==onset(ll), 1) = ll;
    %                 end
    %                 meansacAmpMeanTTSameC = accumarray(dataTc.flashOnsetIdx, dataTc.sacAmpMeanTTSameMean, [], @mean);
    %                 stdsacAmpMeanTTSameC = accumarray(dataTc.flashOnsetIdx, dataTc.sacAmpMeanTTSameMean, [], @std);
    %
    %                 meansacAmpMeanTTSameCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacAmpMeanTTSameMean, [], @mean);
    %                 stdsacAmpMeanTTSameCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacAmpMeanTTSameMean, [], @std);
    %
    %                 meansacAmpMeanTTAntiC = accumarray(dataTc.flashOnsetIdx, dataTc.sacAmpMeanTTAntiMean, [], @mean);
    %                 stdsacAmpMeanTTAntiC = accumarray(dataTc.flashOnsetIdx, dataTc.sacAmpMeanTTAntiMean, [], @std);
    %
    %                 meansacAmpMeanTTAntiCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacAmpMeanTTAntiMean, [], @mean);
    %                 stdsacAmpMeanTTAntiCC = accumarray(dataTcc.flashOnsetIdx, dataTcc.sacAmpMeanTTAntiMean, [], @std);
    %
    %                 errorbar(onset, meansacAmpMeanTTSameC, ...
    %                     stdsacAmpMeanTTSameC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 hold on
    %                 errorbar(onset, meansacAmpMeanTTSameCC, ...
    %                     stdsacAmpMeanTTSameCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %
    %                 errorbar(onset, meansacAmpMeanTTAntiC, ...
    %                     stdsacAmpMeanTTAntiC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 errorbar(onset, meansacAmpMeanTTAntiCC, ...
    %                     stdsacAmpMeanTTAntiCC, 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 legend({'T-CW-Same' 'T-CCW-Same' 'T-CW-Anti' 'T-CCW-Anti'}, 'box', 'off')
    %             else
    %             tempI = find(conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %             dataT = conData(tempI, :);
    %             onset = unique(dataT.rotationSpeed);
    %             for ll = 1:length(onset)
    %                 dataT.flashOnsetIdx(dataT.rotationSpeed==onset(ll), 1) = ll;
    %             end
    %             meansacAmpMeanTTSame = accumarray(dataT.flashOnsetIdx, dataT.sacAmpMeanTTSameMean, [], @mean);
    %             stdsacAmpMeanTTSame = accumarray(dataT.flashOnsetIdx, dataT.sacAmpMeanTTSameMean, [], @std);
    %
    %             meansacAmpMeanTTAnti = accumarray(dataT.flashOnsetIdx, dataT.sacAmpMeanTTAntiMean, [], @mean);
    %             stdsacAmpMeanTTAnti = accumarray(dataT.flashOnsetIdx, dataT.sacAmpMeanTTAntiMean, [], @std);
    %
    %             errorbar(onset, meansacAmpMeanTTSame, ...
    %                 stdsacAmpMeanTTSame, 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %             errorbar(onset, meansacAmpMeanTTAnti, ...
    %                 stdsacAmpMeanTTAnti, 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'none');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             legend({'Same as target(CW)' 'Opposite to target(CCW)'}, 'box', 'off')
    %             end
    %
    %             xlabel('Rotation speed(deg/s)')
    %             ylabel('Saccade number (deg)')
    %             xlim([0 220])
    %             %         ylim([-2 2])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             title([eyeName{eye}, ' eye'])
    %         end
    %         saveas(gca, ['meanSpeedsacAmpMeanTTRef_' endName '_' mergeName '.pdf'])
    
    %% single participants together
    %         figure
    %         for eye = 1:size(eyeName, 2)
    %             subplot(1, size(eyeName, 2), eye)
    %             if strcmp(eyeName{eye}, 'L')
    %                 eyeN = 1; % 1-left,
    %             elseif strcmp(eyeName{eye}, 'R')
    %                 eyeN = 2; % 2-right
    %             end
    %             for t = 1:size(names, 2)
    %                 tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %                 errorbar(conData.rotationSpeed(tempI), conData.perceptualErrorMean(tempI), ...
    %                     conData.perceptualErrorStd(tempI), 'LineStyle', 'None', ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 hold on
    %             end
    %             legend(names, 'box', 'off')
    %             xlabel('Rotation speed(deg/s)')
    %             ylabel('Perceptual error (deg)')
    %             xlim([0 220])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             title([eyeName{eye}, ' eye'])
    %         end
    %         saveas(gca, ['speedPercept.pdf'])
    %
    %         figure
    %         for eye = 1:size(eyeName, 2)
    %             subplot(1, size(eyeName, 2), eye);
    %             if strcmp(eyeName{eye}, 'L')
    %                 eyeN = 1; % 1-left,
    %             elseif strcmp(eyeName{eye}, 'R')
    %                 eyeN = 2; % 2-right
    %             end
    %             for t = 1:size(names, 2)
    %                 tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %                 errorbar(conData.rotationSpeed(tempI), conData.torsionVelTMean(tempI), ...
    %                     conData.torsionVelTStd(tempI), ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 hold on
    %             end
    %             legend(names, 'box', 'off', 'Location', 'SouthWest')
    %             xlabel('Rotation speed(deg/s)')
    %             ylabel('Torsional velocity (deg/s)')
    %             xlim([0 220])
    %             %         ylim([-2 2])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             title([eyeName{eye}, ' eye'])
    %         end
    %         saveas(gca, ['speedTorsion_' endName '.pdf'])
    
    %         % torsion angle
    %         figure
    %         for eye = 1:size(eyeName, 2)
    %             subplot(1, size(eyeName, 2), eye);
    %             if strcmp(eyeName{eye}, 'L')
    %                 eyeN = 1; % 1-left,
    %             elseif strcmp(eyeName{eye}, 'R')
    %                 eyeN = 2; % 2-right
    %             end
    %             for t = 1:size(names, 2)
    %                 tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %                 errorbar(conData.rotationSpeed(tempI), conData.torsionAngleTSameMean(tempI), ...
    %                     conData.torsionAngleTSameStd(tempI), ...
    %                     'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
    %                 hold on
    %             end
    %             xlabel('Rotation speed(deg/s)')
    %             ylabel('Torsion angle (deg)')
    %             xlim([0 220])
    %             %         ylim([-1.5 3.5])
    %             set(gca, 'FontSize', 15, 'box', 'off')
    %             title([eyeName{eye}, ' eye'])
    %         end
    %         saveas(gca, ['speedTorsionAngleTRef_' endName '.pdf'])
    %
    %     % saccade vs. speed
    %     % saccade sum amplitude
    %     figure
    %     for eye = 1:size(eyeName, 2)
    %         subplot(1, size(eyeName, 2), eye);
    %         if strcmp(eyeName{eye}, 'L')
    %             eyeN = 1; % 1-left,
    %         elseif strcmp(eyeName{eye}, 'R')
    %             eyeN = 2; % 2-right
    %         end
    %         for t = 1:size(names, 2)
    %             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %             errorbar(conData.rotationSpeed(tempI), conData.sacAmpSumTMean(tempI), ...
    %                 conData.sacAmpSumTStd(tempI), ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %         end
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Saccade amplitude sum (deg)')
    %         xlim([0 420])
    %         %         ylim([-1.5 3.5])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         title([eyeName{eye}, ' eye'])
    %     end
    %     saveas(gca, ['speedSacAmpSum_' endName '.pdf'])
    %     % saccade number
    %     figure
    %     for eye = 1:size(eyeName, 2)
    %         subplot(1, size(eyeName, 2), eye);
    %         if strcmp(eyeName{eye}, 'L')
    %             eyeN = 1; % 1-left,
    %         elseif strcmp(eyeName{eye}, 'R')
    %             eyeN = 2; % 2-right
    %         end
    %         for t = 1:size(names, 2)
    %             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %             errorbar(conData.rotationSpeed(tempI), conData.sacNumTMean(tempI), ...
    %                 conData.sacNumTStd(tempI), ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %         end
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Saccade number')
    %         xlim([0 420])
    %         %         ylim([-1.5 3.5])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         title([eyeName{eye}, ' eye'])
    %     end
    %     saveas(gca, ['speedSacNum_' endName '.pdf'])
    %     % saccade mean amplitude
    %     figure
    %     for eye = 1:size(eyeName, 2)
    %         subplot(1, size(eyeName, 2), eye);
    %         if strcmp(eyeName{eye}, 'L')
    %             eyeN = 1; % 1-left,
    %         elseif strcmp(eyeName{eye}, 'R')
    %             eyeN = 2; % 2-right
    %         end
    %         for t = 1:size(names, 2)
    %             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %             errorbar(conData.rotationSpeed(tempI), conData.sacAmpMeanTMean(tempI), ...
    %                 conData.sacAmpMeanTStd(tempI), ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %         end
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Saccade amplitude mean (deg)')
    %         xlim([0 420])
    %         %         ylim([-1.5 3.5])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         title([eyeName{eye}, ' eye'])
    %     end
    %     saveas(gca, ['speedSacAmpMean_' endName '.pdf'])
    
    %     close all
    %     end
end
