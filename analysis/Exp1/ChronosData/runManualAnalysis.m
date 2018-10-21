%Setup main analysis window
screenSize = get(0,'ScreenSize');
close all;
fig = figure('Position', [10 10 screenSize(3), screenSize(4)],'Name','Main Analysis Window');

block = selectedBlock;
selectedLogFile = selectedLogFile{1};
currentTrial = 1;

% executed once per block
[header, logData] = readLogFile(block, selectedLogFile, standardPaths.log);
data = readDataFile(selectedDataFile{1}, standardPaths.data);
data = socscalexy(data);


% executed for each trial
analyzeTrial;

% manual error selection
if data.eye == 1
    selectedEye = 'L';
else
    selectedEye = 'R';
end
%errorFilePath = fullfile(standardPaths.log,'ErrorFiles\');
errorFilePath = fullfile(pwd,'ErrorFiles\');

if exist(errorFilePath, 'dir') == 0
  % Make folder if it does not exist.
  mkdir(errorFilePath);
end

errorFileName = [errorFilePath 'Exp' num2str(header.experiment) '_Subject' num2str(header.subjectID,'%.2i') '_Block' num2str(block,'%.2i') '_' selectedEye '_errorFile.mat'];



try
    load(errorFileName);
    disp('Error file loaded');
catch  %#ok<CTCH>
    errorStatus = NaN(header.trialsPerBlock,1);
    disp('No error file found. Created a new one.');
end


plotResults;

buttons.previous = uicontrol(fig,'string','<< Previous','Position',[0,70,100,30],...
    'callback','currentTrial = max(currentTrial-1,1);analyzeTrial;plotResults;');
buttons.exitAndSave = uicontrol(fig,'string','Exit & Save','Position',[0,35,100,30],...
    'callback', 'close(fig);save(errorFileName,''errorStatus'');');


buttons.totalError = uicontrol(fig,'string','Total Error (3) >>','Position',[0,220,100,30],...
    'callback','errorStatus(currentTrial)=3;currentTrial = currentTrial+1;analyzeTrial;plotResults;');
buttons.torsionError = uicontrol(fig,'string','Torsion Error (2) >>','Position',[0,185,100,30],...
    'callback','errorStatus(currentTrial)=2;currentTrial = currentTrial+1;analyzeTrial;plotResults;');
buttons.pursuitError = uicontrol(fig,'string','Pursuit Error (1) >>','Position',[0,150,100,30],...
    'callback','errorStatus(currentTrial)=1;currentTrial = currentTrial+1;analyzeTrial;plotResults;');
buttons.next = uicontrol(fig,'string','Next (0) >>','Position',[0,105,100,30],...
    'callback','errorStatus(currentTrial)=0;currentTrial = currentTrial+1;analyzeTrial;plotResults;');

buttons.jumpToTrialn = uicontrol(fig,'string','Jump to trial..','Position',[120,35,70,30],...
    'callback','inputTrial = inputdlg(''Go to trial:'');currentTrial = str2num(inputTrial{:});analyzeTrial;plotResults;');

buttons.exit = uicontrol(fig,'string','Exit','Position',[210,35,70,30],...
    'callback','close(fig);');





assignin('base', 'buttons', buttons);

clear listboxDataFiles;
clear listboxLogFiles;
clear e;
clear selectedBlock;
clear block;

while 1
    
    w = waitforbuttonpress;
    if w %Key press
        figure(fig)  %focus on figure
        
        key = get(gcf,'CurrentKey');
       
        if strcmp(key,'numpad0') || strcmp(key,'0')
            errorStatus(currentTrial)=0;
            currentTrial = min(currentTrial+1,header.trialsPerBlock);
            analyzeTrial;
            plotResults;
        elseif strcmp(key,'numpad1') || strcmp(key,'1')
            errorStatus(currentTrial)=1;
            currentTrial = min(currentTrial+1,header.trialsPerBlock);
            analyzeTrial;
            plotResults;
        elseif strcmp(key,'numpad2') || strcmp(key,'2')
            errorStatus(currentTrial)=2;
            currentTrial = min(currentTrial+1,header.trialsPerBlock);
            analyzeTrial;
            plotResults;
        elseif strcmp(key,'numpad3') || strcmp(key,'3')
            errorStatus(currentTrial)=3;
            currentTrial = min(currentTrial+1,header.trialsPerBlock);
            analyzeTrial;
            plotResults;
        elseif strcmp(key,'backspace')
            currentTrial = max(currentTrial-1,1);
            analyzeTrial;
            plotResults;
        elseif strcmp(key,'return')
            save(errorFileName,'errorStatus');
            close(fig);
            break;
        elseif strcmp(key,'escape')
            close(fig);
            break;
        elseif strcmp(key,'f12')
            break;
        end

    end
    
    
    
    
end

