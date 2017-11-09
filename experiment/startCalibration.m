function startCalibration(screenWidth, screenHeight, screenDistance, windowPointer, screenSize)

global trigger;
global prm;


% HideCursor;
display.windowPointer = windowPointer;
display.size = screenSize;

load('lut527.mat', 'lut527')
% Make a backup copy of original LUT into origLUT.
originalLUT=Screen('ReadNormalizedGammaTable', display.windowPointer);
save('originalLUT.mat', 'originalLUT');
Screen('LoadNormalizedGammaTable', display.windowPointer, lut527);

%Setup colors
black = BlackIndex(display.windowPointer);
white = WhiteIndex(display.windowPointer);
grey = [150 150 150];

%Setup display
display.widthInPixel = display.size(3) - display.size(1);
display.heightInPixel = display.size(4) - display.size(2);
display.pixelRatioWidthPerHeight = (screenWidth/display.widthInPixel)/(screenHeight/display.heightInPixel);

display.screenWidthInDegree = 360/pi * atan(screenWidth/(2*screenDistance));
display.pixelPerDegree = display.widthInPixel / display.screenWidthInDegree;

% tenDegreeHorizontal = 10 * display.pixelPerDegree;
% tenDegreeVertical = 10 * display.pixelPerDegree * display.pixelRatioWidthPerHeight;

tenDegreeHorizontal = (prm.grating.outerRadius+prm.flash.eccentricity+prm.flash.length/2) * display.pixelPerDegree; % center of the flash
tenDegreeVertical = prm.grating.outerRadius * display.pixelPerDegree * display.pixelRatioWidthPerHeight; % edge of the grating

%Fill background
Screen('FillRect', display.windowPointer, grey);


places = 4;

while(true)
    conditions = randperm(places*2);
    conditions = mod(conditions,places)+1;
    shuffleAgain = false;
    
    %Check whether two consecutive numbers are similar
    %If so, set shuffleAgain flag
    for p = 2:places*2
        
        if conditions(p) == conditions(p-1)
            shuffleAgain = true;
        end
    end
    
    if(~shuffleAgain)
        break;
    end
    
end


positionCenter = [display.widthInPixel/2 display.heightInPixel/2];

positionLeft = [display.widthInPixel/2-tenDegreeHorizontal display.heightInPixel/2];

positionRight = [display.widthInPixel/2+tenDegreeHorizontal display.heightInPixel/2];

positionTop = [display.widthInPixel/2 display.heightInPixel/2-tenDegreeVertical];

positionBottom = [display.widthInPixel/2 display.heightInPixel/2+tenDegreeVertical];

positions = {positionLeft positionTop positionRight positionBottom};

drawCircle(positionCenter, 0.75, black);
drawCircle(positionCenter, 0.25, grey);

Screen('Flip',display.windowPointer);

%on Space
while(true)
    [~, ~, keyCode, ~] = KbCheck();
    if((keyCode(32) == 1))
        break;
    end
    
end

trigger.startRecording();

pause(1);

for run = conditions
    drawCircle(positions{run}, 0.75, black);
    drawCircle(positions{run}, 0.25, grey);
    
    Screen('Flip',display.windowPointer);
    
    %show circles (periphery)
    pause(2);
 
    %Emergency Exit
    [~, ~, keyCode, ~] = KbCheck();
    if((keyCode(27) == 1 || keyCode(36) == 1))
        load('originalLUT.mat');
        Screen('LoadNormalizedGammaTable', display.windowPointer, originalLUT);
        pause(0.2);
        Screen('CloseAll');
    end
    
    drawCircle(positionCenter, 0.75, black);
    drawCircle(positionCenter, 0.25, grey);
    
    Screen('Flip',display.windowPointer);

    %show circle (center fixation)
    pause(1.5);

end

trigger.stopRecording();

Screen('LoadNormalizedGammaTable', display.windowPointer, originalLUT);
ShowCursor;


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