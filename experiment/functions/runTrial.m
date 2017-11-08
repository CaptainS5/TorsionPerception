function [key rt] = runTrial(blockN, trialN)

global trigger;
global prm disp info

% Initialization
% fill the background
Screen('FillRect', prm.screen.windowPtr, prm.screen.blackColour); % fill background

% different in each trial
sizeN = disp{blockN}.gratingRadiusIdx(trialN); % index of the grating stimulus outer radius
flashOnset = floor(sec2frm(disp{blockN}.flashOnset(trialN)));
flashDisplacement = dva2pxl(disp{blockN}.flashDisplaceLeft(trialN));
% randomly decide the initial direction and angle of the grating
if rand>=0.5
    direction = 1; % clockwise
else
    direction = -1; % counterclockwise
end
rotationAngle = rand*360 - direction*prm.rotation.anglePerFrame;
% randomly decide the duration of rotations in this trial
if rand>=0.5
    rotationFrames = 2*floor(sec2frm(prm.rotation.baseDuration+prm.rotation.randDuration));
else
    rotationFrames = 2*floor(sec2frm(prm.rotation.baseDuration-prm.rotation.randDuration));
end
disp{blockN}.initialDirection(trialN) = direction;
disp{blockN}.initialAngle(trialN) = rotationAngle;
disp{blockN}.duration(trialN) = rotationFrames/prm.screen.refreshRate;

% rest of the set ups
% fixation set up
rectSizeRing = dva2pxl(prm.fixation.ringRadius);
rectFixRing = [prm.screen.center(1)-rectSizeRing,...
    prm.screen.center(2)-rectSizeRing,...
    prm.screen.center(1)+rectSizeRing,...
    prm.screen.center(2)+rectSizeRing];
rectSizeDot = dva2pxl(prm.fixation.dotRadius);
rectFixDot = [prm.screen.center(1)-rectSizeDot,...
    prm.screen.center(2)-rectSizeDot,...
    prm.screen.center(1)+rectSizeDot,...
    prm.screen.center(2)+rectSizeDot];

% flash set up
flashWidth = round(dva2pxl(prm.flash.width));
flashLength = dva2pxl(prm.flash.length);
ecc = dva2pxl(prm.flash.eccentricity+prm.grating.outerRadius(sizeN));
if rand>=0.5 % change the location of the left flash
    disp{blockN}.sideDisplaced(trialN) = -1;
flashRectL = [prm.screen.center(1)-ecc-flashLength, ...
    prm.screen.center(2)-flashDisplacement-flashWidth/2, ...
    prm.screen.center(1)-ecc, ...
    prm.screen.center(2)-flashDisplacement+flashWidth/2]; % left
flashRectR = [prm.screen.center(1)+ecc, ...
    prm.screen.center(2)-flashWidth/2, ...
    prm.screen.center(1)+ecc+flashLength, ...
    prm.screen.center(2)+flashWidth/2]; % right
else % change the location of the right flash
    disp{blockN}.sideDisplaced(trialN) = 1;
    flashRectL = [prm.screen.center(1)-ecc-flashLength, ...
    prm.screen.center(2)-flashWidth/2, ...
    prm.screen.center(1)-ecc, ...
    prm.screen.center(2)+flashWidth/2]; % left
flashRectR = [prm.screen.center(1)+ecc, ...
    prm.screen.center(2)+flashDisplacement-flashWidth/2, ...
    prm.screen.center(1)+ecc+flashLength, ...
    prm.screen.center(2)+flashDisplacement+flashWidth/2]; % right
end
flashDuration = round(sec2frm(prm.flash.duration));
% prm.flash.colour = prm.screen.whiteColour;

% start display
if info.eyeTracker==1
    trigger.startRecording();
end
for frameN = 1:rotationFrames
    if frameN<=rotationFrames/2 % first direction
        rotationAngle = rotationAngle + direction*prm.rotation.anglePerFrame;
    else % second direction, after reversal
        rotationAngle = rotationAngle - direction*prm.rotation.anglePerFrame;
    end
    if rotationAngle > 360
        rotationAngle = rotationAngle - 360;
    end
    
    % draw rotating grating
    if info.expType==1 % for baseline
        Screen('DrawTexture', prm.screen.windowPtr, prm.grating.tex{sizeN}, [], [], rotationAngle)
    end
    % draw fixation
    Screen('FrameOval', prm.screen.windowPtr, prm.fixation.colour, rectFixRing, dva2pxl(0.05), dva2pxl(0.05));
    Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot);
    % draw flash
    if frameN>=rotationFrames/2+flashOnset && frameN<=rotationFrames/2+flashOnset+flashDuration
        Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectL);
        Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectR);
    end
    
%     if frameN==rotationFrames/2+flashOnset
%         StimulusOnsetTime = GetSecs;
% %         Screen('Flip', prm.screen.windowPtr);
%         [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', prm.screen.windowPtr);
% %         break
%     else
        Screen('Flip', prm.screen.windowPtr);
%     end
end
StimulusOffsetTime = GetSecs; % here is actually the offset time
if info.eyeTracker==1
    trigger.stopRecording();
end

% response instruction
% if info.reportStyle==-1
%     textResp = ['Flash on which side is lower?'];
% elseif info.reportStyle==1
%     textResp = ['Flash on which side is higher?'];
% else
%     textResp = ['Wrong input. Please ask the experimenter.'];
% end
% Screen('DrawText', prm.screen.windowPtr, textResp, prm.screen.center(1)-200, prm.screen.center(2), prm.screen.whiteColour);
Screen('Flip', prm.screen.windowPtr);

% record response, won't continue until a response is recorded
while 1
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
    if keyIsDown
        %         if frameN>=rotationFrames/2+flashOnset
        key = KbName(keyCode);
        rt = secs-StimulusOffsetTime;
        StimulusOffsetTime = [];
        Screen('Flip', prm.screen.windowPtr);
        %         else
        %             key = KbName(keyCode);
        %             rt = -1;
        %         end
        break
        %     elseif frameN==rotationFrames
        %         key = 'void';
        %         rt = 0;
    end
end

end