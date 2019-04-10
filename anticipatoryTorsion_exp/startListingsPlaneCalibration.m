function startListingsPlaneCalibration(screenWidth, screenHeight, screenDistance, windowPointer, screenSize, parameter)

global trigger;
disp('ListingsPlane calibration started.');

% HideCursor;
display.windowPointer = windowPointer;
display.size = screenSize;

keys.home = 36;
keys.esc = 27;
keys.space = 32;

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

fiveDegreeHorizontal = 5 * display.pixelPerDegree;
fiveDegreeVertical = 5 * display.pixelPerDegree * display.pixelRatioWidthPerHeight;
tenDegreeHorizontal = 10 * display.pixelPerDegree;
tenDegreeVertical = 10 * display.pixelPerDegree * display.pixelRatioWidthPerHeight;

%Fill background
Screen('FillRect', display.windowPointer, grey);


possibleConditions = [3 3];

conditionTable = createConditionTable(possibleConditions);

conditionSampler = createConditionSampler(possibleConditions, 2);

positionLog = (conditionTable(conditionSampler,2:3)-2)*2; %#ok<NASGU>
fileName = [num2str(parameter.subjectID) '_' num2str(parameter.experimentID) '_' datestr(now, '_yyyy_mmmm_dd') '_ListingsPlane_Calibration_' num2str(parameter.block) '.mat'];
logFileName = fullfile(pwd,'..','LogFiles',fileName);

try
    save(logFileName,'positionLog','-append');
catch %#ok<CTCH>
    save(logFileName,'positionLog');
end

positionCenter = [display.widthInPixel/2 display.heightInPixel/2];

drawCircle(positionCenter, 0.75, black);
drawCircle(positionCenter, 0.25, grey);

Screen('Flip',display.windowPointer);

%on Space
while(true)
    [~, ~, keyCode, ~] = KbCheck();
    if((keyCode(keys.space) == 1))
        break;
    end
    
end

trigger.startRecording();

pause(1.5);

trigger.stopRecording();

for run = 1:length(conditionSampler)
    
    runConditions = conditionTable(conditionSampler(run),2:length(possibleConditions)+1);
    runConditions = (runConditions-2) * 2; % to align with saccade block (Fick coordinates)
    
    circlePosition = [positionCenter(1) + runConditions(1) * fiveDegreeHorizontal positionCenter(2) + runConditions(2) * fiveDegreeVertical];
    
    trigger.startRecording();
    
    drawCircle(circlePosition, 0.75, black);
    drawCircle(circlePosition, 0.25, grey);
    
    Screen('Flip',display.windowPointer);
    
    %show circles (periphery)
    pause(2);
    
    trigger.stopRecording();
    
    %Emergency Exit
    [~, ~, keyCode, ~] = KbCheck();
    if((keyCode(keys.esc) == 1 || keyCode(keys.home) == 1))
        load('originalLUT.mat');
        Screen('LoadNormalizedGammaTable', display.windowPointer, originalLUT);
        pause(0.2);
        Screen('CloseAll');
    end
    
    drawCircle(positionCenter, 0.75, black);
    drawCircle(positionCenter, 0.25, grey);
    
    Screen('Flip',display.windowPointer);
    
    trigger.startRecording();
    
    %show circle (center fixation)
    pause(1);
    
    trigger.stopRecording();
    
    Screen('Flip',display.windowPointer);
    
    
end


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