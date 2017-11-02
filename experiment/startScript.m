function startScript()
clear;
%start GUI

%check whether there is a LogFiles folder on the same level as the
%experiment folder
try
    dir(pwd,'..','LogFiles');
catch
    disp('');
    disp('WARNING: There is no LogFiles folder on the same level as the experiment folder.');
    disp('Log files will not be saved. Press a button to continue.');
    input('Press ENTER to continue.')
end


try
    global trigger;
    setupTrigger();
    while(true)
%         output = rotationSettingsGUI();
        runExp();
        resetTriggerGUI;
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