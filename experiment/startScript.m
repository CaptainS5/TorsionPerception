function startScript()
clc; clear all; close all;
%start GUI

%check whether there is a LogFiles folder on the same level as the
%experiment folder
try
    global trigger info prm
    setupTrigger();
    currentBlock = 1;
    rStyleDefault = -1; 
    expTyp = 0;
    eyeTracker = 1;
    prm.headTilt = [-1 -1 0 0]; % in this exact order
       
    while(true)
        if currentBlock>6
            break
        end
        if currentBlock<=2
            rStyle = rStyleDefault;
        else
            rStyle = -1*rStyleDefault;
        end
        currentBlock = runExp(currentBlock, rStyle, expTyp, eyeTracker); % baseline: block 0; experiment: block 1
        if expTyp==0
            expTyp = 3;
%             if expTyp==0 || expTyp==0.5
%                 eyeTracker = 1;
%             end
        elseif expTyp==3
            expTyp = 0;
        end
        %         resetTriggerGUI; % what's this?
        trigger.stopRecording();
    end
catch ME
    trigger.stopRecording();
    disp('Error in startScript');
    disp(ME.message);
    clear all;
    return;
end
end

function setupTrigger()
global trigger;
trigger = sendSerial(struct('name','com3','openNow',0));
trigger = sendSerial(struct('name','com3','openNow',1));
trigger.stopRecording();
end
%