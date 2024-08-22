function varargout = gui(varargin)


% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 21-Jun-2024 22:48:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in modulate.
function mode_flag=modulate_Callback(hObject, eventdata, handles)
% hObject    handle to modulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns modulate contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modulate

mode_flag = get(handles.modulate,'value');
% siso = get(handles.siso,'value');
% mimo = get(handles.mimo,'value');
% delaystring = get(handles.kongkoushiyan, 'String');
% delayValues = str2double(strsplit(delaystring, ','));  
% visual_flag = get(handles.visual,'value');
% confirm= get(handles.check,'value');
%     % 验证输入是否为数字  
%     if any(isnan(delayValues))  
%         error('请输入有效的数字，用逗号分隔。');  
%     end  

%mode_flag=1的时候，实际上就是默认选项的值，也就是弹出式菜单这个选项的值。mode_flag=2开始才是真正要选的选项的值，这一点很容易出错，要记住。

% %display(mode_flag)
% %display(mimo)
% %display(siso)
% %display(delayValues)
% %display(visual_flag)
% %display(confirm)
% --- Executes during object creation, after setting all properties.
function modulate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%设置时延的callback函数
function delayValues=kongkoushiyan_Callback(hObject, eventdata, handles)
% hObject    handle to kongkoushiyan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kongkoushiyan as text
%        str2double(get(hObject,'String')) returns contents of kongkoushiyan as a double

delaystring = get(handles.kongkoushiyan, 'String');
delayValues = str2double(strsplit(delaystring, ','));  

    % 验证输入是否为数字  
    if any(isnan(delayValues))  
        error('请输入有效的数字，用逗号分隔。');  
    end  

    
%%display(delayValues);
% --- Executes during object creation, after setting all properties.
function kongkoushiyan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kongkoushiyan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in visual.
function visual_flag=visual_Callback(hObject, eventdata, handles)
% hObject    handle to visual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
visual_flag = get(handles.visual,'value');
% Hint: get(hObject,'Value') returns toggle state of visual

%display(visual_flag);
% --- Executes on button press in notvisual.
function notvisual_Callback(hObject, eventdata, handles)
% hObject    handle to notvisual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of notvisual


% --- Executes on button press in mimo.
function mimo=mimo_Callback(hObject, eventdata, handles)
% hObject    handle to mimo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mimo = get(handles.mimo,'value');
% Hint: get(hObject,'Value') returns toggle state of mimo

%display(mimo);

% --- Executes on button press in siso.
function siso=siso_Callback(hObject, eventdata, handles)
% hObject    handle to siso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
siso = get(handles.siso,'value');
% Hint: get(hObject,'Value') returns toggle state of siso


% --- Executes on button press in check.
function check_Callback(hObject, eventdata, handles)
% hObject    handle to check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mode_flag = get(handles.modulate,'value');
siso = get(handles.siso,'value');
mimo = get(handles.mimo,'value');
delaystring = get(handles.kongkoushiyan, 'String');
delayValues = str2double(strsplit(delaystring, ',')); 
powerstring = get(handles.power, 'String');
powerValues = str2double(strsplit(powerstring, ','));  
visual_flag = get(handles.visual,'value');
jingzhen = get(handles.jingzhen,'value');
confirm= get(handles.check,'value');
kongkou = str2double(get(handles.txt, 'String'));
ebn0=str2double(get(handles.ebn0, 'String'));
circumstance = get(handles.circumstance,'value');
    % 验证输入是否为数字  
    if any(isnan(delayValues))  
        error('请输入有效的数字，用逗号分隔。');  
    end  
if(confirm&&siso)
    main_ALL(mode_flag,delayValues,powerValues,jingzhen,ebn0,kongkou,visual_flag);
    %main_ALL(mode_flag,delayValues,kongkou,visual_flag);
end
if(confirm&&mimo)
   MIMOfuncLTE(kongkou,jingzhen,circumstance,ebn0);
end
%mode_flag=1的时候，实际上就是默认选项的值，也就是弹出式菜单这个选项的值。mode_flag=2开始才是真正要选的选项的值，这一点很容易出错，要记住。

%display(mode_flag)
%display(mimo)
%display(siso)
%display(delayValues)
%display(visual_flag)
%display(confirm)
%display(kongkou)



function txt_Callback(hObject, eventdata, handles)
% hObject    handle to txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
kongkou = str2double(get(handles.txt, 'String'));


% Hints: get(hObject,'String') returns contents of txt as text
%        str2double(get(hObject,'String')) returns contents of txt as a double


% --- Executes during object creation, after setting all properties.
function txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function power_Callback(hObject, eventdata, handles)
% hObject    handle to power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of power as text
%        str2double(get(hObject,'String')) returns contents of power as a double


% --- Executes during object creation, after setting all properties.
function power_CreateFcn(hObject, eventdata, handles)
% hObject    handle to power (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function jingzhen_Callback(hObject, eventdata, handles)
% hObject    handle to jingzhen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jingzhen=str2double(get(handles.jingzhen, 'String'));
% Hints: get(hObject,'String') returns contents of jingzhen as text
%        str2double(get(hObject,'String')) returns contents of jingzhen as a double


% --- Executes during object creation, after setting all properties.
function jingzhen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to jingzhen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in circumstance.
function circumstance_Callback(hObject, eventdata, handles)
% hObject    handle to circumstance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
circumstance = get(handles.circumstance,'value');
% Hints: contents = cellstr(get(hObject,'String')) returns circumstance contents as cell array
%        contents{get(hObject,'Value')} returns selected item from circumstance


% --- Executes during object creation, after setting all properties.
function circumstance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to circumstance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ebn0_Callback(hObject, eventdata, handles)
% hObject    handle to ebn0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ebn0=str2double(get(handles.ebn0, 'String'));
% Hints: get(hObject,'String') returns contents of ebn0 as text
%        str2double(get(hObject,'String')) returns contents of ebn0 as a double


% --- Executes during object creation, after setting all properties.
function ebn0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ebn0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% axes(handles.frame)
% image(imread('frame.png'));
    % 加载图像  
    img = imread('frame.png');  % 替换为你的图像文件路径  
    % 在axes中显示图像  
    imshow(img, 'Parent', hObject);  
axis off;
% Hint: place code in OpeningFcn to populate frame
