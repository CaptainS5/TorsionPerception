function currentBlock = runExp(currentBlock, rStyle, expTyp, eyeTracker)
% clear all; close all; clc; currentBlock=1; rStyle = -1; expTyp = 0.5; eyeTracker=0;% debugging
try
    %     clc; clear all; close all; % don't clear the trigger already set up
    global trigger
    global prm display resp info
    % prm--parameters, mostly defined in setParameters
    % display--all parameters (some pre-arranged) in the experiment, each block,
    % trial by trial
    % resp--the response, each block, trial by trial, what actually was
    % presented, including trials with invalid response/loss of fixation etc.
    addpath(genpath(pwd))
    AssertOpenGL;
    
    setParameters;
    prm.pwd = pwd;
    info = getInfo(currentBlock, rStyle, expTyp, eyeTracker);
    if info.expType>=1
        currentBlock = currentBlock + 1;
    end
    
    % creating saving path and filenames
    if info.expType==-1 % for baseline perception
        prm.rotation.freq = [2 4 8 12 16]; % the angle of the flash...
        
        prm.blockN = 1; % total number of blocks
        prm.trialPerCondition = 6; % trial number per condition
        prm.conditionN = length(prm.grating.outerRadius)*length(prm.flash.onsetInterval)* ...
    length(prm.flash.displacement)*length(prm.rotation.initialDirection)* ...
    length(prm.rotation.freq);
        prm.trialPerBlock = prm.trialPerCondition*prm.conditionN/prm.blockN;
                
        prm.fileName.folder = ['data\', info.subID{1}, '\baseline'];
    elseif info.expType==-0.5 % baseline perception for control
        prm.flash.displacement = [-1 1]; % -1, left side follow the assigned initial direction; 1, right side follow the assigned initial direction
        prm.flash.eccentricity = 0.5; % distance between edge of grating and fixation, half the gap between the two gratings
        prm.rotation.freq = [2 8 16]; % the angle of the flash...
        
        prm.blockN = 1; % total number of blocks
        prm.conditionN = length(prm.grating.outerRadius)*length(prm.flash.onsetInterval)* ...
    length(prm.flash.displacement)*length(prm.rotation.initialDirection)* ...
    length(prm.rotation.freq);
        prm.trialPerCondition = 5; % trial number per condition
        prm.trialPerBlock = prm.trialPerCondition*prm.conditionN/prm.blockN;        

        prm.fileName.folder = ['data\', info.subID{1}, '\baseline'];
    elseif info.expType==0 % baseline of torsion
        prm.blockN = 1; % total number of blocks        
        prm.trialPerCondition = 5; % trial number per condition
        prm.trialPerBlock = prm.trialPerCondition*prm.conditionN/prm.blockN;
        prm.rotation.beforeDuration = 1; %90./prm.rotation.freq(3); % the baseline of rotation in one interval, s
        prm.rotation.afterDuration = 1;
        
        prm.fileName.folder = ['data\', info.subID{1}, '\baselineTorsion'];
    elseif info.expType==0.5 % baseline torsion for control
        prm.flash.displacement = [-1 1]; % -1, left side follow the assigned initial direction; 1, right side follow the assigned initial direction
        prm.flash.eccentricity = 0.5; % distance between edge of grating and fixation, half the gap between the two gratings
        
        prm.blockN = 1; % total number of blocks
        prm.conditionN = length(prm.grating.outerRadius)*length(prm.flash.onsetInterval)* ...
    length(prm.flash.displacement)*length(prm.rotation.initialDirection)* ...
    length(prm.rotation.freq);
        prm.trialPerCondition = 3; % trial number per condition
        prm.trialPerBlock = prm.trialPerCondition*prm.conditionN/prm.blockN;
        prm.rotation.beforeDuration = 1; %90./prm.rotation.freq(3); % the baseline of rotation in one interval, s
        prm.rotation.afterDuration = 1;

        prm.fileName.folder = ['data\', info.subID{1}, '\baselineTorsion'];
    elseif info.expType==1
        prm.fileName.folder = ['data\', info.subID{1}];
    elseif info.expType==1.5 % control, two peripheral stimuli
%         prm.grating.outerRadius = 23.6/2;
%         prm.flash.radius = 2.5/2;
        prm.flash.displacement = [-1 1]; % -1, left side follow the assigned initial direction; 1, right side follow the assigned initial direction
        prm.flash.eccentricity = 0.5; % distance between edge of grating and fixation, half the gap between the two gratings

        prm.blockN = 6;
        prm.conditionN = length(prm.grating.outerRadius)*length(prm.flash.onsetInterval)* ...
    length(prm.flash.displacement)*length(prm.rotation.initialDirection)* ...
    length(prm.rotation.freq);
        prm.trialPerCondition = 18; % 360 trials in total, 60 trials each block
        prm.trialPerBlock = prm.trialPerCondition*prm.conditionN/prm.blockN;
        
        prm.fileName.folder = ['data\', info.subID{1}];
    end
    mkdir(prm.fileName.folder)
    
    if info.block==1
        arrangeRandomization(info);
        save([prm.fileName.folder, '\Info_', info.fileNameTime], 'info')
    else
        load([prm.fileName.folder, '\randomAssignment_', info.subID{1}])
    end
    
    openScreen; % modify background color here
    % Gamma correction
    load('lut527.mat')
    % Make a backup copy of original LUT into origLUT.
    originalLUT=Screen('ReadNormalizedGammaTable', prm.screen.whichscreen);
    save('originalLUT.mat', 'originalLUT');
    Screen('LoadNormalizedGammaTable', prm.screen.windowPtr, lut527);
    
    % Key
    KbCheck;
    KbName('UnifyKeyNames');
    
    HideCursor;
    
    % allow transparency
    Screen('BlendFunction', prm.screen.windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    %     generate textures for the stimuli
    for ii = 1:size(prm.grating.outerRadius, 2)
        if info.expType>=0 % baseline torsion, experiment, or control
        % rotation stimuli
        imgGrating = generateRotationTexture(round(dva2pxl(prm.grating.outerRadius(ii))), ...
            round(dva2pxl(prm.grating.innerRadius)), prm.grating.freq, 0, prm.grating.contrast, prm.grating.averageLum);
        % outer radius, inner radius, frequency, phase, contrast, average luminance
        prm.grating.tex{ii} = Screen('MakeTexture', prm.screen.windowPtr, imgGrating);
        
        % flash dots, vertically aligned
        imgFlash = generateFlashTexture(round(dva2pxl(prm.grating.outerRadius(ii))), ...
            round(dva2pxl(prm.grating.innerRadius)), round(dva2pxl(prm.flash.radius)), ...
            prm.flash.colour, prm.flash.axis, imgGrating);
        % gratingOuterRadius, gratingInnerRadius, flashRadius, color
        % (RGB 0-255), axis (0-horizontal, 1-vertical)
        prm.flash.tex{ii} = Screen('MakeTexture', prm.screen.windowPtr, imgFlash);
        elseif info.expType<0 % baseline perception
            imgUniform = generateRespTexture(round(dva2pxl(prm.grating.outerRadius(ii))), ...
                0, 0, ...
                prm.flash.respColour, prm.flash.axis);
            % gratingOuterRadius, gratingInnerRadius, flashRadius, color (RGB 0-255)
            prm.baseline.uniformTex{ii} = Screen('MakeTexture', prm.screen.windowPtr, imgUniform);
        
            imgBaseFlash = generateRespTexture(round(dva2pxl(prm.grating.outerRadius(ii))), ...
                round(dva2pxl(prm.grating.innerRadius)), round(dva2pxl(prm.flash.radius)), ...
                prm.flash.colour, prm.flash.axis);
            % gratingOuterRadius, gratingInnerRadius, flashRadius, color (RGB 0-255)
            prm.baseline.flashTex{ii} = Screen('MakeTexture', prm.screen.windowPtr, imgBaseFlash);
        end
    end
    % texture for the adjustment response, initial position vertical
    imgResp = generateRespTexture(round(dva2pxl(prm.grating.outerRadius(ii))), ...
        round(dva2pxl(prm.grating.innerRadius)), round(dva2pxl(prm.flash.radius)), ...
        prm.flash.respColour, prm.flash.axis);
    % gratingOuterRadius, gratingInnerRadius, flashRadius, color (RGB 0-255)
    prm.resp.tex = Screen('MakeTexture', prm.screen.windowPtr, imgResp);
    
    prm.fixation.colour = prm.screen.whiteColour;
    % calculate angle per frame for display
    prm.rotation.anglePerFrame = prm.rotation.freq./prm.screen.refreshRate; % in degree
    % set up folders, files and running paras
    
    if strcmp(info.subID{1}, 'luminance')
        % testing monitor luminance
        Screen('FillRect', prm.screen.windowPtr, prm.grating.darkest); % fill background
        Screen('Flip', prm.screen.windowPtr);
        KbWait();
        clear KbCheck
        WaitSecs(0.2);
        
        Screen('FillRect', prm.screen.windowPtr, prm.grating.lightest); % fill background
        Screen('Flip', prm.screen.windowPtr);
        KbWait();
        %         clear KbCheck
        %         WaitSecs(0.2);
        
        %         Screen('FillRect', prm.screen.windowPtr, prm.flash.colour); % fill background
        %         Screen('Flip', prm.screen.windowPtr);
        %         KbWait();
    else
        % start the experiment
        %         for blockN = info.fromBlock:info.toBlock
        blockN = info.block;
        % setting up filenames
        prm.fileName.disp = [prm.fileName.folder, '\display', num2str(blockN), '_', info.fileNameTime];
        prm.fileName.resp = [prm.fileName.folder, '\response', num2str(blockN), '_', info.fileNameTime];
        % initialize the randomization that will be made in each trial
        %         display{blockN}.initialDirection = zeros(prm.trialPerBlock, 1);
        display{blockN}.initialAngle = zeros(prm.trialPerBlock, 1);
        display{blockN}.reversalAngle = zeros(prm.trialPerBlock, 1);
        display{blockN}.duration = zeros(prm.trialPerBlock, 1);
        % initialize the response
        resp = table(); % 1 = left, 2 = right
        
        trialN = 1; % the trial number to look up in random assignment
        tempN = 1; % number of trials presented so far
        trialMakeUp = [];
        makeUpN = 0;
        % calibration
        if info.eyeTracker==1
            try
                startCalibration(prm.screen.monitorWidth, prm.screen.monitorHeight,...
                    prm.screen.viewDistance, prm.screen.windowPtr, prm.screen.size);
            catch ME
                msgString = getReport(ME);
                disp(msgString);
                disp('Calibration interrupted.');
            end
        end
        HideCursor;
        % initial welcome
        textBlock = ['Block ', num2str(blockN)];
        Screen('DrawText', prm.screen.windowPtr, textBlock, prm.screen.center(1)-60, prm.screen.center(2), prm.screen.whiteColour);
        if info.reportStyle==-1
            reportInstruction = 'Report LOWER';
        elseif info.reportStyle==1
            reportInstruction = 'Report HIGHER';
        else
            reportStyle = 'Wrong! Get experimenter.'
        end
        %         Screen('DrawText', prm.screen.windowPtr, reportInstruction, prm.screen.center(1)-100, prm.screen.center(2)+50, prm.screen.whiteColour);
        Screen('Flip', prm.screen.windowPtr);
        %         KbWait();
        buttons = [];
        while ~any(buttons)
            [x, y, buttons, focus, valuators, valinfo] = GetMouse(prm.screen.windowPtr);
        end
        WaitSecs(prm.ITI);
        
        % run trials
        while tempN<=prm.trialPerBlock+makeUpN
            clear KbCheck
            if tempN>prm.trialPerBlock
                trialN = trialMakeUp(tempN-prm.trialPerBlock);
            end
            % present the stimuli and recording response
            [key rt] = runTrial(blockN, trialN, tempN); % display rotating grating and the flash
            % trialN is the index for looking up in display;
            % tempN is the actual trial number, including invalid trials
            %             if strcmp(key, 'LeftArrow')
            %             if strcmp(key, 'z') % counterclockwise
            %                 resp.choice(tempN, 1) = -1;
            %             elseif strcmp(key, '/') % clockwise
            %                 %             elseif strcmp(key, 'RightArrow')
            %                 resp.choice(tempN, 1) = 1;
            %                 %             elseif strcmp(key, 'void') % no response
            %                 %                 resp{blockN}.choice(trialN, 1) = 0;
            %             else % wrong key
            %                 resp.choice(tempN, 1) = 0;
            %                 % repeat this trial at the end of the block
            %                 makeUpN = makeUpN + 1;
            %                 trialMakeUp(makeUpN) = trialN;
            %                 % feedback on the screen
            %                 respText = 'Invalid Key';
            %                 Screen('DrawText', prm.screen.windowPtr, respText, prm.screen.center(1)-80, prm.screen.center(2), prm.screen.whiteColour);
            %             end
            resp.RTms(tempN, 1) = rt*1000; % in ms
            %             resp.trialIdx(tempN, 1) = trialN; % index for the condition used
            
            % replicate the display parameters for each trial
            %             resp.gratingRadiusIdx(tempN, 1) = display{blockN}.gratingRadiusIdx(trialN); % index of the grating stimulus outer radius
            resp.gratingRadius(tempN, 1) = prm.grating.outerRadius(display{blockN}.gratingRadiusIdx(trialN)); % actual value of the grating outer radius
            resp.flashOnset(tempN, 1) = display{blockN}.flashOnset(trialN);
            resp.targetSide(tempN, 1) = display{blockN}.flashDisplaceLeft(trialN);
            resp.initialDirection(tempN, 1) = display{blockN}.initialDirection(trialN);
            resp.initialAngle(tempN, 1) = display{blockN}.initialAngle(trialN);
            resp.reversalAngle(tempN, 1) = display{blockN}.reversalAngle(trialN);
            if fix(info.expType)~=info.expType
                resp.initialAngle2(tempN, 1) = display{blockN}.initialAngle2(trialN);
                resp.reversalAngle2(tempN, 1) = display{blockN}.reversalAngle2(trialN);
            end
            resp.durationBefore(tempN, 1) = display{blockN}.durationBefore(trialN);
            resp.durationAfter(tempN, 1) = display{blockN}.durationAfter(trialN);
            resp.rotationSpeed(tempN, 1) = display{blockN}.rotationSpeed(trialN);
            %             resp.sideDisplaced(tempN, 1) = display{blockN}.sideDisplaced(trialN);
            %             resp.reportStyle(tempN, 1) = info.reportStyle; % report lower or higher
            
            % save the response
            save(prm.fileName.disp, 'display');
            save(prm.fileName.resp, 'resp');
            
            trialN = trialN+1;
            tempN = tempN+1;
            
            % quit, only for debugging
            if strcmp(key, 'q')
                break
            end
            
            % ITI
            Screen('Flip', prm.screen.windowPtr);
            WaitSecs(prm.ITI);
        end
        %             % quit, only for debugging
        %             if strcmp(key, 'q')
        %                 break
        %             end
        %         end
    end
    prm.fileName.prm = [prm.fileName.folder, '\parameters_', info.fileNameTime];
    save(prm.fileName.prm, 'prm');
    
    % calibration again
    if info.eyeTracker==1
        try
            startCalibration(prm.screen.monitorWidth, prm.screen.monitorHeight,...
                prm.screen.viewDistance, prm.screen.windowPtr, prm.screen.size);
        catch ME
            msgString = getReport(ME);
            disp(msgString);
            disp('Calibration interrupted.');
        end
    end
    
    Screen('LoadNormalizedGammaTable', prm.screen.windowPtr, originalLUT);
    Screen('CloseAll')
    
catch expME
    if info.eyeTracker==1
        trigger.stopRecording();
    end
    disp('Error in runExp');
    disp(expME.message);
    Screen('LoadNormalizedGammaTable', prm.screen.windowPtr, originalLUT);
    Screen('CloseAll')
    %         rethrow(lasterror)
    %     clear all;
    return;
end
% end