function varargout = rotationSettingsGUI(varargin)
% ROTATIONSETTINGSGUI MATLAB code for rotationSettingsGUI.fig
%      ROTATIONSETTINGSGUI, by itself, creates a new ROTATIONSETTINGSGUI or raises the existing
%      singleton*.
%
%      H = ROTATIONSETTINGSGUI returns the handle to a new ROTATIONSETTINGSGUI or the handle to
%      the existing singleton*.
%
%      ROTATIONSETTINGSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROTATIONSETTINGSGUI.M with the given input arguments.
%
%      ROTATIONSETTINGSGUI('Property','Value',...) creates a new ROTATIONSETTINGSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rotationSettingsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rotationSettingsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rotationSettingsGUI

% Last Modified by GUIDE v2.5 07-Aug-2015 23:15:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @rotationSettingsGUI_OpeningFcn, ...
    'gui_OutputFcn',  @rotationSettingsGUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


% End initialization code - DO NOT EDIT

% --- Executes just before rotationSettingsGUI is made visible.
function rotationSettingsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rotationSettingsGUI (see VARARGIN)

% Not tested with multiple screens

try
    restoreState(handles);
    updateRotationStatistics(handles);
    updateResultInTrials(handles);
catch ME
    disp('State could not be restored');
end


%Enable second screen radio button if second screen was detected
if(max(Screen('Screens')) > 0)
    set(handles.secondary_radio,'Enable','on');
else
    set(handles.primary_radio,'Value',1);
    set(handles.secondary_radio,'Value',0);
end



% Choose default command line output for rotationSettingsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes rotationSettingsGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = rotationSettingsGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;


% The figure can be deleted now
delete(handles.figure1);


function horizontalSpeed_edit_Callback(hObject, eventdata, handles)
% hObject    handle to horizontalSpeed_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of horizontalSpeed_edit as text
%        str2double(get(hObject,'String')) returns contents of horizontalSpeed_edit as a double
checkValues(handles.horizontalSpeed_edit, 0, 500, 10, 1);
updateRotationStatistics(handles);

% --- Executes during object creation, after setting all properties.
function horizontalSpeed_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to horizontalSpeed_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotationalSpeed_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rotationalSpeed_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotationalSpeed_edit as text
%        str2double(get(hObject,'String')) returns contents of rotationalSpeed_edit as a double
if(isnan(str2double(get(handles.rotationalSpeed_edit, 'String'))))
    set(handles.rotationalSpeed_edit, 'String', '0');
end
if(str2double(get(handles.rotationalSpeed_edit, 'String'))>720)
    set(handles.rotationalSpeed_edit, 'String', '720');
end
if(str2double(get(handles.rotationalSpeed_edit, 'String'))<-720)
    set(handles.rotationalSpeed_edit, 'String', '-720');
end
currentValue = str2double(get(handles.rotationalSpeed_edit, 'String'));
currentValue = round(currentValue);
set(handles.rotationalSpeed_edit, 'String',num2str(currentValue));

updateRotationStatistics(handles);

% --- Executes during object creation, after setting all properties.
function rotationalSpeed_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotationalSpeed_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = cell(30, 1);
handles.output{1} = str2double(get(handles.horizontalSpeed_edit, 'String')); %horizontalSpeed
handles.output{2} = str2double(get(handles.rotationalSpeed_edit, 'String')); %rotationalSpeed
handles.output{3} = str2double(get(handles.diameter_edit, 'String')); %circleDiameter
handles.output{4} = str2double(get(handles.dotsDiameter_edit, 'String')); %dotsDiameter
handles.output{5} = str2double(get(handles.dotsNumber_edit, 'String')); %dotsNumber
handles.output{6} = str2double(get(handles.screenWidth_edit, 'String')); %screenWidth
handles.output{7} = str2double(get(handles.screenDistance_edit, 'String')); %screenDistance
handles.output{8} = str2double(get(handles.numberRuns_edit, 'String')); %numberOfRuns
handles.output{9} = str2double(get(handles.blockNumber_edit, 'String')); %blockNumber
handles.output{10} = get(handles.showDecision_check, 'Value'); %showDecision
handles.output{11} = get(handles.initials_edit, 'String'); %subjectInitials
handles.output{12} = get(handles.lifetime_check, 'Value'); %limitedLifetime
handles.output{13} = get(handles.showOutline_check, 'Value'); %showOutline
handles.output{14} = str2double(get(handles.lifetime_edit, 'String')); %lifetime
handles.output{15} = get(handles.horizontal_radio, 'Value'); %horizontalOrVertical
handles.output{16} = get(handles.primary_radio, 'Value'); %primaryOrSecondary
handles.output{17} = str2double(get(handles.duration_edit, 'String')); %duration
handles.output{18} = str2double(get(handles.multiplier_edit, 'String')); %multiplier
handles.output{19} = str2double(get(handles.screenHeight_edit, 'String')); %screenHeight
handles.output{20} = get(handles.demo_check, 'Value'); %demo
handles.output{21} = getSpeedLevels(handles); %speedLevels
handles.output{22} = get(handles.saccades_check, 'Value'); %showSaccades (Listing Fixation)
handles.output{23} = get(handles.subjectID_edit, 'String'); %subjectID
handles.output{24} = get(handles.experimentID_edit, 'String'); %experimentID
handles.output{25} = get(handles.experiment_edit, 'String'); %experiment
handles.output{26} = get(handles.baseline_check, 'Value'); %showBaseline
handles.output{27} = get(handles.torsion_check, 'Value'); %showTorsion
handles.output{28} = get(handles.circle_check, 'Value'); %circleBaseline
handles.output{29} = get(handles.dot_check, 'Value'); %dotBaseline
handles.output{30} = getSpeedLevelsUn(handles); %speedLevelsUnnatural

% Update handles structure
guidata(hObject, handles);

% Use UIRESUME instead of delete because the OutputFcn needs
% to get the updated handles structure.
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.figure1);

% delete(hObject);




function diameter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to diameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diameter_edit as text
%        str2double(get(hObject,'String')) returns contents of diameter_edit as a double
if(isnan(str2double(get(handles.diameter_edit, 'String'))))
    set(handles.diameter_edit, 'String', '0');
end
if(str2double(get(handles.diameter_edit, 'String'))>20)
    set(handles.diameter_edit, 'String', '20');
end
if(str2double(get(handles.diameter_edit, 'String'))<0)
    set(handles.diameter_edit, 'String', '0');
end
currentValue = str2double(get(handles.diameter_edit, 'String'));
currentValue = round(currentValue*10)/10;
set(handles.diameter_edit, 'String',num2str(currentValue));

updateRotationStatistics(handles);

% --- Executes during object creation, after setting all properties.
function diameter_edit_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



function dotsDiameter_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dotsDiameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dotsDiameter_edit as text
%        str2double(get(hObject,'String')) returns contents of dotsDiameter_edit as a double
checkValues(handles.dotsDiameter_edit, 0, 1, 0, 2);

% --- Executes during object creation, after setting all properties.
function dotsDiameter_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dotsDiameter_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dotsNumber_edit_Callback(hObject, eventdata, handles)
% hObject    handle to dotsNumber_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dotsNumber_edit as text
%        str2double(get(hObject,'String')) returns contents of dotsNumber_edit as a double
checkValues(handles.dotsNumber_edit, 0, 500, 100, 0);

% --- Executes during object creation, after setting all properties.
function dotsNumber_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dotsNumber_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function screenWidth_edit_Callback(hObject, eventdata, handles)
% hObject    handle to screenWidth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of screenWidth_edit as text
%        str2double(get(hObject,'String')) returns contents of screenWidth_edit as a double
checkValues(handles.screenWidth_edit, 0, 100, 50, 1);


% --- Executes during object creation, after setting all properties.
function screenWidth_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to screenWidth_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function screenDistance_edit_Callback(hObject, eventdata, handles)
% hObject    handle to screenDistance_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of screenDistance_edit as text
%        str2double(get(hObject,'String')) returns contents of screenDistance_edit as a double
checkValues(handles.screenDistance_edit, 0, 100, 50, 1);

% --- Executes during object creation, after setting all properties.
function screenDistance_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to screenDistance_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function numberRuns_edit_Callback(hObject, eventdata, handles)
% hObject    handle to numberRuns_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberRuns_edit as text
%        str2double(get(hObject,'String')) returns contents of numberRuns_edit as a double
checkValues(handles.numberRuns_edit, 0, 100, 5, 0);
updateResultInTrials(handles)

% --- Executes during object creation, after setting all properties.
function numberRuns_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberRuns_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startBlock_edit_Callback(hObject, eventdata, handles)
% hObject    handle to startBlock_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startBlock_edit as text
%        str2double(get(hObject,'String')) returns contents of startBlock_edit as a double
checkValues(handles.startBlock_edit, 0, 10, 1, 0);

% --- Executes during object creation, after setting all properties.
function startBlock_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startBlock_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initials_edit_Callback(hObject, eventdata, handles)
% hObject    handle to initials_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initials_edit as text
%        str2double(get(hObject,'String')) returns contents of initials_edit as a double


% --- Executes during object creation, after setting all properties.
function initials_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initials_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subjectID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to subjectID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subjectID_edit as text
%        str2double(get(hObject,'String')) returns contents of subjectID_edit as a double


% --- Executes during object creation, after setting all properties.
function subjectID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subjectID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in lifetime_check.
function lifetime_check_Callback(hObject, eventdata, handles)
% hObject    handle to lifetime_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lifetime_check

if(get(handles.lifetime_check, 'Value')==1)
    set(handles.lifetime_label,'Enable','on');
    set(handles.lifetime_edit,'Enable','on');
    set(handles.lifetime_unit,'Enable','on');
else
    set(handles.lifetime_label,'Enable','off');
    set(handles.lifetime_edit,'Enable','off');
    set(handles.lifetime_unit,'Enable','off');
end

% --- Executes on button press in showOutline_check.
function showOutline_check_Callback(hObject, eventdata, handles)
% hObject    handle to showOutline_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showOutline_check



function lifetime_edit_Callback(hObject, eventdata, handles)
% hObject    handle to lifetime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lifetime_edit as text
%        str2double(get(hObject,'String')) returns contents of lifetime_edit as a double
checkValues(handles.lifetime_edit, 0, 10000, 100, 0);

% --- Executes during object creation, after setting all properties.
function lifetime_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lifetime_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in horizontal_radio.
function horizontal_radio_Callback(hObject, eventdata, handles)
% hObject    handle to horizontal_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of horizontal_radio
if(get(handles.horizontal_radio, 'Value') == 1)
    set(handles.vertical_radio, 'Value',0);
else
    set(handles.horizontal_radio, 'Value',1);
end



% --- Executes on button press in vertical_radio.
function vertical_radio_Callback(hObject, eventdata, handles)
% hObject    handle to vertical_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vertical_radio
if(get(handles.vertical_radio, 'Value') == 1)
    set(handles.horizontal_radio, 'Value',0);
else
    set(handles.vertical_radio, 'Value',1);
end

function saveState(handles)

% Circle Settings
state.diameter = get(handles.diameter_edit, 'String');
state.horizontalSpeed = get(handles.horizontalSpeed_edit, 'String');
state.rotationalSpeed = get(handles.rotationalSpeed_edit, 'String');
state.rotationLevels = get(handles.rotationLevels_edit, 'String');
state.rotationLevelsUn = get(handles.rotationLevelsUn_edit, 'String');
state.duration = get(handles.duration_edit, 'String');
state.multiplier = get(handles.multiplier_edit, 'String');
state.showOutline = get(handles.showOutline_check, 'Value');

% Dot settings
state.dotsDiameter = get(handles.dotsDiameter_edit, 'String');
state.dotsNumber = get(handles.dotsNumber_edit, 'String');
state.lifetime = get(handles.lifetime_edit, 'String');
state.limitedLifetime = get(handles.lifetime_check, 'Value');

% Display settings
state.screenWidth = get(handles.screenWidth_edit, 'String');
state.screenHeight = get(handles.screenHeight_edit, 'String');
state.distanceToScreen = get(handles.screenDistance_edit, 'String');
state.primary = get(handles.primary_radio, 'Value');
state.secondary = get(handles.secondary_radio, 'Value');

% Subject details
state.initials = get(handles.initials_edit, 'String');
state.subjectID = get(handles.subjectID_edit, 'String');
state.experimentID = get(handles.experimentID_edit, 'String');
state.experiment = get(handles.experiment_edit, 'String');

% Translation
state.horizontal = get(handles.horizontal_radio, 'Value');
state.vertical = get(handles.vertical_radio, 'Value');

% Trial details
state.numberTrials = get(handles.numberRuns_edit, 'String');
state.blockNumber = get(handles.blockNumber_edit, 'String');
state.calibration = get(handles.saccades_check, 'Value');
state.showDecision = get(handles.showDecision_check, 'Value');
state.showBaseline = get(handles.baseline_check, 'Value');
state.circle = get(handles.circle_check, 'Value');
state.dot = get(handles.dot_check, 'Value');
state.showTorsion = get(handles.torsion_check, 'Value');
state.demo = get(handles.demo_check, 'Value');

confirm = confirmGUI;


if(confirm{1})
    save state.mat state;
    disp('State saved');
end

function restoreState(handles)

load 'state.mat' 'state';

% Circle Settings
set(handles.diameter_edit, 'String', state.diameter);
set(handles.horizontalSpeed_edit, 'String', state.horizontalSpeed);
set(handles.rotationalSpeed_edit, 'String', state.rotationalSpeed);
set(handles.rotationLevels_edit, 'String', state.rotationLevels);
set(handles.rotationLevelsUn_edit, 'String', state.rotationLevelsUn);
set(handles.duration_edit, 'String', state.duration);
set(handles.multiplier_edit, 'String', state.multiplier);
set(handles.showOutline_check, 'Value', state.showOutline);

% Dot settings
set(handles.dotsDiameter_edit, 'String', state.dotsDiameter);
set(handles.dotsNumber_edit, 'String', state.dotsNumber);
set(handles.lifetime_edit, 'String', state.lifetime);
set(handles.lifetime_check, 'Value', state.limitedLifetime);

% Display settings
set(handles.screenWidth_edit, 'String', state.screenWidth);
set(handles.screenHeight_edit, 'String', state.screenHeight);
set(handles.screenDistance_edit, 'String', state.distanceToScreen);
set(handles.primary_radio, 'Value', state.primary);
set(handles.secondary_radio, 'Value', state.secondary);


% Subject details
set(handles.initials_edit, 'String', state.initials);
set(handles.subjectID_edit, 'String', state.subjectID);
set(handles.experimentID_edit, 'String', state.experimentID);
set(handles.experiment_edit, 'String', state.experiment);

% Translation
set(handles.horizontal_radio, 'Value', state.horizontal);
set(handles.vertical_radio, 'Value', state.vertical);

% Trial details
set(handles.numberRuns_edit, 'String', state.numberTrials);
set(handles.blockNumber_edit, 'String', state.blockNumber);
set(handles.saccades_check, 'Value', state.calibration);
set(handles.showDecision_check, 'Value', state.showDecision);
set(handles.baseline_check, 'Value', state.showBaseline);
set(handles.circle_check, 'Value', state.circle);
set(handles.dot_check, 'Value', state.dot);
set(handles.torsion_check, 'Value', state.showTorsion);
set(handles.demo_check, 'Value', state.demo);

updateRotationStatistics(handles);



% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveState(handles);


% --- Executes on button press in restore_button.
function restore_button_Callback(hObject, eventdata, handles)
% hObject    handle to restore_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
restoreState(handles);
checkSpeedLevels(handles)


% --- Executes on button press in primary_radio.
function primary_radio_Callback(hObject, eventdata, handles)
% hObject    handle to primary_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of primary_radio
if(get(handles.primary_radio, 'Value') == 1)
    set(handles.secondary_radio, 'Value',0);
else
    set(handles.primary_radio, 'Value',1);
end


% --- Executes on button press in secondary_radio.
function secondary_radio_Callback(hObject, eventdata, handles)
% hObject    handle to secondary_radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of secondary_radio
if(get(handles.secondary_radio, 'Value') == 1)
    set(handles.primary_radio, 'Value',0);
else
    set(handles.secondary_radio, 'Value',1);
end


% --- Executes on button press in calibrate_button.
function calibrate_button_Callback(hObject, eventdata, handles)
% hObject    handle to calibrate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
screenWidth = str2double(get(handles.screenWidth_edit, 'String'));
screenHeight = str2double(get(handles.screenHeight_edit, 'String'));
screenDistance = str2double(get(handles.screenDistance_edit, 'String'));

primaryScreen = get(handles.primary_radio, 'Value'); %primaryOrSecondary

if(primaryScreen == 1)
    display.screen = max(max(Screen('Screens')-1),0);
else
    display.screen = max(Screen('Screens'));
end

[display.windowPointer, display.size] = Screen('OpenWindow',display.screen);

try
    
    startCalibration(screenWidth, screenHeight, screenDistance, display.windowPointer, display.size);
    Screen('CloseAll');
catch ME
    disp('Calibration interrupted.');
    disp(ME.message);
end


function duration_edit_Callback(hObject, eventdata, handles)
% hObject    handle to duration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of duration_edit as text
%        str2double(get(hObject,'String')) returns contents of duration_edit as a double
checkValues(handles.duration_edit, 500, 5000, 1600, 0);


% --- Executes during object creation, after setting all properties.
function duration_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to duration_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function multiplier_edit_Callback(hObject, eventdata, handles)
% hObject    handle to multiplier_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multiplier_edit as text
%        str2double(get(hObject,'String')) returns contents of multiplier_edit as a double
checkValues(handles.multiplier_edit, 0, 1, 0.25, 2);
updateRotationStatistics(handles);


% --- Executes during object creation, after setting all properties.
function multiplier_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multiplier_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function screenHeight_edit_Callback(hObject, eventdata, handles)
% hObject    handle to screenHeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of screenHeight_edit as text
%        str2double(get(hObject,'String')) returns contents of screenHeight_edit as a double
checkValues(handles.screenHeight_edit, 0, 100, 50, 1);

% --- Executes during object creation, after setting all properties.
function screenHeight_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to screenHeight_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in demo_button.
function demo_button_Callback(hObject, eventdata, handles)
% hObject    handle to demo_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in demo_check.
function demo_check_Callback(hObject, eventdata, handles)
% hObject    handle to demo_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of demo_check


% --- Executes on button press in restoreLUT_button.
function restoreLUT_button_Callback(hObject, eventdata, handles)
% hObject    handle to restoreLUT_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
screen = get(handles.primary_radio, 'Value');
if(screen == 1)
    screen = max(max(Screen('Screens')-1),0);
else
    screen = max(Screen('Screens'));
end
restoreLUT(screen);


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2



% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rotationLevels_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rotationLevels_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotationLevels_edit as text
%        str2double(get(hObject,'String')) returns contents of rotationLevels_edit as a double
checkSpeedLevels(handles);



% --- Executes during object creation, after setting all properties.
function rotationLevels_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotationLevels_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%returns an array of numbers from the speedLevel field
function speedLevels = getSpeedLevels(handles)
text = get(handles. rotationLevels_edit,'String');
speedLevels = strread(text, '%d', 'delimiter', ';');
speedLevels = speedLevels';

function speedLevelsUn = getSpeedLevelsUn(handles)
text = get(handles. rotationLevelsUn_edit,'String');
speedLevelsUn = strread(text, '%d', 'delimiter', ';');
speedLevelsUn = speedLevelsUn';

%checks whether the String in the speedLevel field can be converted to
%numbers
function checkSpeedLevels(handles)
updateResultInTrials(handles);
try
    text = get(handles. rotationLevels_edit,'String');
    levels = strread(text, '%d', 'delimiter', ';');
    set(handles.start_button,'Enable','on');
    set(handles.rotationLevels_edit,'BackgroundColor', [1 1 1]);
    set(handles.rotationLevels_edit,'ForegroundColor', [0 0 0]);
    updateRotationStatistics(handles);
    text = get(handles. rotationLevelsUn_edit,'String');
    levels = strread(text, '%d', 'delimiter', ';');
    set(handles.start_button,'Enable','on');
    set(handles.rotationLevels_edit,'BackgroundColor', [1 1 1]);
    set(handles.rotationLevels_edit,'ForegroundColor', [0 0 0]);
    updateRotationStatistics(handles);
catch
    set(handles.start_button,'Enable','off');
    set(handles.rotationLevels_edit,'BackgroundColor', [0.7 0 0]);
    set(handles.rotationLevels_edit,'ForegroundColor', [1 1 1]);
end

function updateRotationStatistics(handles)

speedLevels = getSpeedLevels(handles);
speed = str2double(get(handles.rotationalSpeed_edit, 'String'));
multiplier = str2double(get(handles.multiplier_edit, 'String'));
min = (1+speedLevels(1)* multiplier/100)*speed;
max = (1+speedLevels(length(speedLevels))* multiplier/100)*speed;
minString = num2str(min);
maxString = num2str(max);
set(handles.currentSpeed_text,'String', [minString ' ~ ' maxString]);

radius = str2double(get(handles.diameter_edit, 'String'))/2;
circumference = 2 * pi * radius;
horizontalSpeed = str2double(get(handles.horizontalSpeed_edit, 'String'));
ratio = horizontalSpeed/circumference;
naturalSpeed = ceil(ratio *360);
set(handles.naturalSpeed_text,'String', naturalSpeed);


% --- Executes on button press in saccades_check.
function saccades_check_Callback(hObject, eventdata, handles)
    checkBlockSelection(handles);
% hObject    handle to saccades_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of saccades_check

% --- Executes on button press in torsion_check.
function torsion_check_Callback(hObject, eventdata, handles)
    checkBlockSelection(handles);
% hObject    handle to saccades_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of torsion_check


function blockNumber_edit_Callback(hObject, eventdata, handles)
% hObject    handle to blockNumber_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blockNumber_edit as text
%        str2double(get(hObject,'String')) returns contents of blockNumber_edit as a double
checkValues(handles.blockNumber_edit, 1, 10, 1, 0);


% --- Executes during object creation, after setting all properties.
function blockNumber_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blockNumber_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showDecision_check.
function showDecision_check_Callback(hObject, eventdata, handles)
% hObject    handle to showDecision_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showDecision_check

function updateResultInTrials(handles)
    speedLevel = getSpeedLevels(handles);
    numberOfSpeedLevel = length(speedLevel);
    numberOfTrialsPerCondition = str2double(get(handles.numberRuns_edit, 'String'));
    numberOfTrials = 2 * 2 * numberOfSpeedLevel * numberOfTrialsPerCondition; %translationalDirection/rotationalDirection/speedLevels/trialdPercondition
    numberString = num2str(numberOfTrials);
    set(handles.resultInTrials_text,'String', ['Results in ' numberString ' trials.']);
    



function experimentID_edit_Callback(hObject, eventdata, handles)
% hObject    handle to experimentID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of experimentID_edit as text
%        str2double(get(hObject,'String')) returns contents of experimentID_edit as a double


% --- Executes during object creation, after setting all properties.
function experimentID_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to experimentID_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function experiment_edit_Callback(hObject, eventdata, handles)
% hObject    handle to experiment_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of experiment_edit as text
%        str2double(get(hObject,'String')) returns contents of experiment_edit as a double


% --- Executes during object creation, after setting all properties.
function experiment_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to experiment_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in baseline_check.
function baseline_check_Callback(hObject, eventdata, handles)
    checkBlockSelection(handles);
    checkBaselineSelection(handles);
% hObject    handle to baseline_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of baseline_check

% --- Executes on button press in circle_check.
function circle_check_Callback(hObject, eventdata, handles)
    checkBlockSelection(handles)
    checkBaselineSelection(handles);
% hObject    handle to circle_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of circle_check

% --- Executes on button press in dot_check.
function dot_check_Callback(hObject, eventdata, handles)
    checkBlockSelection(handles)
    checkBaselineSelection(handles);
% hObject    handle to circle_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dot_check

function checkBlockSelection(handles)
    if get(handles.saccades_check, 'Value') + get(handles.baseline_check, 'Value') + get(handles.torsion_check, 'Value') ~= 1
       set(handles.warning_text,'visible','on');
      
    else
        set(handles.warning_text,'visible','off');
        
    end
    
    
    function checkBaselineSelection(handles)
        if get(handles.baseline_check, 'Value') == 1
            
            if get(handles.circle_check, 'Value') + get(handles.dot_check, 'Value') ~= 1
                set(handles.warning2_text,'visible','on');
               
            else
                set(handles.warning2_text,'visible','off');
               
            end
        end
    



function rotationLevelsUn_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rotationLevelsUn_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rotationLevelsUn_edit as text
%        str2double(get(hObject,'String')) returns contents of rotationLevelsUn_edit as a double
checkSpeedLevels(handles);


% --- Executes during object creation, after setting all properties.
function rotationLevelsUn_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rotationLevelsUn_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
