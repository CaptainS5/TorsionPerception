% function averagePSE
% Get the mean PSE of the group, save and plot
% the baseline is added to each participant

% 11/29/2017, Xiuyun Wu

% some (maybe) useful codes from the past...
% arr = find(all(tabdata{:, 3:6}==cont(:,1:4),2));
% M1 = accumarray(subs, LinTh, [], @mean); % mean for linear threshold contrast
clear all; close all; clc
folder = pwd;

% basic setting
names = {'XWp1' 'JFp2' 'RSp1' 'NIp2'};
merged = 1; % whether initial direction is merged; 1=merged
roundN = -4; % keep how many numbers after the point when rounding and matching...; -1 for the initial pilot
trialPerCon = 24; % trials per condition in the experiment
threshold = 0.5; % for PSE
fontSize = 15; % for plot
cons = [0.35 0.7 1.05 1.4 1.75]; % x axis of the plot; flash onset (s)

% for fitting using Palamedes
PF = @PAL_Logistic;  %Alternatives: PAL_Gumbel, PAL_Weibull,
%PAL_Quick, PAL_logQuick,
%PAL_CumulativeNormal, PAL_HyperbolicSecant
%Threshold and Slope are free parameters, guess and lapse rate are fixed
paramsFree = [1 1 0 1];  %1: free parameter, 0: fixed parameter
%Parameter grid defining parameter space through which to perform a
%brute-force search for values to be used as initial guesses in iterative
%parameter search.
searchGrid.alpha = -3.5:0.01:1; % threshold
searchGrid.beta = -20:0.1:0; % slope
searchGrid.gamma = 0;  % lower asymptote, guess rate, for 2AFC it's 0.5?...
searchGrid.lambda = 0:0.01:0.1;  % upper asymptote (1-lambda), lapse rate, the probability of an incorrect response...

if merged==1
    conditionNames = {'flashOnset', 'flashDisplaceLeftMerged'}; % which conditions are different
    conditionNamesBase = {'flashOnset', 'flashDisplaceLeft'}; % which conditions are different
    mergeName = 'merged';
else
    conditionNames = {'flashOnset', 'flashDisplaceLeft', 'initialDirection'}; % which conditions are different
    conditionNamesBase = conditionNames;
    mergeName = 'notMerged';
end

for ii = 1:size(names, 2)
    load(['dataPMFbase_', names{ii}]) % baseline
    load(['dataPMF', mergeName, '_', names{ii}]) % experiment
    
    if merged==0
        PSEraw = PSE;
        PSE = [];
        PSE(1, 1:size(cons, 2)) = PSEraw(:, 1)';
        PSE(1, size(cons, 2)+1:2*size(cons, 2)) = PSEraw(:, 2)';
    end
%         PSE = PSE - PSEbase;
    
    if ii==1
        PSEall = PSE;
        PSEbaseAll = PSEbase;
    else
        PSEall = [PSE; PSEall];
        PSEbaseAll = [PSEbaseAll; PSEbase];
    end
end

PSEmean = mean(PSEall);
PSEstd = std(PSEall);
PSEbaseMean = mean(PSEbaseAll);
PSEbaseStd = std(PSEbaseAll);

% plot
figure
if merged==1
    errorbar(cons, PSEmean(:), PSEstd, '-r')
    hold on
    plot(cons, repmat(PSEbaseMean, size(cons, 2)), '--k')
    legend({'Clockwise (merged)', 'baseline'}, 'box', 'off', 'Location', 'northwest')
%     legend({'Clockwise (merged)'}, 'box', 'off', 'Location', 'northwest')
else
    errorbar(cons, PSEmean(1, 1:size(cons, 2)), PSEstd(1, 1:size(cons, 2)), '-b')
    hold on
    errorbar(cons, PSEmean(1, size(cons, 2)+1:end), PSEstd(1, 1:size(cons, 2)), '-r')
    plot(cons, repmat(PSEbaseMean, size(cons, 2)), '--k')
    legend({'Clockwise', 'Counterclockwise', 'baseline'}, 'box', 'off', 'Location', 'northwest')
%     legend({'Clockwise', 'Counterclockwise'}, 'box', 'off', 'Location', 'northwest')
end
% title('Minus baseline')
%     ylim([-0.3 0.5])
xlabel('Flash Onset (s)')
ylabel('Point of subjective equality, left-right')
set(gca, 'FontSize', fontSize)

saveas(gca, ['meanPSE4_withBase', mergeName, '.pdf'])
