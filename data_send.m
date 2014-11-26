function varargout = data_send(varargin)
% DATA_SEND MATLAB code for data_send.fig
%      DATA_SEND, by itself, creates a new DATA_SEND or raises the existing
%      singleton*.
%
%      H = DATA_SEND returns the handle to a new DATA_SEND or the handle to
%      the existing singleton*.
%
%      DATA_SEND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_SEND.M with the given input arguments.
%
%      DATA_SEND('Property','Value',...) creates a new DATA_SEND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before data_send_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to data_send_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help data_send

% Last Modified by GUIDE v2.5 23-Dec-2013 20:08:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @data_send_OpeningFcn, ...
                   'gui_OutputFcn',  @data_send_OutputFcn, ...
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


% --- Executes just before data_send is made visible.
function data_send_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to data_send (see VARARGIN)

% Choose default command line output for data_send
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%% �����ʼ��
hasData = false; %���������Ƿ���յ�����
isShow = false;  %�����Ƿ����ڽ���������ʾ�����Ƿ�����ִ�к���dataDisp
numRec = 0;    %�����ַ�����
numSend = 0;   %�����ַ�����
strRec = '';   %�ѽ��յ��ַ���
%% ������������ΪӦ�����ݣ����봰�ڶ�����
setappdata(hObject, 'hasData', hasData);
setappdata(hObject, 'strRec', strRec);
setappdata(hObject, 'numRec', numRec);
setappdata(hObject, 'numSend', numSend);
setappdata(hObject, 'isShow', isShow);
guidata(hObject, handles);
%%
global num snum
global path 
global flag
global s
clc
global  time1h time1l time2h time2l timelefth timeleftl
num = 0;
snum = 1;
path = 0;
flag = 1;
time1h = [];
time1l = [];
time2h = [];
time2l = [];
timelefth = [];
timeleftl = [];
s = serial('COM1');
set(handles.close_serial,'position',get(handles.open_serial,'position'))
% UIWAIT makes data_send wait for user response (see UIRESUME)
% uiwait(handles.figure);


% --- Outputs from this function are returned to the command line.
function varargout = data_send_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
function EveBytesAvailableFcn(obj, ~, handles)
%   ���ڵ�BytesAvailableFcn�ص�����
%   ���ڽ�������
global time1h time1l time2h time2l timelefth timeleftl carflag zz snum 
%% ��ȡ����
strRec = getappdata(handles.figure, 'strRec'); %��ȡ����Ҫ��ʾ������
numRec = getappdata(handles.figure, 'numRec'); %��ȡ�����ѽ������ݵĸ���
isShow = getappdata(handles.figure, 'isShow');  %�Ƿ�����ִ����ʾ���ݲ���
%% ������ִ��������ʾ�������ݲ����մ�������
if isShow
    return;
end
%% ��ȡ���ڿɻ�ȡ�����ݸ���
n = get(obj, 'BytesAvailable');
%% �����������ݣ�������������
if n
    %% ����hasData����������������������Ҫ��ʾ
    setappdata(handles.figure, 'hasData', true);
    %% ��ȡ��������
    a = fread(obj, n, 'uchar');
    %% ����Ҫ��ʾ���ַ���
    strHex = dec2hex(a')';
    strHex2 = [strHex; blanks(size(a, 1))];
    c = strHex2(:)';
    %% �����ѽ��յ����ݸ���
    numRec = numRec + size(a, 1);
    %% ����Ҫ��ʾ���ַ���
    strRec = [strRec c];
    %% ���²���
    setappdata(handles.figure, 'numRec', numRec); %�����ѽ��յ����ݸ���
    setappdata(handles.figure, 'strRec', strRec); %����Ҫ��ʾ���ַ���
        %% ������һ������
    [m n]=size(time1h);
    if snum > m * n - 1
        snum = 1;
        set(handles.period_send,'value',0);
        set(handles.period1, 'Enable', 'on'); %�������ö�ʱ�����ڵ�Edit Text����
        t = timerfind; %���Ҷ�ʱ��
        try
            msgbox('        All the data is sended !   ','Prompt');
            stop(t); %ֹͣ��ʱ��
            delete(t); %ɾ����ʱ��
        catch
        end
        %return
    else
    snum = snum + 1;
    end
    zz = [time1h(snum) time1l(snum) time2h(snum) time2l(snum) ...
        timelefth(snum) timeleftl(snum) carflag(snum)];
end


function dataads_Callback(hObject, eventdata, handles)
% hObject    handle to dataads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataads as text
%        str2double(get(hObject,'String')) returns contents of dataads as a double


% --- Executes during object creation, after setting all properties.
function dataads_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in scan.
function scan_Callback(hObject, eventdata, handles)
% hObject    handle to scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global path time1h time1l time2h time2l timelefth timeleftl carflag zz
[filename,filepath]=uigetfile('*.txt','���ļ�');%gui�д��ļ�
path = strcat(filepath,filename);
set(handles.dataads,'String',path);
if path
   [time1h time1l time2h time2l timelefth timeleftl carflag]=textread(path);
   zz = [time1h(1) time1l(1) time2h(1) time2l(1) timelefth(1) timeleftl(1) carflag(1)];
   set(handles.sendnum,'enable','on')
end

function xianshi_Callback(hObject, eventdata, handles)
% hObject    handle to xianshi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xianshi as text
%        str2double(get(hObject,'String')) returns contents of xianshi as a double


% --- Executes during object creation, after setting all properties.
function xianshi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xianshi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sends_Callback(hObject, eventdata, handles)
% hObject    handle to sends (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sends as text
%        str2double(get(hObject,'String')) returns contents of sends as a double


% --- Executes during object creation, after setting all properties.
function sends_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sends (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in period_send.
function period_send_Callback(hObject, eventdata, handles)
% hObject    handle to period_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%   ���Զ����͡���ť��Callback�ص�����
%% �����¡��Զ����͡���ť��������ʱ��������ֹͣ��ɾ����ʱ��
if get(hObject, 'value')
    t1 = 0.001 * str2double(get(handles.period1, 'string'));%��ȡ��ʱ������
    t = timer('ExecutionMode','fixedrate', 'Period', t1, 'TimerFcn',...
        {@manual_send_Callback, handles}); %������ʱ��
    set(handles.period1, 'Enable', 'off'); %�������ö�ʱ�����ڵ�Edit Text����
    set(handles.sends, 'Enable', 'inactive'); %�������ݷ��ͱ༭��
    start(t);  %������ʱ��
else
    set(handles.period1, 'Enable', 'on'); %�������ö�ʱ�����ڵ�Edit Text����
    set(handles.sends, 'Enable', 'on');   %�������ݷ��ͱ༭��
    t = timerfind; %���Ҷ�ʱ��
    stop(t); %ֹͣ��ʱ��
    delete(t); %ɾ����ʱ��i
end
% Hint: get(hObject,'Value') returns toggle state of period_send



function period1_Callback(hObject, eventdata, handles)
% hObject    handle to period1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of period1 as text
%        str2double(get(hObject,'String')) returns contents of period1 as a double


% --- Executes during object creation, after setting all properties.
function period1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to period1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in manual_send.
function manual_send_Callback(hObject, eventdata, handles)
% hObject    handle to manual_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global zz
scom = get(handles.figure, 'UserData');
numSend = getappdata(handles.figure, 'numSend');
%val = get(handles.sends, 'UserData');
val = zz;
numSend = numSend + length(double(val));
set(handles.trans, 'string', num2str(numSend));
setappdata(handles.figure, 'numSend', numSend);
setappdata(handles.figure,'hasData',true)
set(handles.sends,'string',num2str(val))
%% ��Ҫ���͵����ݲ�Ϊ�գ���������
if ~isempty(val)
    %% ���õ������ĳ�ֵ
    while getappdata(handles.figure,'hasData')
        %% ��ȡ���ڵĴ���״̬��������û������д���ݣ�д������
        str = get(scom, 'TransferStatus');
        if ~(strcmp(str, 'write') || strcmp(str, 'read&write'))
            fwrite(scom, val, 'uint8', 'async'); %����д�봮��
            break;
        end
    end
end

% --- Executes on button press in sendnum.
function sendnum_Callback(hObject, eventdata, handles)
% hObject    handle to sendnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear snum
global snum zz time1h time1l time2h time2l timelefth timeleftl
snum = 1;
set(handles.sends,'string','')
zz = [time1h(1) time1l(1) time2h(1) time2l(1) ...
    timelefth(1) timeleftl(1) 3];


% --- Executes on button press in clearxs.
function clearxs_Callback(hObject, eventdata, handles)
strRec = ' ' ;
setappdata(handles.figure,'strRec',strRec)
set(handles.xianshi,'string',strRec)
% hObject    handle to clearxs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in com.
function com_Callback(hObject, eventdata, handles)
% hObject    handle to com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns com contents as cell array
%        contents{get(hObject,'Value')} returns selected item from com


% --- Executes during object creation, after setting all properties.
function com_CreateFcn(hObject, eventdata, handles)
% hObject    handle to com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in open_serial.
function open_serial_Callback(hObject, eventdata, handles)
% hObject    handle to open_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
slist = get(handles.com,'string');
sval = get(handles.com,'value');
s = slist{sval};
s = serial(s);
try
    set(s,'BaudRate',9600);
    set(s, 'Parity', 'none') ;     % Set parity as none
    set(s, 'Databits', 8) ;       % set the number of data bits
    set(s, 'StopBits', 1) ;     % set number of stop bits as 1
    set(s, 'InputBufferSize', 1024) ;
    %set(s, 'Timeout', 5) ;
    set(s, 'OutputBufferSize', 1024) ;
    set(s,'bytesavailablefcnmode','byte',...
        'TimerPeriod', 0.05, 'timerfcn', {@dataDisp, handles});
    s.BytesAvailableFcnCount=10; %���뻺��������10���ֽڴ����ص�����
    s.BytesAvailableFcn={@EveBytesAvailableFcn,handles};%�ص�������ָ��
    fopen(s);
    set(hObject,'visible','off')
    set(handles.close_serial,'visible','on')
    set(handles.manual_send,'enable','on')
    set(handles.period_send,'enable','on')
    %hs_dlg=msgbox('Serial is opened now!','Reminder');
catch
    hs_dlg=msgbox('             Open false!!!','Error','Error');
    ht_dlg=findobj(hs_dlg,'Type','text');%��ȡmsgbox�ľ��
    set(ht_dlg,'FontSize',12,'Unit','normal');%����msgbox�������С
    set(hObject,'visible','on')
    set(handles.close_serial,'visible','off')
end
set(handles.figure, 'UserData', s);

% --- Executes on button press in close_serial.
function close_serial_Callback(hObject, eventdata, handles)
% hObject    handle to close_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s
try
    stopasync(s);
    fclose (s);
    delete (s);
    set(hObject,'visible','off')
    set(handles.open_serial,'visible','on')
    set(handles.manual_send,'enable','off')
    set(handles.period_send,'enable','off')
catch
    set(hObject,'visible','on')
    set(handles.open_serial,'visible','off')
end

% --- Executes on button press in clear_zero.
function clear_zero_Callback(hObject, eventdata, handles)
set([handles.rec, handles.trans], 'string', '0')
setappdata(handles.figure, 'numRec', 0);
setappdata(handles.figure, 'numSend', 0);
% hObject    handle to clear_zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%   �رմ���ʱ����鶨ʱ���ʹ����Ƿ��ѹر�
%   ��û�йرգ����ȹر�
%% ���Ҷ�ʱ��
t = timerfind;
%% �����ڶ�ʱ������ֹͣ���ر�
if ~isempty(t)
    stop(t);  %����ʱ��û��ֹͣ����ֹͣ��ʱ��
    delete(t);
end
%% ���Ҵ��ڶ���
s = instrfind('Type','serial');
%% ����ֹͣ���ر�ɾ�����ڶ���
try
    stopasync(s);
    fclose(s);
    delete(s);
end
%% �رմ���
delete(hObject);
function dataDisp(obj, event, handles)
%	���ڵ�TimerFcn�ص�����
%   ����������ʾ
%% ��ȡ����
hasData = getappdata(handles.figure, 'hasData'); %�����Ƿ��յ�����
strRec = getappdata(handles.figure, 'strRec');   %�������ݵ��ַ�����ʽ����ʱ��ʾ������
numRec = getappdata(handles.figure, 'numRec');   %���ڽ��յ������ݸ���
%% ������û�н��յ����ݣ��ȳ��Խ��մ�������
if ~hasData
    EveBytesAvailableFcn(obj, event, handles);
end
%% �����������ݣ���ʾ��������
if hasData
    %% ��������ʾģ��ӻ�����
    %% ��ִ����ʾ����ģ��ʱ�������ܴ������ݣ�����ִ��BytesAvailableFcn�ص�����
    setappdata(handles.figure, 'isShow', true);
    %% ��Ҫ��ʾ���ַ������ȳ���10000�������ʾ��
    if length(strRec) > 200
        strRec = '';
        setappdata(handles.figure, 'strRec', strRec);
    end
    %% ��ʾ����
    set(handles.xianshi, 'string', strRec);
    %% ���½��ռ���
    set(handles.rec,'string', numRec);
    %% ����hasData��־���������������Ѿ���ʾ
    setappdata(handles.figure, 'hasData', false);
    %% ��������ʾģ�����
    setappdata(handles.figure, 'isShow', false);
end
