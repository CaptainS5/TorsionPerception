% Draw plots
% Xiuyun Wu, 03/25/2018
clear all; close all; clc

names = {'XWc' 'PHc' 'ARc' 'SMc' 'JFc' 'MSc'};
individualPlots = 0; % whether plot individual data
averagedPlots = 1;
conditions0 = [40 80 120 160 200];
conditions1 = [20 40 80 140 200];
conditions2 = [25 50 100 150 200];
conditions3 = [25 50 100 200 400];
direction = [-1 1]; % initial direction; in the plot shows the direction after reversal
trialPerCon = 60; % for each flash onset, all directions together though...
eyeName = {'L' 'R'};
endName = 'ToReversal';
% endName = '120msAroundReversal'; 
% endName = '120msToEnd';
load(['dataLong', endName, '.mat'])

cd ..
analysisF = pwd;

%% plots of individual data
if individualPlots==1
    for t = 1:size(names, 2)
        if t <=2
            conditions = conditions0;
        elseif t<=3
            conditions = conditions1;
        elseif t<=5
            conditions = conditions2;
        else
            conditions = conditions3;
        end
        cd([analysisF '\torsionPlots'])
        % torsion velocity
        figure
        for eye = 1:2
            tempIc = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==1); % clockwise
            tempIcc = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==-1); % counterclockwise
            [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
            [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
            tempDc = conData(tempIc, :);
            tempDcc = conData(tempIcc, :);
            
            subplot(1, 2, eye)
            errorbar(conditions, tempDc.torsionVelTMean(sortIc, 1), tempDc.torsionVelTStd(sortIc, 1), 'LineWidth', 1.5)
            hold on
            errorbar(conditions, tempDcc.torsionVelTMean(sortIcc, 1), tempDcc.torsionVelTStd(sortIcc, 1), 'LineWidth', 1.5)
            legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
                ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
                'box', 'off', 'FontSize', 10)
            xlabel('Rotation speed (deg/s)')
            ylabel('Torsion velocity (deg/s)')
            set(gca, 'FontSize', 15, 'box', 'off')
%             xlim([0 420])
            ylim([-2 2])
            title([eyeName{eye}, ' eye'])
        end
        
        saveas(gca, ['torsionVelocity_' names{t} '_' endName '.pdf'])
        
        % perceptual data
        figure
        for eye = 1:2
            tempIc = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==1); % clockwise
            tempIcc = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==-1); % counterclockwise
            [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
            [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
            tempDc = conData(tempIc, :);
            tempDcc = conData(tempIcc, :);
            
            subplot(1, 2, eye)
            errorbar(conditions, tempDc.perceptualErrorMean(sortIc, 1), tempDc.perceptualErrorStd(sortIc, 1), 'LineWidth', 1.5)
            hold on
            errorbar(conditions, -tempDcc.perceptualErrorMean(sortIcc, 1), tempDcc.perceptualErrorStd(sortIcc, 1), 'LineWidth', 1.5)
            legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
                ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
                'box', 'off', 'FontSize', 10, 'Location', 'northwest')
            xlabel('Rotation speed (deg/s)')
            ylabel('Perceptual error (deg)')
            set(gca, 'FontSize', 15, 'box', 'off')
%             xlim([0 420])
            ylim([-25 25])
            title([eyeName{eye}, ' eye'])
        end
        
        saveas(gca, ['perceptualError_' names{t} '.pdf'])
        
        cd([analysisF '\SaccadePlots'])
        % saccade number
        figure
        for eye = 1:2
            tempIc = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==1); % clockwise
            tempIcc = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==-1); % counterclockwise
            [Bc sortIc] = sort(conData.rotationSpeed(tempIc));
            [Bcc sortIcc] = sort(conData.rotationSpeed(tempIcc));
            tempDc = conData(tempIc, :);
            tempDcc = conData(tempIcc, :);
            
            subplot(1, 2, eye)
            errorbar(conditions, tempDc.sacNumTMean(sortIc, 1), tempDc.sacNumTStd(sortIc, 1), 'LineWidth', 1.5)
            hold on
            errorbar(conditions, tempDcc.sacNumTMean(sortIcc, 1), tempDcc.sacNumTStd(sortIcc, 1), 'LineWidth', 1.5)
            legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
                ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
                'box', 'off', 'FontSize', 10, 'Location', 'northwest')
            xlabel('Rotation speed (deg/s)')
            ylabel('Saccade number')
            title([eyeName{eye}, ' eye'])
        end
        
        saveas(gca, ['saccadeNumber_' names{t} '_' endName '.pdf'])
        
        % saccade sum amplitude
        figure
        for eye = 1:2
            subplot(1, 2, eye)
            errorbar(conditions, tempDc.sacAmpSumTMean(sortIc, 1), tempDc.sacAmpSumTStd(sortIc, 1), 'LineWidth', 1.5)
            hold on
            errorbar(conditions, tempDcc.sacAmpSumTMean(sortIcc, 1), tempDcc.sacAmpSumTStd(sortIcc, 1), 'LineWidth', 1.5)
            legend({['CW(' num2str(mean(tempDc.nonErrorTrialN(sortIc, 1))) ')'] ...
                ['CCW(' num2str(mean(tempDcc.nonErrorTrialN(sortIcc, 1))) ')']}, ...
                'box', 'off', 'FontSize', 10, 'Location', 'northwest')
            xlabel('Rotation speed (deg/s)')
            ylabel('Saccade sum amplitude (deg)')
            title([eyeName{eye}, ' eye'])
        end
        
        saveas(gca, ['saccadeSumAmplitude_' names{t} '_' endName '.pdf'])
        
        close all
    end
end

% averaged plots
if averagedPlots==1
    cd([analysisF '\summaryPlots'])
    % torsionV/perceptual error/torsionVGain vs. speed, scatter
    markerC = [77 255 202; 70 95 232; 232 123 70; 255 231 108; 255 90 255; 100 178 42]/255;
        figure
            for eye = 1:2
                subplot(1, 2, eye)
                for t = 1:size(names, 2)
                    tempI = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==0); % merged initial direction
                    errorbar(conData.rotationSpeed(tempI), conData.perceptualErrorMean(tempI), ...
                        conData.perceptualErrorStd(tempI), 'LineStyle', 'None', ...
                        'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
                    hold on
                end
                xlabel('Rotation speed(deg/s)')
                ylabel('Perceptual error (deg)')
                xlim([0 420])
                set(gca, 'FontSize', 15, 'box', 'off')
                title([eyeName{eye}, ' eye'])
            end
            saveas(gca, ['speedPercept.pdf'])
    
            figure
            for eye = 1:2
                subplot(1, 2, eye);
                for t = 1:size(names, 2)
                    tempI = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==0); % merged initial direction
                    errorbar(conData.rotationSpeed(tempI), conData.torsionVelTMean(tempI), ...
                        conData.torsionVelTStd(tempI), 'LineStyle', 'None', ...
                        'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
                    hold on
                end
%                 legend(names, 'box', 'off', 'Location', 'SouthWest')
                xlabel('Rotation speed(deg/s)')
                ylabel('Torsional velocity (deg/s)')
                xlim([0 420])
                ylim([-2 2])
                set(gca, 'FontSize', 15, 'box', 'off')
                title([eyeName{eye}, ' eye'])
            end
            saveas(gca, ['speedTorsion_' endName '.pdf'])
    
            figure
            for eye = 1:2
                subplot(1, 2, eye);
                for t = 1:size(names, 2)
                    tempI = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==0); % merged initial direction
                    errorbar(conData.rotationSpeed(tempI), conData.torsionVelTGainMean(tempI), ...
                        conData.torsionVelTGainStd(tempI), 'LineStyle', 'None', ...
                        'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
                    hold on
                end
                xlabel('Rotation speed(deg/s)')
                ylabel('Torsional velocity gain')
                xlim([0 420])
                ylim([-0.03 0.08])
                set(gca, 'FontSize', 15, 'box', 'off')
                title([eyeName{eye}, ' eye'])
            end
            saveas(gca, ['speedTorsionGain_' endName '.pdf'])
    
        % saccade vs. speed
        figure
        for eye = 1:2
            subplot(1, 2, eye);
            for t = 1:size(names, 2)
                tempI = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==0); % merged initial direction
                errorbar(conData.rotationSpeed(tempI), conData.sacAmpSumTMean(tempI), ...
                    conData.sacAmpSumTStd(tempI), 'LineStyle', 'None', ...
                    'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
                hold on
            end
            xlabel('Rotation speed(deg/s)')
            ylabel('Saccade amplitude sum (deg)')
            xlim([0 420])
            ylim([-1.5 3.5])
            set(gca, 'FontSize', 15, 'box', 'off')
            title([eyeName{eye}, ' eye'])
        end
        saveas(gca, ['speedSacAmpSum_' endName '.pdf'])
    
        figure
        for eye = 1:2
            subplot(1, 2, eye);
            for t = 1:size(names, 2)
                tempI = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==0); % merged initial direction
                errorbar(conData.rotationSpeed(tempI), conData.sacNumTMean(tempI), ...
                    conData.sacNumTStd(tempI), 'LineStyle', 'None', ...
                    'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
                hold on
            end
            xlabel('Rotation speed(deg/s)')
            ylabel('Saccade number')
            xlim([0 420])
            ylim([-1.5 3.5])
            set(gca, 'FontSize', 15, 'box', 'off')
            title([eyeName{eye}, ' eye'])
        end
        saveas(gca, ['speedSacNum_' endName '.pdf'])
    
        figure
        for eye = 1:2
            subplot(1, 2, eye);
            for t = 1:size(names, 2)
                tempI = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==0); % merged initial direction
                errorbar(conData.rotationSpeed(tempI), conData.sacAmpMeanTMean(tempI), ...
                    conData.sacAmpMeanTStd(tempI), 'LineStyle', 'None', ...
                    'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', markerC(t, :), 'MarkerEdgeColor', 'none')
                hold on
            end
            xlabel('Rotation speed(deg/s)')
            ylabel('Saccade amplitude mean (deg)')
            xlim([0 420])
            ylim([-1.5 3.5])
            set(gca, 'FontSize', 15, 'box', 'off')
            title([eyeName{eye}, ' eye'])
        end
        saveas(gca, ['speedSacAmpMean_' endName '.pdf'])
    
    % each speed, scatter torsionV vs. perceptual error, normalized
    speedN = unique(conData.rotationSpeed);
    
    %     for ii = 1:length(speedN)
    figure
    for eye = 1:2
        subplot(1, 2, eye)
        for t = 1:size(names, 2)
            tempI = find(conData.sub==t & conData.eye==eye & conData.afterReversalD==0);
            if ~isempty(tempI)
                scatter(conData.torsionVelTMean(tempI, 1), conData.perceptualErrorMean(tempI, 1),...
                    'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none', 'LineWidth', 2)
                hold on
            end
            xlabel('Torsional velocity (deg/s)')
            ylabel('Perceptual bias (deg)')
            %                 title(['Speed ', num2str(speedN(ii)), ', ', eyeName{eye}])
            %                 [rho pval] = corr(trialData.torsionVelTMergedNorm(tempI, 1), trialData.perceptualErrNorm(tempI, 1));
            %                 xlim([-4 4])
            %                 ylim([-4 4])
            set(gca, 'FontSize', 10, 'box', 'off')
            %                 title([eyeName{eye}, ', rho=', num2str(rho, '%.2f'), ', p=', num2str(pval, '%.2f'), '(', num2str(length(tempI)), ' trials)'])
            axis square
        end
    end
    %         saveas(gca, ['torsionVSperceptNorm_speed', num2str(speedN(ii)), '.pdf'])
    saveas(gca, ['torsionVSpercept_' endName '.pdf'])
    
    %         close all
    %     end
end
