% function analyzeChange
% analyze change of torsion before vs. after to see the correlation
% Xiuyun Wu, 04/23/2018
clear all; close all; clc

% names = {'XWc' 'PHc' 'ARc' 'SMc' 'JFc' 'MSc'};
% conditions0 = [40 80 120 160 200];
% conditions1 = [20 40 80 140 200];
% conditions2 = [25 50 100 150 200];
% conditions3 = [25 50 100 200 400];
names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY'};
startT = 1; % start from which participant
conditions = [25 50 100 200 400];
individualPlots = 0; % whether plot individual data
averagedPlots = 1;
loadData = 1;
direction = [-1 1]; % initial direction; in the plot shows the direction after reversal
trialPerCon = 60; % for each flash onset, all directions together though...
% eyeName = {'L' 'R'};
eyeName = {'R'};
endName1 = '120msToReversal'; % from beginning of stimulus to reversal
% endName = '120msAroundReversal';
endName2 = '120msToEnd'; % 120ms after reversal to end of display
d1 = load(['dataLong', endName1, '.mat']);
d2 = load(['dataLong', endName2, '.mat']);

cd ..
analysisF = pwd;

%% calculate and save data
if loadData==1
    load (['dataChangeLong_', endName1, '_', endName2, '.mat'])
else
    dataChange = table();
    dataChangeSummary = table();
    subT = 1;
    subS = 1;
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
        
        for eye = 1:size(eyeName, 2)
            % individual trials
            if strcmp(eyeName{eye}, 'L')
                eyeN = 1; % 1-left,
            elseif strcmp(eyeName{eye}, 'R')
                eyeN = 2; % 2-right
            end
            subIdx = find(d1.trialData.sub==t & d1.trialData.eye==eyeN);
            for ii = 1:length(subIdx)
                dataChange.sub(subT, 1) = d1.trialData.sub(subIdx(ii), 1);
                dataChange.eye(subT, 1) = d1.trialData.eye(subIdx(ii), 1); % 1-left, 2-righ
                
                dataChange.rotationSpeed(subT, 1) = d1.trialData.rotationSpeed(subIdx(ii), 1);
                dataChange.afterReversalD(subT, 1) = d1.trialData.afterReversalD(subIdx(ii), 1); % 1-clockwise, -1 counterclockwise
                
                dataChange.perceptualError(subT, 1) = d1.trialData.perceptualError(subIdx(ii), 1);
                
                dataChange.torsionVDiff(subT, 1) = d2.trialData.torsionVelT(subIdx(ii), 1)-d1.trialData.torsionVelT(subIdx(ii), 1);
                dataChange.torsionADiff(subT, 1) = d2.trialData.torsionAngle(subIdx(ii), 1)-d1.trialData.torsionAngle(subIdx(ii), 1);
                
                dataChange.torsionVDiv(subT, 1) = -d2.trialData.torsionVelT(subIdx(ii), 1)./d1.trialData.torsionVelT(subIdx(ii), 1);
                dataChange.torsionADiv(subT, 1) = -d2.trialData.torsionAngle(subIdx(ii), 1)./d1.trialData.torsionAngle(subIdx(ii), 1);
                subT = subT+1;
            end
            
            % summarize the data
            for conI = 1:size(conditions, 2)
                for dirI = 1:2
                    subIdx = find(dataChange.sub==t & dataChange.eye==eyeN & dataChange.rotationSpeed==conditions(conI) & dataChange.afterReversalD==-direction(dirI));
                    dataChangeSummary.sub(subS, 1) = t;
                    dataChangeSummary.eye(subS, 1) = dataChange.eye(subIdx(1)); % 1-left, 2-righ
                    
                    dataChangeSummary.rotationSpeed(subS, 1) = conditions(conI);
                    dataChangeSummary.afterReversalD(subS, 1) = -direction(dirI); % 1-clockwise, -1 counterclockwise
                    
                    dataChangeSummary.perceptualErrorMean(subS, 1) = nanmean(dataChange.perceptualError(subIdx, 1));
                    dataChangeSummary.perceptualErrorStd(subS, 1) = nanstd(dataChange.perceptualError(subIdx, 1));
                    
                    dataChangeSummary.torsionVDiffMean(subS, 1) = nanmean(dataChange.torsionVDiff(subIdx, 1));
                    dataChangeSummary.torsionADiffMean(subS, 1) = nanmean(dataChange.torsionADiff(subIdx, 1));
                    
                    dataChangeSummary.torsionVDiffStd(subS, 1) = nanstd(dataChange.torsionVDiff(subIdx, 1));
                    dataChangeSummary.torsionADiffStd(subS, 1) = nanstd(dataChange.torsionADiff(subIdx, 1));
                    
                    dataChangeSummary.torsionVDivMean(subS, 1) = nanmean(dataChange.torsionVDiv(subIdx, 1));
                    dataChangeSummary.torsionADivMean(subS, 1) = nanmean(dataChange.torsionADiv(subIdx, 1));
                    
                    dataChangeSummary.torsionVDivStd(subS, 1) = nanstd(dataChange.torsionVDiv(subIdx, 1));
                    dataChangeSummary.torsionADivStd(subS, 1) = nanstd(dataChange.torsionADiv(subIdx, 1));
                    
                    subS = subS+1;
                end
            end
            % merge directions
            dataChange.torsionVDiffMerged = dataChange.torsionVDiff.*dataChange.afterReversalD;
            dataChange.torsionADiffMerged = dataChange.torsionADiff.*dataChange.afterReversalD;
            for conI = 1:size(conditions, 2)
                subIdx = find(dataChange.sub==t & dataChange.eye==eyeN & dataChange.rotationSpeed==conditions(conI));
                dataChangeSummary.sub(subS, 1) = t;
                dataChangeSummary.eye(subS, 1) = eyeN; % 1-left, 2-righ
                
                dataChangeSummary.rotationSpeed(subS, 1) = conditions(conI);
                dataChangeSummary.afterReversalD(subS, 1) = 0; % direction merged
                
                dataChangeSummary.perceptualErrorMean(subS, 1) = nanmean(dataChange.perceptualError(subIdx, 1));
                dataChangeSummary.perceptualErrorStd(subS, 1) = nanstd(dataChange.perceptualError(subIdx, 1));
                
                dataChangeSummary.torsionVDiffMean(subS, 1) = nanmean(dataChange.torsionVDiffMerged(subIdx, 1));
                dataChangeSummary.torsionADiffMean(subS, 1) = nanmean(dataChange.torsionADiffMerged(subIdx, 1));
                
                dataChangeSummary.torsionVDiffStd(subS, 1) = nanstd(dataChange.torsionVDiffMerged(subIdx, 1));
                dataChangeSummary.torsionADiffStd(subS, 1) = nanstd(dataChange.torsionADiffMerged(subIdx, 1));
                
                dataChangeSummary.torsionVDivMean(subS, 1) = nanmean(dataChange.torsionVDiv(subIdx, 1));
                dataChangeSummary.torsionADivMean(subS, 1) = nanmean(dataChange.torsionADiv(subIdx, 1));
                
                dataChangeSummary.torsionVDivStd(subS, 1) = nanstd(dataChange.torsionVDiv(subIdx, 1));
                dataChangeSummary.torsionADivStd(subS, 1) = nanstd(dataChange.torsionADiv(subIdx, 1));
                
                subS = subS+1;
            end
        end
    end
    
    save(['dataChangeLong_', endName1, '_', endName2, '.mat'], 'dataChange', 'dataChangeSummary')
end

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
        
        cd([analysisF '\torsionPlots'])
        % torsion velocity
        figure
        for eye = 1:size(eyeName, 2)
            subplot(1, size(eyeName, 2), eye)
            if strcmp(eyeName{eye}, 'L')
                eyeN = 1; % 1-left,
            elseif strcmp(eyeName{eye}, 'R')
                eyeN = 2; % 2-right
            end
            
            tempIDiff = find(dataChangeSummary.sub==t & dataChangeSummary.eye==eyeN & dataChangeSummary.afterReversalD==0); % clockwise
            tempIDiv = find(dataChangeSummary.sub==t & dataChangeSummary.eye==eyeN & dataChangeSummary.afterReversalD==0); % counterclockwise
            [Bdiff sortIdiff] = sort(dataChangeSummary.rotationSpeed(tempIDiff));
            [Bdiv sortIdiv] = sort(dataChangeSummary.rotationSpeed(tempIDiv));
            tempDiff = dataChangeSummary(tempIDiff, :);
            tempDiv = dataChangeSummary(tempIDiv, :);
            
            errorbar(conditions, tempDiff.torsionVDiffMean(sortIdiff, 1), tempDiff.torsionVDiffStd(sortIdiff, 1), 'LineWidth', 1.5)
            hold on
%             errorbar(conditions, tempDiv.torsionVDivMean(sortIdiv, 1), tempDiv.torsionVDivStd(sortIdiv, 1), 'LineWidth', 1.5)
            
            % original data in each condition
            tempI1 = find(d1.conData.sub==t & d1.conData.eye==eyeN & d1.conData.afterReversalD==0); % clockwise
            tempI2 = find(d2.conData.sub==t & d2.conData.eye==eyeN & d2.conData.afterReversalD==0); % counterclockwise
            [B1 sortI1] = sort(d1.conData.rotationSpeed(tempI1));
            [B2 sortI2] = sort(d2.conData.rotationSpeed(tempI2));
            tempD1 = d1.conData(tempI1, :);
            tempD2 = d2.conData(tempI2, :);
            errorbar(conditions, tempD1.torsionVelTMean(sortI1, 1), tempD1.torsionVelTStd(sortI1, 1), 'LineStyle', '--')
            errorbar(conditions, tempD2.torsionVelTMean(sortI2, 1), tempD2.torsionVelTStd(sortI2, 1), 'LineStyle', '--')
            legend({'Substract mean' 'Before reversal' 'After reversal'}, ...
                'box', 'off', 'FontSize', 10)
            xlabel('Rotation speed (deg/s)')
            ylabel('Torsion velocity (deg/s)')
            set(gca, 'FontSize', 15, 'box', 'off')
            %             xlim([0 420])
            %             ylim([-2 2])
            title([eyeName{eye}, ' eye'])
        end
        saveas(gca, ['torsionVelocityChange_' names{t} '.pdf'])
        
        % torsion angle
        figure
        for eye = 1:size(eyeName, 2)
            subplot(1, size(eyeName, 2), eye)
            if strcmp(eyeName{eye}, 'L')
                eyeN = 1; % 1-left,
            elseif strcmp(eyeName{eye}, 'R')
                eyeN = 2; % 2-right
            end
            
            tempIDiff = find(dataChangeSummary.sub==t & dataChangeSummary.eye==eyeN & dataChangeSummary.afterReversalD==0); % clockwise
            tempIDiv = find(dataChangeSummary.sub==t & dataChangeSummary.eye==eyeN & dataChangeSummary.afterReversalD==0); % counterclockwise
            [Bdiff sortIdiff] = sort(dataChangeSummary.rotationSpeed(tempIDiff));
            [Bdiv sortIdiv] = sort(dataChangeSummary.rotationSpeed(tempIDiv));
            tempDiff = dataChangeSummary(tempIDiff, :);
            tempDiv = dataChangeSummary(tempIDiv, :);
            
            errorbar(conditions, tempDiff.torsionADiffMean(sortIdiff, 1), tempDiff.torsionADiffStd(sortIdiff, 1), 'LineWidth', 1.5)
            hold on
%             errorbar(conditions, tempDiv.torsionADivMean(sortIdiv, 1), tempDiv.torsionADivStd(sortIdiv, 1), 'LineWidth', 1.5)
            
            % original data in each condition
            tempI1 = find(d1.conData.sub==t & d1.conData.eye==eyeN & d1.conData.afterReversalD==0); % clockwise
            tempI2 = find(d2.conData.sub==t & d2.conData.eye==eyeN & d2.conData.afterReversalD==0); % counterclockwise
            [B1 sortI1] = sort(d1.conData.rotationSpeed(tempI1));
            [B2 sortI2] = sort(d2.conData.rotationSpeed(tempI2));
            tempD1 = d1.conData(tempI1, :);
            tempD2 = d2.conData(tempI2, :);
            errorbar(conditions, tempD1.torsionAngleMean(sortI1, 1), tempD1.torsionAngleStd(sortI1, 1), 'LineStyle', '--')
            errorbar(conditions, tempD2.torsionAngleMean(sortI2, 1), tempD2.torsionAngleStd(sortI2, 1), 'LineStyle', '--')
            legend({'Substract mean' 'Before reversal' 'After reversal'}, ...
                'box', 'off', 'FontSize', 10)
            xlabel('Rotation speed (deg/s)')
            ylabel('Torsion angle (deg)')
            set(gca, 'FontSize', 15, 'box', 'off')
            %             xlim([0 420])
            ylim([-2 3])
            title([eyeName{eye}, ' eye'])
        end
        saveas(gca, ['torsionAngleChange_' names{t} '.pdf'])
        
        %         close all
    end
end

% averaged plots--adapt later
if averagedPlots==1
    cd([analysisF '\summaryPlots'])
    % torsionV/perceptual error/torsionVGain vs. speed, scatter
    markerC = [77 255 202; 70 95 232; 232 123 70; 255 231 108; 255 90 255; 100 178 42]/255;
    
    % torsionVchange vs speed
    figure
    for eye = 1:size(eyeName, 2)
        subplot(1, size(eyeName, 2), eye);
        if strcmp(eyeName{eye}, 'L')
            eyeN = 1; % 1-left,
        elseif strcmp(eyeName{eye}, 'R')
            eyeN = 2; % 2-right
        end
        for t = 1:size(names, 2)
            tempI = find(dataChangeSummary.sub==t & dataChangeSummary.eye==eyeN & dataChangeSummary.afterReversalD==0); % merged initial direction
            errorbar(dataChangeSummary.rotationSpeed(tempI), dataChangeSummary.torsionVDiffMean(tempI), ...
                dataChangeSummary.torsionVDiffStd(tempI), 'LineStyle', 'None', ...
                'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
            hold on
        end
        legend(names, 'box', 'off', 'Location', 'SouthWest')
        xlabel('Rotation speed(deg/s)')
        ylabel('Torsional velocity change (deg/s)')
        xlim([0 420])
        %         ylim([-2 2])
        set(gca, 'FontSize', 15, 'box', 'off')
        title([eyeName{eye}, ' eye'])
    end
    saveas(gca, ['speedTorsionVelocityChange_', endName1, '_', endName2, '.pdf'])
    % torsion angle change
    figure
    for eye = 1:size(eyeName, 2)
        subplot(1, size(eyeName, 2), eye);
        if strcmp(eyeName{eye}, 'L')
            eyeN = 1; % 1-left,
        elseif strcmp(eyeName{eye}, 'R')
            eyeN = 2; % 2-right
        end
        for t = 1:size(names, 2)
            tempI = find(dataChangeSummary.sub==t & dataChangeSummary.eye==eyeN & dataChangeSummary.afterReversalD==0); % merged initial direction
            errorbar(dataChangeSummary.rotationSpeed(tempI), dataChangeSummary.torsionADiffMean(tempI), ...
                dataChangeSummary.torsionADiffStd(tempI), 'LineStyle', 'None', ...
                'Marker', 's', 'MarkerSize', 12, 'MarkerFaceColor', 'auto');%markerC(t, :), 'MarkerEdgeColor', 'none')
            hold on
        end
        %                 legend(names, 'box', 'off', 'Location', 'SouthWest')
        xlabel('Rotation speed(deg/s)')
        ylabel('Torsional angle change (deg/s)')
        xlim([0 420])
        %         ylim([-2 2])
        set(gca, 'FontSize', 15, 'box', 'off')
        title([eyeName{eye}, ' eye'])
    end
    saveas(gca, ['speedTorsionAngleChange_', endName1, '_', endName2, '.pdf'])
    
    % scatter torsion vs. perceptual error
    % velocity change
    figure
    for eye = 1:size(eyeName, 2)
        subplot(1, size(eyeName, 2), eye)
        if strcmp(eyeName{eye}, 'L')
            eyeN = 1; % 1-left,
        elseif strcmp(eyeName{eye}, 'R')
            eyeN = 2; % 2-right
        end
        for t = 1:size(names, 2)
            tempI = find(dataChangeSummary.sub==t & dataChangeSummary.eye==eyeN & dataChangeSummary.afterReversalD==0);
            if ~isempty(tempI)
                scatter(dataChangeSummary.torsionVDiffMean(tempI, 1), dataChangeSummary.perceptualErrorMean(tempI, 1), 'LineWidth', 2)%,...
%                     'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
                hold on
            end
            xlabel('Torsional velocity change (deg/s)')
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
    saveas(gca, ['torsionVelocityChangeVSpercept_', endName1, '_', endName2, '.pdf'])
    
    % angle change
    figure
    for eye = 1:size(eyeName, 2)
        subplot(1, size(eyeName, 2), eye)
        if strcmp(eyeName{eye}, 'L')
            eyeN = 1; % 1-left,
        elseif strcmp(eyeName{eye}, 'R')
            eyeN = 2; % 2-right
        end
        for t = 1:size(names, 2)
            tempI = find(dataChangeSummary.sub==t & dataChangeSummary.eye==eyeN & dataChangeSummary.afterReversalD==0);
            if ~isempty(tempI)
                scatter(dataChangeSummary.torsionADiffMean(tempI, 1), dataChangeSummary.perceptualErrorMean(tempI, 1), 'LineWidth', 2)%,...
%                     'MarkerEdgeColor', markerC(t, :), 'MarkerFaceColor', 'none')
                hold on
            end
            xlabel('Torsional angle change (deg/s)')
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
    saveas(gca, ['torsionAngleChangeVSpercept_', endName1, '_', endName2, '.pdf'])
    
end
