function startScript()
clc; clear all; close all;
%start GUI

%check whether there is a LogFiles folder on the same level as the
%experiment folder
try
    global trigger;
    setupTrigger();
    currentBlock = 1;
    rStyleDefault = 1;
       
    while(true)
        if currentBlock>5
            break
        end
        if currentBlock<=6
            rStyle = rStyleDefault;
        else
            rStyle = -1*rStyleDefault;
        end
        currentBlock = runExp(currentBlock, rStyle); % baseline: block 0; experiment: block 1
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