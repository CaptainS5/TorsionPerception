function showCenterFixation(windowPointer, displayDimensions, screenWidth, screenHeight, screenDistance)

global trigger;

%Setup display properties
display.windowPointer = windowPointer; %returns a hold for the window
display.dimensions = displayDimensions;%format [left top right bottom]
display.widthInPixel = display.dimensions(3) - display.dimensions(1); %latter should be 0
display.heightInPixel = display.dimensions(4) - display.dimensions(2); %latter should be 0
display.horizontalMiddle = display.widthInPixel/2;
display.verticalMiddle = display.heightInPixel/2;
display.screenWidthInCm = screenWidth; %set via GUI
display.distanceToScreen = screenDistance; %set via GUI
%Now do the calculation from degree to pixel
display.screenWidthInDegree = 360/pi * atan(display.screenWidthInCm/(2*display.distanceToScreen));
display.pixelPerDegree = display.widthInPixel / display.screenWidthInDegree;
display.pixelRatioWidthPerHeight = (screenWidth/display.widthInPixel)/(screenHeight/display.heightInPixel);
%Calculate frame rate
display.frameRate = 1/Screen('GetFlipInterval',display.windowPointer); %in Hz (frames per second: fps)

%Setup colors
black = BlackIndex(display.windowPointer);
white = WhiteIndex(display.windowPointer);
grey = [150 150 150];

circleCenter = [display.horizontalMiddle display.verticalMiddle];
durationInSeconds = 3;

totalFrames = seconds2frames(display.frameRate, durationInSeconds);

%Fill background
Screen('FillRect', display.windowPointer, grey);

whiteSize = [5 4 3 2 1 0 1 2 3 4]/10;

trigger.startRecording();

%Fixation interval
for frame = 1:totalFrames
    
    drawCircle(circleCenter, 0.75, black);
    drawCircle(circleCenter, 0.25, grey);
%     drawCircle(circleCenter, whiteSize(floor(mod(frame/4,length(whiteSize)))+1), white);
    
    Screen('Flip',display.windowPointer);
end

trigger.stopRecording();


    function drawCircle(center, diameter, color)
        
        diameterInDegree = diameter;
        diameterInPixel = diameterInDegree * display.pixelPerDegree;
        
        left = center(1) - diameterInPixel/2;
        right = center(1) + diameterInPixel/2;
        top = center(2) - (diameterInPixel/2)*display.pixelRatioWidthPerHeight;
        bottom = center(2) + (diameterInPixel/2)*display.pixelRatioWidthPerHeight;
        
        position = [left top right bottom];
        
        Screen('FillOval', display.windowPointer, color, position);
        
    end

end