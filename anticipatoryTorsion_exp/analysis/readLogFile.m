function [header, logData] = readLogFile(block, selectedLogFile, experimentFolder)
%% readLogFile
%   This function reads log files which are in a predefined format.
%   The logfiles are produced by the function runExperiment.m (in the
%   experiment folder)

%% inputs
%   block:              number of current block, e.g., 3
%   selectedLogFile:    name of the log file, e.g., 1_AB_2014_January_14.txt
%   experimentFolder:   subfolder of TorsionExperiment\Data\DataFiles,
%                       e.g., Exp10

%% outputs
%   header:             header information from the log file
%   logData:            data about trial parameters (speed, direction,...)


%% Part1
% Determine the number of trials per block.
% Thus we know where one block ends and the next one starts.

path = fullfile(experimentFolder,selectedLogFile); % added Exp7 on July 2, MS / deleted again on July 4th. Need to find better solution

fid = fopen(path);

% skip 5 lines
textscan(fid, '%*[^\n]', 5);

blocksAndTrials = textscan(fid, '%d %d %*[^\n]');
blocks = blocksAndTrials{1};
trials = blocksAndTrials{2};
trialsDiff = diff(trials);
trialsDiff = [trialsDiff; -1]; %this is just a helper 
blockNumbers = blocks(trialsDiff<0);
blockSizes = trials(trialsDiff<0);
currentBlockSize = blockSizes(blockNumbers==block);

fclose(fid);

%% Part2
% Read data from log files and store it in the following two structures
% - header: contains overhead details
% - logData: contains all the parameters and subject's decision

fid = fopen(path);

header.experimentID = textscan(fid, '%*s %d %*[^\n]',1);
header.experimentID = header.experimentID{1};
header.subjectID = textscan(fid, '%*s %d %*[^\n]',1);
header.subjectID = header.subjectID{1};
header.experiment = textscan(fid, '%*s %d %*[^\n]',1);
header.experiment = header.experiment{1};
header.trialsPerBlock = currentBlockSize;

%skip 2 lines
textscan(fid, '%*[^\n]', 2);



skipLines = sum(blockSizes(blockNumbers<block)); %skip lines of previous blocks
textscan(fid, '%*[^\n]', skipLines);

allData = textscan(fid, '%d %d %d %d %f %d %f %f %f %f %f %f %d %f %*[^\n]',currentBlockSize);

logData.fileName = selectedLogFile;
logData.block = block;
logData.trial = allData{2};
logData.translationalDirection = allData{3};
logData.rotationalDirection = allData{4};
logData.randomSpeed = allData{5};
logData.decision = allData{6};
logData.circleDiameter = allData{7};
logData.translationalSpeed = allData{8};
logData.rotationalSpeed = allData{9};
logData.duration = allData{10};
logData.multiplier = allData{11};
logData.dotsDiameter = allData{12};
logData.dotsNumber = allData{13};
logData.slopeAngle = allData{14};

rightNatural = ~logData.translationalDirection & ~logData.rotationalDirection;
leftNatural  = logData.translationalDirection & logData.rotationalDirection;

logData.natural = rightNatural | leftNatural;

decisionFaster = strcmp(logData.decision,'faster');
decisionSlower = strcmp(logData.decision,'slower');

isFaster = logData.randomSpeed > 0;
isSlower = ismember(logData.randomSpeed,-20:-1);

isFasterCorrect = isFaster & decisionFaster;
isSlowerCorrect = isSlower & decisionSlower;

logData.decisionCorrect = isFasterCorrect | isSlowerCorrect;

fclose('all');

end