function [key rt] = runTrial(blockN, trialN, tempN)

global trigger;
global prm display info resp

% Initialization
% fill the background
Screen('FillRect', prm.screen.windowPtr, prm.screen.backgroundColour); % fill background

% different in each trial
sizeN = display{blockN}.gratingRadiusIdx(trialN); % index of the grating stimulus outer radius
[flashEcc temp]= dva2pxl(prm.flash.eccentricity, 0);
flashEcc = round(flashEcc);
[gratingRadiusX gratingRadiusY] = dva2pxl(prm.grating.outerRadius(sizeN), prm.grating.outerRadius(sizeN));
gratingRadiusX = round(gratingRadiusX);
gratingRadiusY = round(gratingRadiusY);
speedIdx = find(prm.rotation.freq==display{blockN}.rotationSpeed(trialN));
% flashOnset = round(sec2frm(display{blockN}.flashOnset(trialN)));
flashOnset = round(sec2frm(0.4*rand-0.2)); % random duration within -200 to 200ms
[temp flashDisplacement] = dva2pxl(0, display{blockN}.flashDisplaceLeft(trialN));
flashDisplacement = round(flashDisplacement);
direction = display{blockN}.initialDirection(trialN);
rotationFramesBefore = round(sec2frm(prm.rotation.beforeDuration));
rotationFramesAfter = round(sec2frm(prm.rotation.afterDuration));
% rotationAngle = rand*360 - direction*prm.rotation.anglePerFrame;
if rand>=0.5
    rotationAngle = 0 - direction*prm.rotation.anglePerFrame(speedIdx)*(rotationFramesBefore+flashOnset);
else
    rotationAngle = 180 - direction*prm.rotation.anglePerFrame(speedIdx)*(rotationFramesBefore+flashOnset);
end
initialAngle = rotationAngle; % for presentation of the markers
if rand>=0.5
    rotationAngle2 = 0 + direction*prm.rotation.anglePerFrame(speedIdx)*(rotationFramesBefore+flashOnset);
else
    rotationAngle2 = 180 + direction*prm.rotation.anglePerFrame(speedIdx)*(rotationFramesBefore+flashOnset);
end
initialAngle2 = rotationAngle2; % for presentation of the markers
% % randomly decide the duration of rotations in this trial
% if rand>=0.5
%     rotationFrames = 2*round(sec2frm(prm.rotation.baseDuration+prm.rotation.randDuration));
% else
%     rotationFrames = 2*round(sec2frm(prm.rotation.baseDuration-prm.rotation.randDuration));
% end
display{blockN}.initialAngle(trialN) = rotationAngle;
display{blockN}.initialAngle2(trialN) = rotationAngle2; % for control, the non-target stimulus
display{blockN}.flashOnset(trialN) = flashOnset/prm.screen.refreshRate;
display{blockN}.durationBefore(trialN) = (rotationFramesBefore+flashOnset)/prm.screen.refreshRate;
display{blockN}.durationAfter(trialN) = rotationFramesAfter/prm.screen.refreshRate;

if fix(info.expType)~=info.expType % grating destination rectangle for control torsion
    rectRotationL = [prm.screen.center(1)-2*gratingRadiusX-flashEcc,...
    prm.screen.center(2)-gratingRadiusY,...
    prm.screen.center(1)-flashEcc,...
    prm.screen.center(2)+gratingRadiusY];
    rectRotationR = [prm.screen.center(1)+flashEcc,...
    prm.screen.center(2)-gratingRadiusY,...
    prm.screen.center(1)+2*gratingRadiusX+flashEcc,...
    prm.screen.center(2)+gratingRadiusY];
end
rectRotation = [prm.screen.center(1)-gratingRadiusX,...
    prm.screen.center(2)-gratingRadiusY,...
    prm.screen.center(1)+gratingRadiusX,...
    prm.screen.center(2)+gratingRadiusY];

% rest of the set ups
% fixation set up
[rectSizeRingX rectSizeRingY] = dva2pxl(prm.fixation.ringRadius, prm.fixation.ringRadius);
rectSizeRingX = round(rectSizeRingX);
rectSizeRingY = round(rectSizeRingY);
rectFixRing = [prm.screen.center(1)-rectSizeRingX,...
    prm.screen.center(2)-rectSizeRingY,...
    prm.screen.center(1)+rectSizeRingX,...
    prm.screen.center(2)+rectSizeRingY];
[rectSizeDotX rectSizeDotY] = dva2pxl(prm.fixation.dotRadius, prm.fixation.dotRadius);
rectSizeDotX = round(rectSizeDotX);
rectSizeDotY = round(rectSizeDotY);
rectFixDot = [prm.screen.center(1)-rectSizeDotX,...
    prm.screen.center(2)-rectSizeDotY,...
    prm.screen.center(1)+rectSizeDotX,...
    prm.screen.center(2)+rectSizeDotY];

% flash set up
% bar
[temp flashWidth] = dva2pxl(0, prm.flash.width);
flashWidth = round(flashWidth);
[flashLength temp] = dva2pxl(prm.flash.length, 0);
flashLength = round(flashLength);
ecc = flashEcc+gratingRadiusX;
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

% mPtr = Screen('CreateMovie', prm.screen.windowPtr, ['demo', num2str(trialN)], [], [], [], [], 3);

% draw fixation at the beginning of each trial
% Screen('FrameOval', prm.screen.windowPtr, prm.fixation.colour, rectFixRing, dva2pxl(0.05), dva2pxl(0.05));
Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot);
if fix(info.expType)~=info.expType % place holder for peripheral stimuli
    rectFixDotL = [prm.screen.center(1)-rectSizeDotX-ecc,...
    prm.screen.center(2)-rectSizeDotY,...
    prm.screen.center(1)+rectSizeDotX-ecc,...
    prm.screen.center(2)+rectSizeDotY];
    rectFixDotR = [prm.screen.center(1)-rectSizeDotX+ecc,...
    prm.screen.center(2)-rectSizeDotY,...
    prm.screen.center(1)+rectSizeDotX+ecc,...
    prm.screen.center(2)+rectSizeDotY];
    Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDotL);
    Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDotR);
end
Screen('Flip', prm.screen.windowPtr);
resp.fixationDuration(tempN, 1) = prm.fixation.durationBase+rand*prm.fixation.durationJitter;
WaitSecs(resp.fixationDuration(tempN, 1));
fixFrames = round(sec2frm(resp.fixationDuration(tempN, 1)));
% imgF = Screen('GetImage', prm.screen.windowPtr);
% imwrite(imgF, 'fixation.jpg')
% Screen('AddFrameToMovie', prm.screen.windowPtr, [], [], mPtr, fixFrames)

for frameN = 1:(rotationFramesBefore+rotationFramesAfter+flashOnset+flashDuration) % Reversal--rotationFrames, motion stops when presenting flash
    if info.expType>=1 % experiment
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
        
        if info.expType==1.5 % control torsion
            if frameN<=rotationFramesBefore+flashOnset % first direction for the non-target grating, opposite direction
                rotationAngle2 = rotationAngle2 - direction*prm.rotation.anglePerFrame(speedIdx);
                %     elseif frameN==rotationFrames/2+flashOnset
                %         rotationAngle = initialAngle + direction*prm.rotation.anglePerFrame + direction*90; % force it to stop at vertical
            elseif frameN>rotationFramesBefore+flashOnset+flashDuration % second direction, after reversal
                rotationAngle2 = rotationAngle2 + direction*prm.rotation.anglePerFrame(speedIdx);
            end
            if rotationAngle2 > 180
                rotationAngle2 = rotationAngle2 - 180;
            elseif rotationAngle < 0
                rotationAngle2 = rotationAngle2 + 180;
            end
        end
        
    elseif info.expType>=0 % baselineTorsion, rotating in one direction
        rotationAngle = rotationAngle - direction*prm.rotation.anglePerFrame(speedIdx); % rotating in the direction after reversal as in exp
        if info.expType==0.5
            rotationAngle2 = rotationAngle2 + direction*prm.rotation.anglePerFrame(speedIdx);
        end
    elseif info.expType<0 % baseline; different angles set up
        rotationAngle = direction*display{blockN}.rotationSpeed(trialN);
        if info.expType==-0.5
            rotationAngle2 = -direction*display{blockN}.rotationSpeed(trialN);
        end
    end
    
    if fix(info.expType)~=info.expType
        if display{blockN}.flashDisplaceLeft(trialN)==-1 % ask to report the left later
            rotationAngleL = rotationAngle;
            rotationAngleR = rotationAngle2;
        elseif display{blockN}.flashDisplaceLeft(trialN)==1
            rotationAngleR = rotationAngle;
            rotationAngleL = rotationAngle2;
        end
    end
    
    % draw rotating grating
    if info.expType>=0 && fix(info.expType)~=info.expType % control & baseline torsion        
        Screen('DrawTextures', prm.screen.windowPtr, prm.grating.tex{sizeN}, [], rectRotationL, rotationAngleL);
        Screen('DrawTextures', prm.screen.windowPtr, prm.grating.tex{sizeN}, [], rectRotationR, rotationAngleR);
        Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot);
    elseif info.expType>=0 && fix(info.expType)==info.expType % experiment & baselineTorsion        
        Screen('DrawTextures', prm.screen.windowPtr, prm.grating.tex{sizeN}, [], [], rotationAngle);
    elseif info.expType==-1 % baseline
        Screen('DrawTextures', prm.screen.windowPtr, prm.baseline.uniformTex{sizeN}, [], [], rotationAngle);
        Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot); % center of the wheel
    elseif info.expType==-0.5
        Screen('DrawTextures', prm.screen.windowPtr, prm.baseline.uniformTex{sizeN}, [], rectRotationL, rotationAngleL);
        Screen('DrawTextures', prm.screen.windowPtr, prm.baseline.uniformTex{sizeN}, [], rectRotationR, rotationAngleR);
        Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot);
    end
    
    % draw flash
    %     % No Reversal
    %     if frameN>=flashOnset
    %         Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectL);
    %         Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectR);
    %     end
    
    % Reversal, show flash
    if info.expType~=0 && info.expType~=0.5
        if frameN>=rotationFramesBefore+flashOnset && frameN<=rotationFramesBefore+flashOnset+flashDuration
            %         % bar flash
            %         Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectL);
            %         Screen('FillRect', prm.screen.windowPtr, prm.flash.colour, flashRectR);
            % dots flash -- how the hell can I get the transparency?????
            if info.expType==1 % experiment
                Screen('DrawTextures', prm.screen.windowPtr, prm.flash.tex{sizeN}, [], [], rotationAngle, [], 1);
            elseif info.expType==1.5
                Screen('DrawTextures', prm.screen.windowPtr, prm.flash.tex{sizeN}, [], rectRotationL, rotationAngleL, [], 1);
                Screen('DrawTextures', prm.screen.windowPtr, prm.flash.tex{sizeN}, [], rectRotationR, rotationAngleR, [], 1);
            elseif info.expType==-1 % baseline
                Screen('DrawTextures', prm.screen.windowPtr, prm.baseline.flashTex{sizeN}, [], [], rotationAngle, [], 1);
                Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot); % center of the wheel
            elseif info.expType==-0.5
                Screen('DrawTextures', prm.screen.windowPtr, prm.baseline.flashTex{sizeN}, [], rectRotationL, rotationAngleL, [], 1);
                Screen('DrawTextures', prm.screen.windowPtr, prm.baseline.flashTex{sizeN}, [], rectRotationR, rotationAngleR, [], 1);
                Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDotL); % center of the wheel
                Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDotR); % center of the wheel
            end
        end
    end
    
    % Reversal angle and timing
    if frameN==rotationFramesBefore+flashOnset
        %     % No Reversal
        %     if frameN==flashOnset
        %         StimulusOnsetTime = GetSecs;
        %         Screen('Flip', prm.screen.windowPtr);
        [VBLTimestamp StimulusOnsetTime FlipTimestamp Missed Beampos] = Screen('Flip', prm.screen.windowPtr);
        %         if trialN==1
        %         imgFl = Screen('GetImage', prm.screen.windowPtr);
        %         imwrite(imgFl, ['frame', num2str(frameN), '.jpg'])
        %         end
        %         pause;
        display{blockN}.reversalAngle(trialN) = rotationAngle;
        if fix(info.expType)~=info.expType
            display{blockN}.reversalAngle2(trialN) = rotationAngle2;
        end
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
    %     if trialN==1
    %     imgD = Screen('GetImage', prm.screen.windowPtr);
    %     imwrite(imgD, ['frame', num2str(frameN), '.jpg'])
    %     end
    %         Screen('AddFrameToMovie', prm.screen.windowPtr, [], [], mPtr);
    %     if frameN==1 || frameN==rotationFrames/2+flashDuration || frameN == rotationFrames+flashDuration
    %         pause;111
    %         rotationAngle
    %     end
    
    %     % display of motion after flash offset
    %     if quitFlag==1
    %         break
    %     end
end
% end
StimulusOffsetTime = GetSecs; % here is actually the offset time

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
% Screen('AddFrameToMovie', prm.screen.windowPtr, [], [], mPtr);

buttons = [];
x = [];
key = [];
rt = [];
[x0, y0, buttons0, focus0, valuators0, valinfo0] = GetMouse(prm.screen.windowPtr);
if info.eyeTracker==1
    trigger.stopRecording();
    recordFlag = 1;
end

yCenter = prm.screen.center(2);
if fix(info.expType)==info.expType % one grating in the center
    xCenter = prm.screen.center(1);
else % two gratings in the periphery
    if display{blockN}.flashDisplaceLeft(trialN)==-1 % ask to report the left later
        xCenter = prm.screen.center(1)-ecc;
    elseif display{blockN}.flashDisplaceLeft(trialN)==1
        xCenter = prm.screen.center(1)+ecc;
    end
end

while quitFlag==0
    %     % response window
    %     if info.eyeTracker==1 && secs-StimulusOnsetTime>=prm.recording.stopDuration && recordFlag==0 % stop recording after a certain duration after offset
    %         trigger.stopRecording();
    %         recordFlag = 1;
    %     end
    % for quitting at any time
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck();
    if keyIsDown
        key = KbName(keyCode);
        break
    end
    %% mouse response
    % display the stimuli, random starting angle
    if isempty(x) % the first loop, random angle
        % show the cursor; put it at the start angle everytime
        respAngle = 90*rand-45;
        SetMouse(xCenter+cos((respAngle-90)/180*pi)*ecc, ...
            yCenter+sin((respAngle-90)/180*pi)*ecc, ...
            prm.screen.windowPtr);
    else % changing the angle of the next loop according to the cursor position
        respAngle = atan2(y-yCenter, x-xCenter)/pi*180+90;
    end
    %             ShowCursor('CrossHair',  prm.screen.windowPtr); % draw a text instead, which you can control thr color...
    if respAngle>180
        respAngle = respAngle-180;
    elseif respAngle<0
        respAngle = respAngle+180;
    end
    if fix(info.expType)~=info.expType % control torsion
        if display{blockN}.flashDisplaceLeft(trialN)==-1 % report the left
            rectFixResp=rectRotationL;
        elseif display{blockN}.flashDisplaceLeft(trialN)==1 % report the right
            rectFixResp=rectRotationR;
        end
    elseif fix(info.expType)==info.expType % Exp1
        rectFixResp=rectRotation;
    end
    Screen('DrawTexture', prm.screen.windowPtr, prm.resp.tex{sizeN}, [], rectFixResp, respAngle);
%     if fix(info.expType)==info.expType
        Screen('FillOval', prm.screen.windowPtr, prm.fixation.colour, rectFixDot); % center of the wheel
%     end
    Screen('DrawText', prm.screen.windowPtr, '+', x0, y0, prm.screen.blackColour);
    Screen('Flip', prm.screen.windowPtr);
    %     if trialN==1
    %     frameN = frameN+1;
    %     imgR = Screen('GetImage', prm.screen.windowPtr);
    %     imwrite(imgR, ['frame', num2str(frameN), '.jpg'])
    %     end
    %         Screen('AddFrameToMovie', prm.screen.windowPtr, [], [], mPtr);
    
    if ~isempty(x)
        x0 = x; % record "old" position
        y0 = y;
    end
    % get new mouse position
    [x, y, buttons, focus, valuators, valinfo] = GetMouse(prm.screen.windowPtr);
    
    if any(buttons) % record the last mouse position
        rt = GetSecs-StimulusOffsetTime;
        resp.reportAngle(tempN, 1) = respAngle;
        quitFlag = 1;
    end
    buttons = [];
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
% end

% Screen('FinalizeMovie', mPtr);

% HideCursor();

% end