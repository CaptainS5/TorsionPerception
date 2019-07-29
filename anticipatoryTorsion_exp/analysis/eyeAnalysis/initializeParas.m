% use eyeTrialData to do analysis, initialize parameters

clear all; close all; clc

names = {'p1' 'p3' 'p4' 'p5' 'p7'};
sampleRate = 200;

trialTypeCons = [0 1]; % 0=baseline, no rotation; 1=experimental trials, with rotation
trialTypeNames = {'no rotation' 'with rotation'};
transDirCons = [-1 1]; % yoked with rotational direction; -1= left, ccw; 1=right, cw
dirConNames = {'leftCCW' 'rightCW'};

analysisFolder = pwd;
cd ..
cd('pursuitPlots')
pursuitFolder = pwd;
cd ..
cd('torsionPlots')
torsionFolder = pwd;
% cd ..
% cd('saccadePlots')
% saccadeFolder = pwd;
% cd ..
% cd('perceptPlots')
% perceptFolder = pwd;
cd ..
cd('velocityTraces')
velTraceFolder = pwd;
% cd ..
% cd('correlationPlots')
% correlationFolder = pwd;
% cd ..
% cd('mausAnalysis')
% mausFolder = pwd;
% cd ..
% cd('slidingWindows')
% slidingWFolder = pwd;
cd(analysisFolder)
load(['eyeTrialDataAll_R.mat']);
load(['dataLongAll.mat']);

% for plotting
colorPlot = [232 71 12; 12 76 150; 2 255 44; 140 0 255; 255 212 13]/255;
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