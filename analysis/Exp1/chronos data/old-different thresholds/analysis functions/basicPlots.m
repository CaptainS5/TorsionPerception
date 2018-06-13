% Draw plots
% Xiuyun Wu, 06/13/2018
clear all; close all; clc
%
% names = {'XWc' 'PHc' 'ARc' 'SMc' 'JFc' 'MSc'};
% conditions0 = [40 80 120 160 200];
% conditions1 = [20 40 80 140 200];
% conditions2 = [25 50 100 150 200];
% conditions3 = [25 50 100 200 400];
% names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
names = {'XWcontrolTest' 'XWcontrolTest2' 'XWcontrolTest3'};
startT = 1; % start from which participant for individual plots
conditions = [25 50 100 200 400];
individualPlots = 1; % whether plot individual data
averagedPlots = 0;
merged = 1;
direction = [-1 1]; % initial direction; in the plot shows the direction after reversal
trialPerCon = 60; % for each flash onset, all directions together though...
% eyeName = {'L' 'R'};
eyeName = {'R'};
% endName = '120msToReversal'; % from beginning of stimulus to reversal
% endName = '120msAroundReversal';
% endName = '120msToEnd'; % 120ms after reversal to end of display
endName = 'atReversal';

if merged==0
    mergeName = 'notMerged';
else
    mergeName = 'merged';
end
load(['dataLong', endName, '.mat'])

cd ..
analysisF = pwd;

%% plots of individual data
if individualPlots==1
    for t = startT:size(names, 2)
        %         if t <=2
        %             conditions = conditions0;
        %         elseif t<=3
        %             conditions = conditions1;
        %         elseif t<=5
        %             conditions = conditions2;
        %         else
        %             conditions = conditions3;
        %         end
        
        %                 cd([analysisF '\torsionPlots'])
        %                 % torsion velocity
        %                 figure
        %                 for eye = 1:size(eyeName, 2)
        %                     subplot(1, size(eyeName, 2), eye)
        %                     if strcmp(eyeName{eye}, 'L')
        %                         eyeN = 1; % 1-left,
        %                     elseif strcmp(eyeName{eye}, 'R')
        %                         eyeN = 2; % 2-right
        %                     end
        %                     if merged==0
        %                         tempIc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==1); % clockwise
        %                         tempIcc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==-1); % counterclockwise
        %                         [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
        %                         [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
        %                         tempDc = conData(tempIc, :);
        %                         tempDcc = conData(tempIcc, :);
        %
        %                         errorbar(conditions, tempDc.torsionVelTMean(sortIc, 1), tempDc.torsionVelTStd(sortIc, 1), 'LineWidth', 1.5)
        %                         hold on
        %                         errorbar(conditions, tempDcc.torsionVelTMean(sortIcc, 1), tempDcc.torsionVelTStd(sortIcc, 1), 'LineWidth', 1.5)
        %                         legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
        %                             ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
        %                             'box', 'off', 'FontSize', 10)
        %                     else
        %                         tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % clockwise
        %                         [B sortI] = sort(conData.rotationSpeed(tempI));
        %                         tempD = conData(tempI, :);
        %
        %                         errorbar(conditions, tempD.torsionVelTMean(sortI, 1), tempD.torsionVelTStd(sortI, 1), 'LineWidth', 1.5)
        %                     end
        %                     xlabel('Rotation speed (deg/s)')
        %                     ylabel('Torsion velocity (deg/s)')
        %                     set(gca, 'FontSize', 15, 'box', 'off')
        %                     %             xlim([0 420])
        %                     %             ylim([-2 2])
        %                     title([eyeName{eye}, ' eye'])
        %                 end
        %                 saveas(gca, ['torsionVelocity_' names{t} '_' endName '_' mergeName '.pdf'])
        %
        %                 % perceptual data
        %                 figure
        %                 for eye = 1:size(eyeName, 2)
        %                     subplot(1, size(eyeName, 2), eye)
        %                     if strcmp(eyeName{eye}, 'L')
        %                         eyeN = 1; % 1-left,
        %                     elseif strcmp(eyeName{eye}, 'R')
        %                         eyeN = 2; % 2-right
        %                     end
        %                     if merged==0
        %                         tempIc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==1); % clockwise
        %                         tempIcc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==-1); % counterclockwise
        %                         [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
        %                         [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
        %                         tempDc = conData(tempIc, :);
        %                         tempDcc = conData(tempIcc, :);
        %
        %                         errorbar(conditions, tempDc.perceptualErrorMean(sortIc, 1), tempDc.perceptualErrorStd(sortIc, 1), 'LineWidth', 1.5)
        %                         hold on
        %                         errorbar(conditions, -tempDcc.perceptualErrorMean(sortIcc, 1), tempDcc.perceptualErrorStd(sortIcc, 1), 'LineWidth', 1.5)
        %                         legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
        %                             ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
        %                             'box', 'off', 'FontSize', 10, 'Location', 'northwest')
        %                     else
        %                         tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % clockwise
        %                         [B sortI] = sort(conData.rotationSpeed(tempI));
        %                         tempD = conData(tempI, :);
        %
        %                         errorbar(conditions, tempD.perceptualErrorMean(sortI, 1), tempD.perceptualErrorStd(sortI, 1), 'LineWidth', 1.5)
        %                     end
        %
        %                     xlabel('Rotation speed (deg/s)')
        %                     ylabel('Perceptual error (deg)')
        %                     set(gca, 'FontSize', 15, 'box', 'off')
        %                     %             xlim([0 420])
        %                     ylim([-25 25])
        %                     title([eyeName{eye}, ' eye'])
        %                 end
        %                 saveas(gca, ['perceptualError_' names{t} '_' mergeName '.pdf'])
        %
        %                 % torsion angle
        %                 figure
        %                 for eye = 1:size(eyeName, 2)
        %                     subplot(1, size(eyeName, 2), eye)
        %                     if strcmp(eyeName{eye}, 'L')
        %                         eyeN = 1; % 1-left,
        %                     elseif strcmp(eyeName{eye}, 'R')
        %                         eyeN = 2; % 2-right
        %                     end
        %                     if merged==0
        %                         tempIc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==1); % clockwise
        %                         tempIcc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==-1); % counterclockwise
        %                         [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
        %                         [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
        %                         tempDc = conData(tempIc, :);
        %                         tempDcc = conData(tempIcc, :);
        %
        %                         errorbar(conditions, tempDc.torsionAngleMean(sortIc, 1), tempDc.torsionAngleStd(sortIc, 1), 'LineWidth', 1.5)
        %                         hold on
        %                         errorbar(conditions, tempDcc.torsionAngleMean(sortIcc, 1), tempDcc.torsionAngleStd(sortIcc, 1), 'LineWidth', 1.5)
        %                         legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
        %                             ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
        %                             'box', 'off', 'FontSize', 10)
        %                     else
        %                         tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % clockwise
        %                         [B sortI] = sort(conData.rotationSpeed(tempI));
        %                         tempD = conData(tempI, :);
        %
        %                         errorbar(conditions, tempD.torsionAngleMean(sortI, 1), tempD.torsionAngleStd(sortI, 1), 'LineWidth', 1.5)
        %                     end
        %                     xlabel('Rotation speed (deg/s)')
        %                     ylabel('Torsion angle (deg)')
        %                     set(gca, 'FontSize', 15, 'box', 'off')
        %                     %             xlim([0 420])
        %                     %             ylim([-2 2])
        %                     title([eyeName{eye}, ' eye'])
        %                 end
        %                 saveas(gca, ['torsionAngle_' names{t} '_' endName '_' mergeName '.pdf'])
        
        cd([analysisF '\correlationPlots\individual'])
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
        
%         torsion position trial correlation with perception, merged direction
                figure
                for eye = 1:size(eyeName, 2)
                    subplot(1, size(eyeName, 2), eye)
                    if strcmp(eyeName{eye}, 'L')
                        eyeN = 1; % 1-left,
                    elseif strcmp(eyeName{eye}, 'R')
                        eyeN = 2; % 2-right
                    end
        
                    tempI = find(trialData.sub==t & trialData.eye==eyeN); % clockwise
        
                    scatter(trialData.torsionPositionMerged(tempI, 1), trialData.perceptualError(tempI, 1), 'LineWidth', 1)
                    ylabel('Perceptual errors (deg)')
                    xlabel('Torsion position (deg)')
                    set(gca, 'FontSize', 15, 'box', 'off')
                    %             xlim([0 420])
                    %             ylim([-2 2])
                    [rho pval] = corr(trialData.torsionPositionMerged(tempI, 1), trialData.perceptualError(tempI, 1));
                    title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
                end
                saveas(gca, ['trialCorrelationPosition&perception_' names{t} '_' endName '.pdf'])
        
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
        
        %                 cd([analysisF '\SaccadePlots'])
        %                 % saccade number
        %                 figure
        %                 for eye = 1:size(eyeName, 2)
        %                     subplot(1, size(eyeName, 2), eye)
        %                     if strcmp(eyeName{eye}, 'L')
        %                         eyeN = 1; % 1-left,
        %                     elseif strcmp(eyeName{eye}, 'R')
        %                         eyeN = 2; % 2-right
        %                     end
        %                     if merged==0
        %                         tempIc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==1); % clockwise
        %                         tempIcc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==-1); % counterclockwise
        %                         [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
        %                         [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
        %                         tempDc = conData(tempIc, :);
        %                         tempDcc = conData(tempIcc, :);
        %
        %                         errorbar(conditions, tempDc.sacNumTMean(sortIc, 1), tempDc.sacNumTStd(sortIc, 1), 'LineWidth', 1.5)
        %                         hold on
        %                         errorbar(conditions, tempDcc.sacNumTMean(sortIcc, 1), tempDcc.sacNumTStd(sortIcc, 1), 'LineWidth', 1.5)
        %                         legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
        %                             ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
        %                             'box', 'off', 'FontSize', 10, 'Location', 'northwest')
        %                     else
        %                         tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % clockwise
        %                         [B sortI] = sort(conData.rotationSpeed(tempI));
        %                         tempD = conData(tempI, :);
        %
        %                         errorbar(conditions, tempD.sacNumTMean(sortI, 1), tempD.sacNumTStd(sortI, 1), 'LineWidth', 1.5)
        %                     end
        %
        %                     xlabel('Rotation speed (deg/s)')
        %                     ylabel('Saccade number')
        %                     title([eyeName{eye}, ' eye'])
        %                 end
        %                 saveas(gca, ['saccadeNumber_' names{t} '_' endName '_' mergeName '.pdf'])
        %
        %                 % saccade sum amplitude
        %                 figure
        %                 for eye = 1:size(eyeName, 2)
        %                     subplot(1, size(eyeName, 2), eye)
        %                     if strcmp(eyeName{eye}, 'L')
        %                         eyeN = 1; % 1-left,
        %                     elseif strcmp(eyeName{eye}, 'R')
        %                         eyeN = 2; % 2-right
        %                     end
        %                     if merged==0
        %                         tempIc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==1); % clockwise
        %                         tempIcc = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==-1); % counterclockwise
        %                         [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
        %                         [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
        %                         tempDc = conData(tempIc, :);
        %                         tempDcc = conData(tempIcc, :);
        %
        %                         errorbar(conditions, tempDc.sacAmpSumTMean(sortIc, 1), tempDc.sacAmpSumTStd(sortIc, 1), 'LineWidth', 1.5)
        %                         hold on
        %                         errorbar(conditions, tempDcc.sacAmpSumTMean(sortIcc, 1), tempDcc.sacAmpSumTStd(sortIcc, 1), 'LineWidth', 1.5)
        %                         legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
        %                             ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
        %                             'box', 'off', 'FontSize', 10, 'Location', 'northwest')
        %                     else
        %                         tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % clockwise
        %                         [Bc sortI] = sort(conData.rotationSpeed(tempI));
        %                         tempD = conData(tempI, :);
        %
        %                         errorbar(conditions, tempD.sacAmpSumTMean(sortI, 1), tempD.sacAmpSumTStd(sortI, 1), 'LineWidth', 1.5)
        %                     end
        %
        %                     xlabel('Rotation speed (deg/s)')
        %                     ylabel('Saccade sum amplitude (deg)')
        %                     title([eyeName{eye}, ' eye'])
        %                 end
        %                 saveas(gca, ['saccadeSumAmplitude_' names{t} '_' endName '_' mergeName '.pdf'])
        
        close all
    end
end

%% averaged plots
if averagedPlots==1
    %     % torsionV/perceptual error/torsionVGain vs. speed, scatter
    for t = 1:size(names, 2)
        if t<=3
            markerC(t, :) = (t+2)/5*[77 255 202]/255;
        elseif t<=6
            markerC(t, :) = (t-1)/5*[70 95 232]/255;
        elseif t<=9
            markerC(t, :) = (t-4)/5*[232 123 70]/255;
        elseif t<=12
            markerC(t, :) = (t-7)/5*[255 231 108]/255;
        elseif t<=15
            markerC(t, :) = (t-10)/5*[255 90 255]/255;
        end
    end
    
    %% scatter plots
    cd([analysisF '\correlationPlots'])
    %     %     each speed, scatter torsion vs. perceptual error
    %     speedN = unique(conData.rotationSpeed);
    %     %     for ii = 1:length(speedN)
    figure
    for eye = 1:size(eyeName, 2)
        subplot(1, size(eyeName, 2), eye)
        if strcmp(eyeName{eye}, 'L')
            eyeN = 1; % 1-left,
        elseif strcmp(eyeName{eye}, 'R')
            eyeN = 2; % 2-right
        end
        for t = 1:size(names, 2)
            tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0);
            if ~isempty(tempI)
                scatter(conData.torsionVelTMean(tempI, 1), conData.perceptualErrorMean(tempI, 1), 'LineWidth', 2,...
                    'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
                hold on
            end
            xlabel('Torsional velocity (deg/s)')
            ylabel('Perceptual bias (deg)')
            %                 title(['Speed ', num2str(speedN(ii)), ', ', eyeName{eye}])
            %                 xlim([-4 4])
            %                 ylim([-4 4])
            set(gca, 'FontSize', 15, 'box', 'off')
            axis square
        end
        tempI = find(conData.eye==eyeN & conData.afterReversalD==0);
        [rho pval] = partialcorr([conData.torsionVelTMean(tempI, 1) conData.perceptualErrorMean(tempI, 1)], conData.rotationSpeed(tempI, 1));
        title([eyeName{eye}, ', rho=', num2str(rho(1, 2), '%.2f'), ', p=', num2str(pval(1, 2), '%.3f')])
        %         [rho pval] = corr(conData.torsionVelTMean(tempI, 1), conData.perceptualErrorMean(tempI, 1));
        %         title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
    end
    %             saveas(gca, ['torsionVSperceptNorm_speed', num2str(speedN(ii)), '.pdf'])
    saveas(gca, ['torsionVelocityVSperceptPartialCorr_' endName '.pdf'])
    
    figure
    for eye = 1:size(eyeName, 2)
        subplot(1, size(eyeName, 2), eye)
        if strcmp(eyeName{eye}, 'L')
            eyeN = 1; % 1-left,
        elseif strcmp(eyeName{eye}, 'R')
            eyeN = 2; % 2-right
        end
        for t = 1:size(names, 2)
            tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0);
            if ~isempty(tempI)
                scatter(conData.torsionAngleMean(tempI, 1), conData.perceptualErrorMean(tempI, 1), 'LineWidth', 2,...
                    'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
                hold on
            end
            xlabel('Torsional angle (deg)')
            ylabel('Perceptual bias (deg)')
            %                 title(['Speed ', num2str(speedN(ii)), ', ', eyeName{eye}])
            %                 xlim([-4 4])
            %                 ylim([-4 4])
            set(gca, 'FontSize', 15, 'box', 'off')
            axis square
        end
        tempI = find(conData.eye==eyeN & conData.afterReversalD==0);
        [rho pval] = partialcorr([conData.torsionAngleMean(tempI, 1) conData.perceptualErrorMean(tempI, 1)], conData.rotationSpeed(tempI, 1));
        title([eyeName{eye}, ', rho=', num2str(rho(1, 2), '%.2f'), ', p=', num2str(pval(1, 2), '%.3f')])
        %         [rho pval] = corr(conData.torsionAngleMean(tempI, 1), conData.perceptualErrorMean(tempI, 1));
        %         title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
    end
    %         saveas(gca, ['torsionVSperceptNorm_speed', num2str(speedN(ii)), '.pdf'])
    saveas(gca, ['torsionAngleVSperceptPartialCorr_' endName '.pdf'])
    
% % retinal angle and perception
% figure
% for eye = 1:size(eyeName, 2)
%     subplot(1, size(eyeName, 2), eye)
%     if strcmp(eyeName{eye}, 'L')
%         eyeN = 1; % 1-left,
%     elseif strcmp(eyeName{eye}, 'R')
%         eyeN = 2; % 2-right
%     end
%     for t = 1:size(names, 2)
%         tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0);
%         if ~isempty(tempI)
%             scatter(conData.torsionPosMean(tempI, 1), conData.perceptualErrorMean(tempI, 1), 'LineWidth', 2,...
%                 'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
%             hold on
%         end
%         xlabel('Torsion position (deg)')
%         ylabel('Perceptual bias (deg)')
%         %                 title(['Speed ', num2str(speedN(ii)), ', ', eyeName{eye}])
%         %                 xlim([-4 4])
%         %                 ylim([-4 4])
%         set(gca, 'FontSize', 15, 'box', 'off')
%         axis square
%     end
%     tempI = find(conData.eye==eyeN & conData.afterReversalD==0);
%     [rho pval] = partialcorr([conData.torsionPosMean(tempI, 1) conData.perceptualErrorMean(tempI, 1)], conData.rotationSpeed(tempI, 1));
%     title([eyeName{eye}, ', rho=', num2str(rho(1, 2), '%.2f'), ', p=', num2str(pval(1, 2), '%.3f')])
%     %         [rho pval] = corr(conData.torsionAngleMean(tempI, 1), conData.perceptualErrorMean(tempI, 1));
%     %         title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.3f')])
% end
% %         saveas(gca, ['torsionVSperceptNorm_speed', num2str(speedN(ii)), '.pdf'])
% saveas(gca, ['torsionPositionVSperceptPartialCorr_' endName '.pdf'])

        %% mean of participants    
        %     cd([analysisF '\summaryPlots'])
    %     figure
    %     for eye = 1:size(eyeName, 2)
    %         subplot(1, size(eyeName, 2), eye)
    %         if strcmp(eyeName{eye}, 'L')
    %             eyeN = 1; % 1-left,
    %         elseif strcmp(eyeName{eye}, 'R')
    %             eyeN = 2; % 2-right
    %         end
    %         tempI = find(conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %         dataT = conData(tempI, :);
    %         onset = unique(dataT.rotationSpeed);
    %         for ll = 1:length(onset)
    %             dataT.flashOnsetIdx(dataT.rotationSpeed==onset(ll), 1) = ll;
    %         end
    %         meanPerceptualError = accumarray(dataT.flashOnsetIdx, dataT.perceptualErrorMean, [], @mean);
    %         stdPerceptualError = accumarray(dataT.flashOnsetIdx, dataT.perceptualErrorMean, [], @std);
    %
    %         errorbar(onset, meanPerceptualError, ...
    %             stdPerceptualError, 'LineStyle', 'None', ...
    %             'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Perceptual error (deg)')
    %         xlim([0 420])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         title([eyeName{eye}, ' eye'])
    %     end
    %     saveas(gca, ['meanSpeedPercept.pdf'])
    %
    %     figure
    %     for eye = 1:size(eyeName, 2)
    %         subplot(1, size(eyeName, 2), eye);
    %         if strcmp(eyeName{eye}, 'L')
    %             eyeN = 1; % 1-left,
    %         elseif strcmp(eyeName{eye}, 'R')
    %             eyeN = 2; % 2-right
    %         end
    %         tempI = find(conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %         dataT = conData(tempI, :);
    %         onset = unique(dataT.rotationSpeed);
    %         for ll = 1:length(onset)
    %             dataT.flashOnsetIdx(dataT.rotationSpeed==onset(ll), 1) = ll;
    %         end
    %         meanTorsionVelTError = accumarray(dataT.flashOnsetIdx, dataT.torsionVelTMean, [], @mean);
    %         stdTorsionVelTError = accumarray(dataT.flashOnsetIdx, dataT.torsionVelTMean, [], @std);
    %
    %         errorbar(onset, meanTorsionVelTError, ...
    %             stdTorsionVelTError, 'LineStyle', 'None', ...
    %             'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Torsional velocity (deg/s)')
    %         xlim([0 420])
    %         %         ylim([-2 2])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         title([eyeName{eye}, ' eye'])
    %     end
    %     saveas(gca, ['meanSpeedTorsionV_' endName '.pdf'])
    %
    %     figure
    %     for eye = 1:size(eyeName, 2)
    %         subplot(1, size(eyeName, 2), eye);
    %         if strcmp(eyeName{eye}, 'L')
    %             eyeN = 1; % 1-left,
    %         elseif strcmp(eyeName{eye}, 'R')
    %             eyeN = 2; % 2-right
    %         end
    %         tempI = find(conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %         dataT = conData(tempI, :);
    %         onset = unique(dataT.rotationSpeed);
    %         for ll = 1:length(onset)
    %             dataT.flashOnsetIdx(dataT.rotationSpeed==onset(ll), 1) = ll;
    %         end
    %         meanTorsionAngleError = accumarray(dataT.flashOnsetIdx, dataT.torsionAngleMean, [], @mean);
    %         stdTorsionAngleError = accumarray(dataT.flashOnsetIdx, dataT.torsionAngleMean, [], @std);
    %
    %         errorbar(onset, meanTorsionAngleError, ...
    %             stdTorsionAngleError, 'LineStyle', 'None', ...
    %             'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Torsional angle (deg)')
    %         xlim([0 420])
    %         %         ylim([-2 2])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         title([eyeName{eye}, ' eye'])
    %     end
    %     saveas(gca, ['meanSpeedTorsionA_' endName '.pdf'])
    %
    %     %% single participants together
    %     figure
    %     for eye = 1:size(eyeName, 2)
    %         subplot(1, size(eyeName, 2), eye)
    %         if strcmp(eyeName{eye}, 'L')
    %             eyeN = 1; % 1-left,
    %         elseif strcmp(eyeName{eye}, 'R')
    %             eyeN = 2; % 2-right
    %         end
    %         for t = 1:size(names, 2)
    %             tempI = find(conData.sub==t & conData.eye==eyeN & conData.afterReversalD==0); % merged initial direction
    %             errorbar(conData.rotationSpeed(tempI), conData.perceptualErrorMean(tempI), ...
    %                 conData.perceptualErrorStd(tempI), 'LineStyle', 'None', ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %         end
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Perceptual error (deg)')
    %         xlim([0 420])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         title([eyeName{eye}, ' eye'])
    %     end
    %     saveas(gca, ['speedPercept.pdf'])
    %
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
    %             errorbar(conData.rotationSpeed(tempI), conData.torsionVelTMean(tempI), ...
    %                 conData.torsionVelTStd(tempI), ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %         end
    %         legend(names, 'box', 'off', 'Location', 'SouthWest')
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Torsional velocity (deg/s)')
    %         xlim([0 420])
    %         %         ylim([-2 2])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         title([eyeName{eye}, ' eye'])
    %     end
    %     saveas(gca, ['speedTorsion_' endName '.pdf'])
    %
    %     % torsion angle
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
    %             errorbar(conData.rotationSpeed(tempI), conData.torsionAngleMean(tempI), ...
    %                 conData.torsionAngleStd(tempI), ...
    %                 'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
    %             hold on
    %         end
    %         xlabel('Rotation speed(deg/s)')
    %         ylabel('Torsion angle (deg)')
    %         xlim([0 420])
    %         %         ylim([-1.5 3.5])
    %         set(gca, 'FontSize', 15, 'box', 'off')
    %         title([eyeName{eye}, ' eye'])
    %     end
    %     saveas(gca, ['speedTorsionAngle_' endName '.pdf'])
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
