% generate csv files for analysis in R
% combine perceptual and torsional data for valid trials
% only experiment trials, baseline trials see the previos analysis of
% 'dataBaseLongbaseline.mat', 'trialDataBaseAllExp1.csv', and 'conDataBaseAllExp1.csv'
% ...maybe later if you need= = now I'll just use the old analysis for
% the sake of time...
clear all; close all; clc

names = {'JL' 'RD' 'MP' 'CB' 'KT' 'MS' 'IC' 'SZ' 'NY' 'SD' 'JZ' 'BK' 'RR' 'TM' 'LK'};
conditions = [25 50 100 200 400];
sampleRate = 200; 

load('eyeDataAll.mat')