function setParameters
% define all paramters used in the exp

% All display lengths are in degree of visual angle (dva), time in s, 
% colour range 0-255, physical distances in cm

global prm

% physical parameters, in cm
prm.screen.viewDistance = 30; % 57.29 cm corresponds to 1cm on screen as 1 dva
prm.screen.monitorWidth = 29.4; % horizontal dimension of viewable screen (cm)
% 29.4 for the laptop; 36.8 for the lab computer in X527
prm.screen.monitorHeight = 29.4/4*9;
% ? for the laptop; 27.3 for the lab computer in X527

% display settings
% prm.backgroundColour = []; % dark background, currently set in openScreen

% fixation
prm.fixation.ringRadius = 0.5; % in dva
prm.fixation.dotRadius = 0.15; % in dva
prm.fixation.colour = []; % fixation colour, currently set in generateRotationGrating.m
prm.fixation.durationBase = 0.6;
prm.fixation.durationJitter = 0.2;
% fixation duration before each block is base+rand*jitter

% rotating grating stimulus
prm.grating.outerRadius = 10; % [8.9, 23.6, 47.2]/2; % in degree of visual angle (dva)
prm.grating.innerRadius = 0; % no fixation
% prm.grating.innerRadius = 2.05/2; % in dva
% prm.grating.outerRadius = [7, 7, 7]; % in degree of visual angle (dva)
% prm.grating.innerRadius = 1/2; % in dva
prm.grating.freq = 2; % frequency of the stimulus
prm.grating.contrast = 0.25; % measured to be about 0.985 (max-min)/(max+min); 
% 0.99 corresponds to actual 0.9876, quite stable...
% and even 0.989 measures actual around 0.979, so...
prm.grating.averageLum = 0.5; %1-prm.grating.contrast/2; % average luminance of the grating

% flash
% bar in FDE
prm.flash.width = 0.85;
prm.flash.length = 6;
% circle in flash grab
prm.flash.radius = 2.5/2;

prm.flash.axis = 0; % 0-horizontal, 1-vertical--this is the firt location
% if want reversal vertically, use 0
prm.flash.eccentricity = 0; % the inner edge of the flash to the outer edge of the rotating stimulus, 1.3-58
prm.flash.duration = 0.047;
% prm.flash.onsetInterval = [0.35 0.7 1.05 1.4 1.75]; % no reversal, motion duration before flash
prm.flash.onsetInterval = [0];
% prm.flash.onsetInterval = [-0.6 -0.3 0 0.3 0.6]; % time of flash relative to the reversal, within 1 sec
prm.flash.displacement = [0]/60;
% prm.flash.displacement = [-30 -20 -10 0 10 20 30]/60; % possible displacement of the left flash compared to the right;
% in the experiment randomly the left/right flash will be moved, while the
% other remains horizontal
prm.flash.colour = 255; % 88 measured about 34.5 cd/m^2

% rotation control
prm.rotation.freq = 135; % in degrees out of a cycle (360 in total)
prm.rotation.baseDuration = 0.67; % the baseline of rotation in one interval, s
% prm.rotation.randDuration = 0.5; % rotation time = base+-rand

prm.recording.stopDuration = 0.2; % stop recording after a certain duration after flash onset

% block conditions
prm.ITI = 0.2; % inter-trial interval
prm.blockN = 1; % total number of blocks
prm.conditionN = length(prm.grating.outerRadius)*length(prm.flash.onsetInterval)*length(prm.flash.displacement); % total number of combinations of conditions
% conditions differ in: radial stimulus size; flash onset interval;
% flash displacement
prm.trialPerCondition = 24; % trial number per condition
prm.trialPerBlock = prm.trialPerCondition*prm.conditionN/prm.blockN;

end