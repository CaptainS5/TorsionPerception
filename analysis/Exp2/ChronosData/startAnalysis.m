clear all;
close all;

try
    load('standardPaths.mat');
catch %#ok<CTCH>
    standardPaths.log = '';
    standardPaths.data = '';
    save('standardPaths.mat','standardPaths');    
end

sampleRate = 200; %fps

%Figure to select Log file
fig = figure('Visible','on','Name','Select Files',...
    'Menu', 'none', 'Position',[300,300,600,280]);

%Setup GUI to select Log file
path = fullfile(standardPaths.log);
stringCellsLogFiles = readFilesInPath(path);


%Setup GUI to select Data file
path = fullfile(standardPaths.data);
stringCellsDataFiles  = readFilesInPath(path);


%ListBox to select Log file
uicontrol(fig, 'Style','text','String','Log Files', 'Position',[20 245 250 20],'backgroundcolor',get(fig,'color'), 'HorizontalAlignment','left');
uicontrol(fig, 'Style','text','String','Data Files', 'Position',[280 245 250 20],'backgroundcolor',get(fig,'color'), 'HorizontalAlignment','left');
listboxLogFiles = uicontrol(fig,'Style','listbox',...
    'String',stringCellsLogFiles,...
    'Max',1,'Min',0,...
    'Position',[20 50 250 200]);
%ListBox to select Data file
listboxDataFiles = uicontrol(fig,'Style','listbox',...
    'String',stringCellsDataFiles,...
    'Max',99,'Min',0,...
    'Position',[280 50 250 200]);


assignin('base', 'listboxLogFiles', listboxLogFiles);
assignin('base', 'listboxDataFiles', listboxDataFiles);

buttons.startButton = uicontrol(fig,'string','start','Position',[540,50,60,30],'callback',...
    'selectedLogFile = readListBoxSelection(listboxLogFiles);selectedDataFile = readListBoxSelection(listboxDataFiles);selectedBlock = str2num(selectedLogFile{1}(9:10));runManualAnalysis;');

buttons.autoButton = uicontrol(fig,'string','auto','Position',[540,100,60,30],'callback',...
    'selectedLogFile = readListBoxSelection(listboxLogFiles);selectedDataFiles = readListBoxSelection(listboxDataFiles);runAutoAnalysis;');

buttons.cdLogButton = uicontrol(fig,'string','change folder','Position',[20,15,100,30],'callback',...
    'selectedPath = uigetdir; standardPaths.log = selectedPath; save(''standardPaths.mat'',''standardPaths''); set(listboxLogFiles,''String'',readFilesInPath(selectedPath))');
buttons.cdDataButton = uicontrol(fig,'string','change folder','Position',[280,15,100,30],'callback',...
    'selectedPath = uigetdir; standardPaths.data = selectedPath; save(''standardPaths.mat'',''standardPaths''); set(listboxDataFiles,''String'',readFilesInPath(selectedPath))');

clear i;
clear path;
clear dataFiles;
clear stringCellsDataFiles;
clear stringCellsLogFiles;