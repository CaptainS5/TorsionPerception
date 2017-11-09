function runExp()

try
    %     clc; clear all; close all; % don't clear the trigger already set up
    global trigger
    global prm disp resp info
    % prm--parameters, mostly defined in setParameters
    % disp--all parameters (some pre-arranged) in the experiment, each block,
    % trial by trial
    % resp--the response, each block, trial by trial, what actually was
    % presented, including trials with invalid response/loss of fixation etc.
    addpath(genpath(pwd))
    AssertOpenGL;
    
    setParameters;
    prm.pwd = pwd;
    info = getInfo;
    
    % creating saving path and filenames
    if info.expType==0 % for baseline
        prm.blockN = 1; % total number of blocks
        prm.conditionN = length(prm.grating.outerRadius)*length(prm.flash.onsetInterval)*length(prm.flash.displacement); % total number of combinations of conditions
        % conditions differ in: radial stimulus size; flash onset interval;
        % flash displacement
        prm.trialPerCondition = 2; % trial number per condition
        prm.trialPerBlock = prm.trialPerCondition*prm.conditionN/prm.blockN;
        
        prm.fileName.folder = ['data\', info.subID{1}, '\baseline'];
    elseif info.expType==1
        prm.fileName.folder = ['data\', info.subID{1}];
    end
    mkdir(prm.fileName.folder)
    
    if info.block==1
        arrangeRandomization(info);
        save([prm.fileName.folder, '\Info_', info.fileNameTime], 'info')
    else
        load([prm.fileName.folder, '\randomAssignment_', info.subID{1}])
    end
    openScreen;
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
    
    %     generate texture for the rotating grating
    for ii = 1:size(prm.grating.outerRadius, 2)
        imgGrating = generateRotationGrating(round(dva2pxl(prm.grating.outerRadius(ii))), ...
            round(dva2pxl(prm.grating.innerRadius)), prm.grating.freq, 0, prm.grating.contrast, prm.grating.averageLum);
        % outer radius, inner radius, frequency, phase, contrast, average luminance
        prm.grating.tex{ii} = Screen('MakeTexture', prm.screen.windowPtr, imgGrating);
    end
    prm.fixation.colour = prm.grating.lightest;
    % calculate angle per frame for display
    prm.rotation.anglePerFrame = prm.rotation.freq*360/prm.screen.refreshRate; % in degree
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
        disp{blockN}.direction = zeros(prm.trialPerBlock, 1);
        disp{blockN}.initialAngle = zeros(prm.trialPerBlock, 1);
        disp{blockN}.duration = zeros(prm.trialPerBlock, 1);
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
        Screen('DrawText', prm.screen.windowPtr, reportInstruction, prm.screen.center(1)-100, prm.screen.center(2)+50, prm.screen.whiteColour);
        Screen('Flip', prm.screen.windowPtr);
        KbWait();
        WaitSecs(prm.ITI);
        
        % run trials
        while tempN<=prm.trialPerBlock+makeUpN
            clear KbCheck
            if tempN>prm.trialPerBlock
                trialN = trialMakeUp(tempN-prm.trialPerBlock);
            end
            % present the stimuli and recording response
            [key rt] = runTrial(blockN, trialN); % display rotating grating and the flash
            if strcmp(key, 'LeftArrow')
                resp.choice(tempN, 1) = -1;
            elseif strcmp(key, 'RightArrow')
                resp.choice(tempN, 1) = 1;
                %             elseif strcmp(key, 'void') % no response
                %                 resp{blockN}.choice(trialN, 1) = 0;
            else % wrong key
                resp.choice(tempN, 1) = 0;
                % repeat this trial at the end of the block
                makeUpN = makeUpN + 1;
                trialMakeUp(makeUpN) = trialN;
                % feedback on the screen
                respText = 'Wrong Key';
                Screen('DrawText', prm.screen.windowPtr, respText, prm.screen.center(1)-80, prm.screen.center(2), prm.screen.whiteColour);
            end
            resp.RTms(tempN, 1) = rt*1000; % in ms
            resp.trialIdx(tempN, 1) = trialN; % index for the condition used
            
            % replicate the display parameters for each trial
            resp.gratingRadiusIdx(tempN, 1) = disp{blockN}.gratingRadiusIdx(trialN); % index of the grating stimulus outer radius
            resp.flashOnset(tempN, 1) = disp{blockN}.flashOnset(trialN);
            resp.flashDisplaceLeft(tempN, 1) = disp{blockN}.flashDisplaceLeft(trialN);
            resp.initialDirection(tempN, 1) = disp{blockN}.initialDirection(trialN);
            resp.initialAngle(tempN, 1) = disp{blockN}.initialAngle(trialN);
            resp.duration(tempN, 1) = disp{blockN}.duration(trialN);
            resp.sideDisplaced(tempN, 1) = disp{blockN}.sideDisplaced(trialN);
            resp.reportStyle(tempN, 1) = info.reportStyle; % report lower or higher
            
            % save the response
            save(prm.fileName.disp, 'disp');
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
    clear all;
    return;
end
end