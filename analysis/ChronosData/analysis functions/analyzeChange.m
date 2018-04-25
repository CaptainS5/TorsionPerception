% function analyzeChange
% analyze change of torsion before vs. after to see the correlation
% Xiuyun Wu, 04/23/2018
clear all; close all; clc

names = {'XWc' 'PHc' 'ARc' 'SMc' 'JFc' 'MSc'};
conditions0 = [40 80 120 160 200];
conditions1 = [20 40 80 140 200];
conditions2 = [25 50 100 150 200];
conditions3 = [25 50 100 200 400];
% names = {'JL' 'RD' 'KK'};
% conditions = [25 50 100 200 400];
individualPlots = 1; % whether plot individual data
averagedPlots = 0;
direction = [-1 1]; % initial direction; in the plot shows the direction after reversal
trialPerCon = 60; % for each flash onset, all directions together though...
eyeName = {'L' 'R'};
endName1 = '120msToReversal'; % from beginning of stimulus to reversal
% endName = '120msAroundReversal';
endName2 = '120msToEnd'; % 120ms after reversal to end of display
d1 = load(['dataLong', endName1, '.mat']);
d2 = load(['dataLong', endName2, '.mat']);

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
%         % torsion velocity
%         figure
%         for eye = 1:2
%             subplot(1, 2, eye)
%             tempI1 = find(d1.conData.sub==t & d1.conData.eye==eye & d1.conData.afterReversalD==0); % clockwise
%             tempI2 = find(d2.conData.sub==t & d2.conData.eye==eye & d2.conData.afterReversalD==0); % counterclockwise
%             [B1 sortI1] = sort(d1.conData.rotationSpeed(tempI1));
%             [B2 sortI2] = sort(d2.conData.rotationSpeed(tempI2));
%             tempD1 = d1.conData(tempI1, :);
%             tempD2 = d2.conData(tempI2, :);
%             
%             divMean = -tempD2.torsionVelTMean(sortI1, 1)./tempD1.torsionVelTMean(sortI2, 1);
%             diffMean = tempD2.torsionVelTMean(sortI1, 1)-tempD1.torsionVelTMean(sortI2, 1);
%             
%             plot(conditions, diffMean, 'LineWidth', 1.5)
%             hold on
%             plot(conditions, divMean, 'LineWidth', 1.5)
%             errorbar(conditions, tempD1.torsionVelTMean(sortI1, 1), tempD1.torsionVelTStd(sortI1, 1), 'LineStyle', '--')
%             errorbar(conditions, tempD2.torsionVelTMean(sortI2, 1), tempD2.torsionVelTStd(sortI2, 1), 'LineStyle', '--')
%             legend({'Substract mean' 'Divide mean' 'Before reversal' 'After reversal'}, ...
%                 'box', 'off', 'FontSize', 10)
%             xlabel('Rotation speed (deg/s)')
%             ylabel('Torsion velocity (deg/s)')
%             set(gca, 'FontSize', 15, 'box', 'off')
%             %             xlim([0 420])
% %             ylim([-2 2])
%             title([eyeName{eye}, ' eye'])
%         end
%         saveas(gca, ['torsionVelocityChange_' names{t} '.pdf'])
        
        % torsion angle
        figure
        for eye = 1:2
            subplot(1, 2, eye)
            tempI1 = find(d1.conData.sub==t & d1.conData.eye==eye & d1.conData.afterReversalD==0); % clockwise
            tempI2 = find(d2.conData.sub==t & d2.conData.eye==eye & d2.conData.afterReversalD==0); % counterclockwise
            [B1 sortI1] = sort(d1.conData.rotationSpeed(tempI1));
            [B2 sortI2] = sort(d2.conData.rotationSpeed(tempI2));
            tempD1 = d1.conData(tempI1, :);
            tempD2 = d2.conData(tempI2, :);
            
            divMean = -tempD2.torsionAngleMean(sortI1, 1)./tempD1.torsionAngleMean(sortI2, 1);
            diffMean = tempD2.torsionAngleMean(sortI1, 1)-tempD1.torsionAngleMean(sortI2, 1);
            
            plot(conditions, diffMean, 'LineWidth', 1.5)
            hold on
            plot(conditions, divMean, 'LineWidth', 1.5)
            errorbar(conditions, tempD1.torsionAngleMean(sortI1, 1), tempD1.torsionAngleStd(sortI1, 1), 'LineStyle', '--')
            errorbar(conditions, tempD2.torsionAngleMean(sortI2, 1), tempD2.torsionAngleStd(sortI2, 1), 'LineStyle', '--')
            legend({'Substract mean' 'Divide mean' 'Before reversal' 'After reversal'}, ...
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

% averaged plots
if averagedPlots==1
    cd([analysisF '\summaryPlots'])
    % torsionV/perceptual error/torsionVGain vs. speed, scatter
    markerC = [77 255 202; 70 95 232; 232 123 70; 255 231 108; 255 90 255; 100 178 42]/255;

end
