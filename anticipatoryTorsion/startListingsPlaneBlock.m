function positionLog = startListingsPlaneBlock(screenWidth, screenHeight, screenDistance, windowPointer, screenSize, parameter)

global trigger;
disp('ListingsPlane block started.');

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
red = [255 0 0];
grey = [150 150 150];

%Setup display
display.widthInPixel = display.size(3) - display.size(1);
display.heightInPixel = display.size(4) - display.size(2);
display.pixelRatioWidthPerHeight = (screenWidth/display.widthInPixel)/(screenHeight/display.heightInPixel);

display.screenWidthInDegree = 360/pi * atan(screenWidth/(2*screenDistance));
display.pixelPerDegree = display.widthInPixel / display.screenWidthInDegree;

fiveDegreeHorizontal = 5 * display.pixelPerDegree;
fiveDegreeVertical = 5 * display.pixelPerDegree * display.pixelRatioWidthPerHeight;


halfDegree = 0.5 * display.pixelPerDegree; %size of one half degree on the screen
if(mod(halfDegree,2)==1)
    halfDegree = halfDegree +1;
end

%Fill background
Screen('FillRect', display.windowPointer, grey);


horizontalFixationPoints= 5;
verticalFixationPoints = 5;

numberFixationPoints = horizontalFixationPoints * verticalFixationPoints;

numberOfRepititions = parameter.trialsPerCondition;
numberOfFixationTrials = numberFixationPoints * numberOfRepititions;

fixationPoints = [horizontalFixationPoints,verticalFixationPoints];

while(true)
    conditions = randperm(numberOfFixationTrials);
    conditions = mod(conditions,numberFixationPoints)+1;
    shuffleAgain = false;
    
    %Check whether two consecutive numbers are similar
    %If so, set shuffleAgain flag
    for p = 2:numberOfFixationTrials
        
        if conditions(p) == conditions(p-1)
            shuffleAgain = true;
        end
    end
    
    if(~shuffleAgain)
        break;
    end
    
end

fixationPointsConditionTable = createConditionTable(fixationPoints);
fixationPointsConditionTable(:,2:3) = fixationPointsConditionTable(:,2:3)-3;

horizontalOffset = fixationPointsConditionTable(:,2);
verticalOffset = fixationPointsConditionTable(:,3);

positionCenter = [display.widthInPixel/2 display.heightInPixel/2];

drawCross(positionCenter, halfDegree, red);

Screen('Flip',display.windowPointer);



pause(1);

positionLog = [];
orderCounter = 1;

for run = conditions
    
    horizontalPosition = positionCenter(1) - horizontalOffset(run) * fiveDegreeHorizontal;
    verticalPosition = positionCenter(2) + verticalOffset(run) * fiveDegreeVertical;
    
    positionLog(orderCounter, 1:3) = [orderCounter horizontalOffset(run) verticalOffset(run)];
    orderCounter = orderCounter + 1;
    
    circlePosition = [horizontalPosition verticalPosition];
    
    
    drawCircle(circlePosition, 0.75, black);
    drawCircle(circlePosition, 0.25, grey);
    
    Screen('Flip',display.windowPointer);
    
    trigger.startRecording();
    %show circle for x seconds
    pause(1.5);
    
    %Emergency Exit
    [~, ~, keyCode, ~] = KbCheck();
    if((keyCode(27) == 1 || keyCode(36) == 1))
        load('originalLUT.mat');
        Screen('LoadNormalizedGammaTable', display.windowPointer, originalLUT);
        pause(0.2);
        Screen('CloseAll');
    end
    
    trigger.stopRecording();
    
    
    drawCross(positionCenter, halfDegree, red);
    
    Screen('Flip',display.windowPointer);
    trigger.startRecording();
    
    %show cross for x seconds
    pause(1);
    trigger.stopRecording();
    
end



Screen('LoadNormalizedGammaTable', display.windowPointer, originalLUT);
ShowCursor;

%write  log file
fileName = [num2str(parameter.subjectID) '_' num2str(parameter.experimentID) '_' datestr(now, '_yyyy_mmmm_dd') '_ListingsPlane_Block_' num2str(parameter.block) '.mat'];
filePath = fullfile(pwd,'..','LogFiles',fileName);
save(filePath,'positionLog');


disp(positionLog);

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


    function drawCross(center, halfDegree, color)
        
        Screen('DrawLine', display.windowPointer, red,...
            center(1)-halfDegree/2, center(2),...
            center(1)+halfDegree/2, center(2), 2);
        Screen('DrawLine', display.windowPointer, red,...
            center(1), center(2)-halfDegree/2,...
            center(1), center(2)+halfDegree/2, 2);
    end


end