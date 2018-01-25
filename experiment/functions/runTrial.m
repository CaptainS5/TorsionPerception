function [key rt] = runTrial(blockN, trialN, tempN)

global trigger;
global prm display info resp

% Initialization
% fill the background
Screen('FillRect', prm.screen.windowPtr, prm.screen.backgroundColour); % fill background

% different in each trial
sizeN = display{blockN}.gratingRadiusIdx(trialN); % index of the grating stimulus outer radius
speedIdx = find(prm.rotation.freq==display{blockN}.rotationSpeed(trialN));
flashOnset = round(sec2frm(display{blockN}.flashOnset(trialN)));
flashDisplacement = dva2pxl(display{blockN}.flashDisplaceLeft(trialN));
% % randomly decide the initial direction and angle of the grating
% if rand>=0.5
%     direction = 1; % clockwise
% else
%     direction = -1; % counterclockwise
% end
direction = display{blockN}.initialDirection(trialN);
rotationFramesBefore = round(sec2frm(prm.rotation.beforeDuration));
rotationFramesAfter = round(sec2frm(prm.rotation.afterDuration));
% rotationAngle = rand*360 - direction*prm.rotation.anglePerFrame;
if rand>=0.5
    rotationAngle = 0 - direction*prm.rotation.anglePerFrame(speedIdx)*(1+rotationFramesBefore+flashOnset);
else
    rotationAngle = 180 - direction*prm.rotation.anglePerFrame(speedIdx)*(1+rotationFramesBefore+flashOnset);
end
initialAngle = rotationAngle; % for presentation of the markers
% % randomly decide the duration of rotations in this trial
% if rand>=0.5
%     rotationFrames = 2*round(sec2frm(prm.rotation.baseDuration+prm.rotation.randDuration));
% else
%     rotationFrames = 2*round(sec2frm(prm.rotation.baseDuration-prm.rotation.randDuration));
% end
display{blockN}.initialAngle(trialN) = rotationAngle;
display{blockN}.durationBefore(trialN) = rotationFramesBefore/prm.screen.refreshRate;
display{blockN}.durationAfter(trialN) = rotationFramesAfter/prm.screen.refreshRate;

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
% bar
flashWidth = round(dva2pxl(prm.flash.width));
flashLength = dva2pxl(prm.flash.length);
ecc = dva2pxl(prm.flash.eccentricity+prm.grating.outerRadius(sizeN));
if rand>=0.5 % change the location of the left flash, or counterclockwise when vertical
    display{blockN}.sideDisplaced(trialN) = -1;
    % bar flash
    flashRectL = [prm.screen.center(1)-ecc-flashLength, ...
        prm.screen.center(2)-flashDisplacement-flashWidth/2, ...
        prm.screen.center(1)-ecc, ...
        prm.screen.center(2)-flashDisplacement+flashWidth/2]; % left or top
    flashRectR = [prm.screen.center(1)+ecc, ...
        prm.screen.center(2)-flashWidth/2, ...
        prm.screen.center(1)+ecc+flashLength, ...
        prm.screen.center(2)+flashWidth/2]; % right or bottom
else % change the location of the right flash, or clockwise when vertical
    display{blockN}.sideDisplaced(trialN) = 1;
    % bar flash
    flashRectL = [prm.screen.center(1)-ecc-flashLength, ...
        prm.screen.center(2)-flashWidth/2, ...
        prm.screen.center(1)-ecc, ...
        prm.screen.center(2)+flashWidth/2]; % left or top
    flashRectR = [prm.screen.center(1)+ecc, ...
        prm.screen.center(2)+flashDisplacement-flashWidth/2, ...
        prm.screen.center(1)+ecc+flashLength, ...
        prm.screen.center(2)+flashDisplacement+flashWidth/2]; % right or bottom
end
flashDuration = round(sec2frm(prm.flash.duration));
% prm.flash.colour = prm.screen.whiteColour;

% start display
if info.eyeTracker==1
    trigger.startRecording();
end
quitFlag=0;
% record response, won't continue until a response is recorded
recordFlag=0;

% draw fixation at the beginning of each trial
Screen('FrameOval', prm.screen.windowPtr, prm.fixation.colour, rectFixRing, dva2pxl(0.05), dva2pxl(0.05));
Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot);
Screen('Flip', prm.screen.windowPtr);
resp.fixationDuration(tempN, 1) = prm.fixation.durationBase+rand*prm.fixation.durationJitter;
WaitSecs(resp.fixationDuration(tempN, 1));

for frameN = 1:(rotationFramesBefore+rotationFramesAfter+flashOnset+flashDuration) % Reversal--rotationFrames, motion stops when presenting flash
    
    if frameN<=rotationFramesBefore+flashOnset % first direction
        rotationAngle = rotationAngle + direction*prm.rotation.anglePerFrame(speedIdx);
        %     elseif frameN==rotationFrames/2+flashOnset
        %         rotationAngle = initialAngle + direction*prm.rotation.anglePerFrame + direction*90; % force it to stop at vertical
    elseif frameN>rotationFramesBefore+flashOnset+flashDuration % second direction, after reversal
        rotationAngle = rotationAngle - direction*prm.rotation.anglePerFrame(speedIdx);
    end
    
    if rotationAngle > 180
        rotationAngle = rotationAngle - 180;
    elseif rotationAngle < 0
        rotationAngle = rotationAngle + 180;
    end
    
    if info.expType==1 % experiment
        % draw rotating grating
        Screen('DrawTexture', prm.screen.windowPtr, prm.grating.tex{sizeN}, [], [], rotationAngle);
    else % baseline
        % draw fixation
        Screen('FrameOval', prm.screen.windowPtr, prm.fixation.colour, rectFixRing, dva2pxl(0.05), dva2pxl(0.05));
        Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot);
    end
    % draw flash
    %     % No Reversal
    %     if frameN>=flashOnset
    %         Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectL);
    %         Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectR);
    %     end
    
    % Reversal
    if frameN>=rotationFramesBefore+flashOnset && frameN<=rotationFramesBefore+flashOnset+flashDuration
        %         % bar flash
        %         Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectL);
        %         Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectR);
        % dots flash -- how the hell can I get the transparency?????
        Screen('DrawTexture', prm.screen.windowPtr, prm.flash.tex{sizeN}, [], [], rotationAngle, [], 1);
    end
    
    % Reversal
    if frameN==rotationFramesBefore+flashOnset
        %     % No Reversal
        %     if frameN==flashOnset
        %         StimulusOnsetTime = GetSecs;
        %         Screen('Flip', prm.screen.windowPtr);
        [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', prm.screen.windowPtr);
        
        %         pause;
        display{blockN}.reversalAngle(trialN) = rotationAngle;
    end
    
    %     % record response
    %     if frameN>=rotationFrames/2+flashOnset+flashDuration
    %         %% button response
    %         clear KbCheck
    %         [keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
    %         if keyIsDown
    %             %         if frameN>=rotationFrames/2+flashOnset
    %             key = KbName(keyCode);
    %             rt = secs-StimulusOnsetTime;
    %             StimulusOnsetTime = [];
    % %             Screen('Flip', prm.screen.windowPtr);
    %             %         else
    %             %             key = KbName(keyCode);
    %             %             rt = -1;
    %             %         end
    %             % display of motion after flash offset
    %             quitFlag = 1;
    %             recordFlag = 1;
    %             %     elseif frameN==rotationFrames
    %             %         key = 'void';
    %             %         rt = 0;
    %         end
    %         %% end of button response
    %     end
    Screen('Flip', prm.screen.windowPtr);
    %     if frameN==1 || frameN==rotationFrames/2+flashDuration || frameN == rotationFrames+flashDuration
    %         pause;
    %         rotationAngle
    %     end
    
    %     % display of motion after flash offset
    %     if quitFlag==1
    %         break
    %     end
end
% end
% StimulusOffsetTime = GetSecs; % here is actually the offset time

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

buttons = [];
x = [];
key = [];
rt = [];
[x0, y0, buttons0, focus0, valuators0, valinfo0] = GetMouse(prm.screen.windowPtr);
while quitFlag==0
    %     % response window
    %     if info.eyeTracker==1 && secs-StimulusOnsetTime>=prm.recording.stopDuration && recordFlag==0 % stop recording after a certain duration after offset
    %         trigger.stopRecording();
    %         recordFlag = 1;
    %     end
    % for quitting at any timr
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
    if keyIsDown
        key = KbName(keyCode);
        break
    end
    %% mouse response
    % display the stimuli, random starting angle
    if isempty(x) % the first loop, random angle
        % show the cursor; put it at the start angle everytime
        respAngle = 180*rand;
        SetMouse(prm.screen.size(3)/2+cos((respAngle-90)/180*pi)*ecc, ...
            prm.screen.size(4)/2+sin((respAngle-90)/180*pi)*ecc, ...
            prm.screen.windowPtr);
    else % changing the angle of the next loop according to the cursor position
        respAngle = atan2(y-prm.screen.size(4)/2, x-prm.screen.size(3)/2)/pi*180+90;
    end
%             ShowCursor('CrossHair',  prm.screen.windowPtr); % draw a text instead, which you can control thr color...
    if respAngle>180
        respAngle = respAngle-180;
    elseif respAngle<0
        respAngle = respAngle+180;
    end
    Screen('DrawTexture', prm.screen.windowPtr, prm.resp.tex, [], [], respAngle);
    Screen('DrawText', prm.screen.windowPtr, '+', x0, y0, prm.screen.blackColour);
    Screen('Flip', prm.screen.windowPtr);
    
    if ~isempty(x)
        x0 = x; % record "old" position
        y0 = y;
    end
    % get new mouse position
    [x, y, buttons, focus, valuators, valinfo] = GetMouse(prm.screen.windowPtr);
    
    if any(buttons) % record the last mouse position
        %             rt = Get
        resp.reportAngle(tempN, 1) = respAngle;
        quitFlag = 1;
    end
    %% end of mouse response
    
    %     %% button response
    %         [keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
    %     if keyIsDown
    %         %         if frameN>=rotationFrames/2+flashOnset
    %         if info.eyeTracker==1 && recordFlag==0 % stop recording after a certain duration after offset
    %             trigger.stopRecording();
    %             recordFlag = 1;
    %         end
    %         key = KbName(keyCode);
    %         rt = secs-StimulusOnsetTime;
    %         StimulusOnsetTime = [];
    %         quitFlag = 1;
    %         %         % draw fixation
    %         %         Screen('FrameOval', prm.screen.windowPtr, prm.fixation.colour, rectFixRing, dva2pxl(0.05), dva2pxl(0.05));
    %         %         Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot);
    %         %
    % %         Screen('Flip', prm.screen.windowPtr);
    %         %         else
    %         %             key = KbName(keyCode);
    %         %             rt = -1;
    %         %         end
    %         %         break
    %         %     elseif frameN==rotationFrames
    %         %         key = 'void';
    %         %         rt = 0;
    %     end
    %     %% end of button response
end

% HideCursor();

if info.eyeTracker==1
    trigger.stopRecording();
    recordFlag = 1;
end
% end