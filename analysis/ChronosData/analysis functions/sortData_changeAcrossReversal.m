% relative changes between before and after
% Xiuyun Wu, 04/17/2018
clear all; close all; clc

names = {'XWc' 'PHc' 'ARc' 'SMc' 'JFc' 'MSc'};
cd ..
analysisF = pwd;
folder = {'C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\Torsion&perception\data'};
conditions0 = [40 80 120 160 200];
conditions1 = [20 40 80 140 200];
conditions2 = [25 50 100 150 200];
conditions3 = [25 50 100 200 400];
direction = [-1 1]; % initial direction; in the plot shows the direction after reversal
trialPerCon = 60; % for each flash onset, all directions together though...
eyeName = {'L' 'R'};
endName = '300msToReversal';
% endName = '120msAroundReversal';
% endName = '120msToEnd';


