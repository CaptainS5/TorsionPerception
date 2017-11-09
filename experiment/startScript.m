function startScript()
clc; clear all; close all;
%start GUI

%check whether there is a LogFiles folder on the same level as the
%experiment folder
try
    global trigger;
    setupTrigger();
    while(true)
        runExp();
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