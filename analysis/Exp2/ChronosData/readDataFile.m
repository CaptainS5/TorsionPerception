function [data] = readDataFile(selectedDataFile, experimentFolder)
% adapted by Xiuyun Wu 08/21/2018
% to deal with repetitive frames when there are lost frames...
% just delete the repetitive ones--first find out which frames, then
% delete the first appearance of the repetitive ones

% for debugging
% experimentFolder = ['C:\Users\CaptainS5\Documents\PhD@UBC\Lab\1st year\TorsionPerception\data\FScontrol\chronos\'];%[folder{:} '\' subject '\chronos']; % for debug
% selectedDataFile = ['session_02_L.dat'];
%% Part1: read number of segments
%Open Data file
path = fullfile(experimentFolder,selectedDataFile);
fid = fopen(path);

%skip 6 lines
textscan(fid, '%*[^\n]', 6);

%read investigated eye
data.eye = textscan(fid, '%*s%*s%*s%*s %d %*[^\n]', 1);
data.eye = data.eye{1} - 1; %0: rightEye 1:leftEye (in Chronos: right(1), left(2))

%skip 1 line
textscan(fid, '%*[^\n]', 1);

numberOfSegments = textscan(fid, '%*s%*s%*s%*s %d %*[^\n]', 1);
numberOfSegments = numberOfSegments{1};

%skip 4 lines
textscan(fid, '%*[^\n]', 4);

% number of lost frames
numberOfLostFrames = textscan(fid, '%*s%*s%*s%*s%*s %d %*[^\n]', 1);
numberOfLostFrames = numberOfLostFrames{1};

% skip 6 lines
textscan(fid, '%*[^\n]', 6);

%% Part2: read number of recorded and not recorded blocks
triggeredFrames = textscan(fid, '%*s%*s%*s%*s%*s%*s %d %*[^\n]', 1);
triggeredFrames = triggeredFrames{1};
nonTriggeredFrames = textscan(fid, '%*s%*s%*s%*s%*s%*s%*s %d %*[^\n]', 1);
nonTriggeredFrames = nonTriggeredFrames{1};

recordedBlocks = textscan(fid, '%*s%*s%*s%*s%*s %d %*[^\n]', 1);
recordedBlocks = recordedBlocks{1};  
notRecordedBlocks = textscan(fid, '%*s%*s%*s%*s%*s %d %*[^\n]', 1);
notRecordedBlocks = notRecordedBlocks{1};

%skip line ("--blocks recorded--" and calibration block line)
textscan(fid, '%*[^\n]', 1); % original was 2--calibration is in separate file!

%% Part3: read start frames and end frames

data.startFrames = [];
data.endFrames = [];

for i = 1:recordedBlocks
    frame = textscan(fid, '%*s%*s%*s%*s %d %*s %*s %d %*[^\n]', 1);
    
    data.startFrames(i) = frame{1};
    data.endFrames(i) = frame{2};
end

% number of total frames
% if numberOfLostFrames>0
data.totalFrames = data.endFrames(end)+1;
% else
%     data.totalFrames = triggeredFrames + nonTriggeredFrames;
% end

% %skip line ("--blocks not recorded--")
textscan(fid, '%*[^\n]', 1);

% skip lines of not recorded blocks
textscan(fid, '%*[^\n]', notRecordedBlocks);

%% Part4: read data line by line
% skip 2 lines
textscan(fid, '%*[^\n]', 2); 

% setup format for lines of data
format = '%d %f %f %f';

for i = 1:numberOfSegments
    format = [format ' %f %f']; %add two floats for each segment for torsion value and torsion correlation
end

% read every single data frame
frameData = textscan(fid, format);%, data.totalFrames);
if size(frameData{1}, 1)>data.totalFrames % delete repetitive frames
    frameCount = 0;
    currentF = 1;
    while currentF <= size(frameData{1}, 1)
        if frameData{1}(currentF)==frameCount
            frameCount = frameCount+1;            
        elseif frameData{1}(currentF)<frameCount
            repeatStart = frameData{1}(currentF);
            for tt = 1:size(frameData, 2)
                frameData{tt}(repeatStart+1:currentF-1) = [];
            end
            currentF = repeatStart+1;
            frameCount = currentF;
        end
        currentF = currentF+1;
    end
end

%
%
data.segments = ones(data.totalFrames,numberOfSegments);
data.segmentsCorrelation = ones(data.totalFrames,numberOfSegments);

% copy all the segment data (torsion and torsion correlation)
for i = 1:numberOfSegments
    temp = frameData{i*2+3}; 
    data.segments(:,i) = temp; %negative for old eperiments before 2015
    temp = frameData{i*2+4}; 
    data.segmentsCorrelation(:,i) = temp;
end

%% Part5: calculate an correlation-weighted average of all segments


% use a correlation-threshold to determine which segements should be
% considered in the sum
correlationThreshold = 0.7;

cutoff = data.segmentsCorrelation>correlationThreshold;
correlation = data.segmentsCorrelation.*cutoff;

torsionWeighted = data.segments.*correlation;

correlationSum = nansum(correlation,2);
torsionSum = nansum(torsionWeighted,2);

torsionalData = (torsionSum./correlationSum);  
%% Part6: replace horizontal and vertical extreme values
% These appear when pupil cannot be found (-999) or frame is not recorded
% (-777)

data.T = torsionalData;
%replace NaNs by 0 (TODO: change that in socscalexy to allow for NaNs)
data.lostTframes = isnan(data.T);
data.T(data.lostTframes) = 0;

horizontalData = frameData{2};
data.lostXframes =  horizontalData<-100;
horizontalData(data.lostXframes) = 0;
data.X = horizontalData; %negative for old eperiments before 2015

verticalData = frameData{3};
data.lostYframes = verticalData<-100;
verticalData(data.lostYframes) = 0;
data.Y = verticalData;

fclose('all');
% end