function varargout = resetTriggerGUI(varargin)


% RESETTRIGGERGUI MATLAB code for resetTriggerGUI.fig
%      RESETTRIGGERGUI, by itself, creates a new RESETTRIGGERGUI or raises the existing
%      singleton*.
%
%      H = RESETTRIGGERGUI returns the handle to a new RESETTRIGGERGUI or the handle to
%      the existing singleton*.
%
%      RESETTRIGGERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESETTRIGGERGUI.M with the given input arguments.
%
%      RESETTRIGGERGUI('Property','Value',...) creates a new RESETTRIGGERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resetTriggerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resetTriggerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resetTriggerGUI

% Last Modified by GUIDE v2.5 03-Jul-2012 17:10:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @resetTriggerGUI_OpeningFcn, ...
    'gui_OutputFcn',  @resetTriggerGUI_OutputFcn, ...
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



% --- Executes just before resetTriggerGUI is made visible.
function resetTriggerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resetTriggerGUI (see VARARGIN)

% Choose default command line output for resetTriggerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes resetTriggerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resetTriggerGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ok_button.
function ok_button_Callback(hObject, eventdata, handles)
% hObject    handle to ok_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global trigger;
trigger.startRecording();
delete(handles.figure1);

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
