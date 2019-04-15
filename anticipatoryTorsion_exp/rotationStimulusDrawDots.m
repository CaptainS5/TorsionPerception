function [randomSpeed, translationalDirection, rotationalDirection] = rotationStimulusDrawDots(...
    display,...
    parameter,...
    trialConditions)

global trigger;

%Setup conditions
conditions.speed = trialConditions(1);
% conditions.rotationalDirection = trialConditions(2);
conditions.translationalDirection = trialConditions(3);
%Determine whether stimulus starts moving from right of from left
if(conditions.translationalDirection==2)
    moveToRight = true; % rightward, CW
    translationalDirection = 1;
    conditions.rotationalDirection = 1;
else
    moveToRight = false; % leftward, CCW
    translationalDirection = -1;
    conditions.rotationalDirection = -1;
end
if trialConditions(2)==2
    conditions.rotationalDirection = 0; % no rotation
end

%Setup display properties
display.windowPointer = display.windowPointer; %returns a hold for the window
display.dimensions = display.size; %format [left top right bottom]
display.widthInPixel = display.dimensions(3) - display.dimensions(1); %latter should be 0
display.heightInPixel = display.dimensions(4) - display.dimensions(2); %latter should be 0
display.horizontalMiddle = display.widthInPixel/2;
display.verticalMiddle = display.heightInPixel/2;
display.screenWidthInCm = display.screenWidth; %set via GUI
display.screenHeightInCm = display.screenHeight; %set via GUI
display.distanceToScreen = display.screenDistance; %set via GUI
%Now do the calculation from degree to pixel
display.screenWidthInDegree = 360/pi * atan(display.screenWidthInCm/(2*display.distanceToScreen));
display.screenHeightInDegree = 360/pi * atan(display.screenHeightInCm/(2*display.distanceToScreen));
display.pixelRatioWidthPerHeight = (display.screenWidthInCm/display.widthInPixel)/(display.screenHeightInCm/display.heightInPixel);
display.horizontalPixelPerDegree = display.widthInPixel / display.screenWidthInDegree;
display.verticalPixelPerDegree = display.heightInPixel / display.screenHeightInDegree;

% comment in for testing in upper or lower visual field
%display.verticalMiddle = display.verticalMiddle + 6 * display.verticalPixelPerDegree;

%Calculate frame rate
display.frameRate = 1/Screen('GetFlipInterval',display.windowPointer); %in Hz (frames per second: fps)



%Setup colors
black = BlackIndex(display.windowPointer);
white = WhiteIndex(display.windowPointer);
red = [255 0 0];
grey = [150 150 150];

%Define stimulus characteristics
%%Circle settings
circle.diameter = parameter.circleDiameter; %set via GUI %degrees
circle.horizontalDiameterInPixel = parameter.circleDiameter * display.horizontalPixelPerDegree;
circle.verticalDiameterInPixel = parameter.circleDiameter * display.verticalPixelPerDegree;
circle.translationalSpeed = parameter.translationalSpeed; %set via GUI %degrees/second
% circle.translationalSpeedInPixel = ;
circle.horizontalSpeed = circle.translationalSpeed * cos(parameter.slopeAngle/180*pi);
circle.horizontalSpeedInPixel = circle.horizontalSpeed * display.horizontalPixelPerDegree; %pixel/second
circle.verticalSpeed = circle.translationalSpeed * sin(parameter.slopeAngle/180*pi);
circle.verticalSpeedInPixel = circle.verticalSpeed * display.verticalPixelPerDegree; %pixel/second
circle.rotationSpeed = parameter.rotationalSpeed; %to be set via GUI %degrees/second
circle.startYInPixel = display.verticalMiddle + parameter.fixationYDisToCenter * display.verticalPixelPerDegree;

%Fixation and starting point--starting dot center
% leftStartingPosition = [display.horizontalMiddle-trial.distance/2 display.verticalMiddle];
% rightStartingPosition = [display.horizontalMiddle+trial.distance/2 display.verticalMiddle];
leftStartingPosition = [display.horizontalMiddle circle.startYInPixel];
rightStartingPosition = [display.horizontalMiddle circle.startYInPixel];

%%Slope settings
%
% positions are relative to the screen center, up and left are minus 
% [x1start, x1end, x2strat, x2end;y1start, y1end, y2strat, y2end]
% x1 is the left up to right bottom line
crossDisToDotCenterY = (circle.diameter/2)/cos(parameter.slopeAngle/180*pi) * display.verticalPixelPerDegree; % in pixels
crossToCenterY = circle.startYInPixel+crossDisToDotCenterY-display.verticalMiddle; % in pixels, position to center

upperLength = (circle.diameter/2) + (circle.diameter/2)*tan(parameter.slopeAngle/180*pi); % in degs, upper than the cross point
upperDisX = upperLength * cos(parameter.slopeAngle/180*pi) * display.horizontalPixelPerDegree;
upperDisY = upperLength * sin(parameter.slopeAngle/180*pi) * display.verticalPixelPerDegree - crossToCenterY;
% start point, [x y] in pixels, distance to center
lowerLength = parameter.slopeLength-upperLength; % in degs, lower than the cross point
lowerDisX = lowerLength * cos(parameter.slopeAngle/180*pi) * display.horizontalPixelPerDegree;
lowerDisY = lowerLength * sin(parameter.slopeAngle/180*pi) * display.verticalPixelPerDegree + crossToCenterY;
% end point, [x y] in pixels, distance to center

slope.fullPositionInPixel = [-upperDisX lowerDisX upperDisX -lowerDisX; ...
    -upperDisY lowerDisY -upperDisY lowerDisY];% full position--full lines of the slope 

% cue position--one "blockage" taken out to indicate moving direction
if moveToRight
    slope.cuePositionInPixel = [-upperDisX lowerDisX 0 -lowerDisX; ...
    -upperDisY lowerDisY crossToCenterY lowerDisY];
else
    slope.cuePositionInPixel = [0 lowerDisX upperDisX -lowerDisX; ...
    crossToCenterY lowerDisY -upperDisY lowerDisY];
end

%Select a rotation speed
speedLevel = parameter.speedLevels*parameter.multiplier; %in percent
speedLevel(length(speedLevel)+1) = -100;
randomSpeed = speedLevel(conditions.speed);
circle.rotationSpeed = circle.rotationSpeed * (1+randomSpeed/100);
% rotationalDirection = 1; % CW
% if(conditions.rotationalDirection == -1) % CCW
%     circle.rotationSpeed = circle.rotationSpeed * (-1);
%     rotationalDirection = -1;
% end
rotationalDirection = conditions.rotationalDirection;
circle.rotationSpeed = circle.rotationSpeed * rotationalDirection;

circle.rotationSpeedPerFrame = circle.rotationSpeed/display.frameRate;

%%Calculate the duration of how long it takes the circle to move from the
%%starting position to the ending position
trial.duration = parameter.duration/1000;
% trial.distance = circle.translationalSpeedInPixel * trial.duration;

%Dots settings
dots.number = parameter.dotsNumber; %set via GUI
dots.color = white;
dots.diameter = parameter.dotsDiameter * display.horizontalPixelPerDegree; %in pixel
dots.center = [0 0]; %will be set later
dots.lifetime = parameter.lifetime/1000;
%Limited dot lifetime
dots.showTime = floor(rand(1,dots.number)*seconds2frames(display.frameRate, dots.lifetime)); %in frames

%Postion dots in a circular aperture
dots.distanceToCenter = circle.diameter/2 * sqrt((rand(dots.number,1)))*display.horizontalPixelPerDegree; %distance of dots from center
dots.distanceToCenter = max(dots.distanceToCenter-dots.diameter/2, 0); %make sure that dots do not overlap outer border
theta = 2 * pi * rand(dots.number,1); %values between 0 and 2pi (2pi ~ 6.28)
dots.position = [cos(theta) sin(theta)];  %values between -1 and 1
dots.position = dots.position .* [dots.distanceToCenter dots.distanceToCenter*display.pixelRatioWidthPerHeight];

% baseline dot
oval.radiusHor = 0.375 * display.horizontalPixelPerDegree;
oval.radiusVer = 0.375 * display.verticalPixelPerDegree;

%Create a fixation point and show it for a random time (1000-1500ms)
fixation.duration = 0.5; %rand(1)*0.5+1; %Calculate random time in seconds
fixation.totalFrames = seconds2frames(display.frameRate, fixation.duration); %Convert seconds in frames
halfDegree = ceil(0.5 * display.horizontalPixelPerDegree); %size of one half degree on the screen
if(mod(halfDegree,2)==1)
    halfDegree = halfDegree +1;
end

%set starting position and direction of translational movement
if(moveToRight)
    dots.center = ceil(leftStartingPosition);
    directionMultiplier = 1;
else
    dots.center = ceil(rightStartingPosition);
    directionMultiplier = -1;
end

%Fill background
Screen('FillRect', display.windowPointer, grey);

%don't show fixation point for a certain time
fixation.pause = seconds2frames(display.frameRate, 0.05);

fixation.recordedTime = seconds2frames(display.frameRate, 0.7);

%Fixation interval--draw static dots with both slopes
for frame = 1:fixation.totalFrames-fixation.pause
%     % draw RDP
%     Screen('DrawDots', display.windowPointer, transpose(dots.position),...
%         dots.diameter, black, dots.center,1);  % change 1 to 0 to draw square dots
    
    % fixation cross
    Screen('DrawLine', display.windowPointer, red,...
        dots.center(1)-halfDegree/2, dots.center(2),...
        dots.center(1)+halfDegree/2, dots.center(2), 2);
    Screen('DrawLine', display.windowPointer, red,...
        dots.center(1), dots.center(2)-halfDegree/2,...
        dots.center(1), dots.center(2)+halfDegree/2, 2);
    
    if rotationalDirection==0 % no rotation, show a circle around fixation
        Screen('FrameOval', display.windowPointer, red,...
            [dots.center(1)-halfDegree/2, dots.center(2)-halfDegree/2,...
        dots.center(1)+halfDegree/2, dots.center(2)+halfDegree/2], 2);
    end
    
    % draw slopes
    Screen('DrawLines', display.windowPointer, ...
        slope.cuePositionInPixel, parameter.slopeWidth, black, [display.horizontalMiddle display.verticalMiddle]);
    
    if(frame >= fixation.totalFrames-fixation.recordedTime)
        trigger.startRecording();
    end
    
    Screen('Flip',display.windowPointer);
end

%Show blank screen--take one "blockage" off to indicate moving direction
for frame = 1:fixation.pause
%     % draw RDP
%     Screen('DrawDots', display.windowPointer, transpose(dots.position),...
%         dots.diameter, black, dots.center,1);  % change 1 to 0 to draw square dots
    
    % draw slopes with one side shorter
    % draw slopes
    Screen('DrawLines', display.windowPointer, ...
        slope.cuePositionInPixel, parameter.slopeWidth, black, [display.horizontalMiddle display.verticalMiddle]);
    
    Screen('Flip',display.windowPointer);
end

%Calculate the number of frames
trial.stimulusFrames = seconds2frames(display.frameRate, trial.duration);

%Trial interval
for frame = 1:trial.stimulusFrames+1
    
    %Draw dots on screen
    if(parameter.baselineCircle || parameter.torsion)
%     Screen('DrawDots', display.windowPointer, transpose(dots.position),...
%         dots.diameter, black, dots.center,0);  % change 1 to 0 to draw square dots
%        %Draw dots on screen
% DKP changed to get antialiased dots  Try 1 or 2 (1 may give less jitter)
        Screen('DrawDots', display.windowPointer, transpose(dots.position),...
            dots.diameter, black, dots.center,1);  % change 1 to 0 to draw square dots
    end
    % draw slopes
    Screen('DrawLines', display.windowPointer, ...
        slope.cuePositionInPixel, parameter.slopeWidth, black, [display.horizontalMiddle display.verticalMiddle]);
    
    %Draw oval on screen
    if(parameter.baselineDot)
        Screen('FillOval', display.windowPointer, black, [dots.center(1)-oval.radiusHor dots.center(2)-oval.radiusVer dots.center(1)+oval.radiusHor dots.center(2)+oval.radiusVer]);
    end
     
    %Show outline
    if(parameter.showOutline)
        Screen('FrameOval', display.windowPointer, black,...
            [dots.center(1)-circle.horizontalDiameterInPixel/2 ...
            dots.center(2)-circle.verticalDiameterInPixel/2 ...
            dots.center(1)+circle.horizontalDiameterInPixel/2 ...
            dots.center(2)+circle.verticalDiameterInPixel/2]);
    end
    
    Screen('Flip',display.windowPointer);
    
    %Update dot lifetime and replace dots with expired lifetime
    if(parameter.lifetimeLimited)
        dots.showTime = dots.showTime-1;
        expiredDots = find(dots.showTime <=0);
        dots.distanceToCenter(expiredDots) = circle.diameter/2 * sqrt((rand(length(expiredDots),1)))*display.horizontalPixelPerDegree;
        dots.distanceToCenter(expiredDots) = max(dots.distanceToCenter(expiredDots)-dots.diameter/2, 0);
        dots.showTime(expiredDots) = seconds2frames(display.frameRate, dots.lifetime);
    end
    
    %Updated positions (similar to initial dot placement)
    if(~parameter.baseline)
        theta = theta + (2*pi*circle.rotationSpeedPerFrame/360);
        dots.position = [cos(theta) sin(theta)];  %values between -1 and 1
        dots.position = dots.position .* [dots.distanceToCenter dots.distanceToCenter*display.pixelRatioWidthPerHeight];
    end
        horizontalMovement = circle.horizontalSpeedInPixel/display.frameRate * directionMultiplier;
        dots.center(1) = dots.center(1) + horizontalMovement;
        verticalMovement = circle.verticalSpeedInPixel/display.frameRate;
        dots.center(2) = dots.center(2) + verticalMovement;
        
        
    %Emergency Exit
    [~, ~, keyCode, ~] = KbCheck();
    if((keyCode(27) == 1 || keyCode(36) == 1))
        load('originalLUT.mat');
        Screen('LoadNormalizedGammaTable', display.windowPointer, originalLUT);
        pause(0.2);
        Screen('CloseAll');
    end
    
    
end

pauseAfterStimulus = 0.2;
pauseFrames = seconds2frames(display.frameRate, pauseAfterStimulus);

%Fill background
Screen('FillRect', display.windowPointer, grey);

for frame = 1:pauseFrames
    Screen('Flip',display.windowPointer);
end

end