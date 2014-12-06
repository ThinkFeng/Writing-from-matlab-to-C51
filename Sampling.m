function varargout = serial(varargin)
% SERIAL MATLAB code for serial.fig
%      SERIAL, by itself, creates a new SERIAL or raises the existing
%      singleton*.
%
%      H = SERIAL returns the handle to a new SERIAL or the handle to
%      the existing singleton*.
%
%      SERIAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SERIAL.M with the given input arguments.
%
%      SERIAL('Property','Value',...) creates a new SERIAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before serial_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to serial_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help serial

% Last Modified by GUIDE v2.5 22-Dec-2013 09:22:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @serial_OpeningFcn, ...
    'gui_OutputFcn',  @serial_OutputFcn, ...
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
function figure_CloseRequestFcn(hObject, eventdata, handles)
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

% --- Executes just before serial is made visible.
function serial_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to serial (see VARARGIN)

% Choose default command line output for serial
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
s = serial('COM1');
time1h = [];
time1l = [];
time2h = [];
time2l = [];
timelefth = [];
timeleftl = [];
%zz = [time1h(snum) time1l(snum) time2h(snum) time2l(snum) ...
%    timelefth(snum) timeleftl(snum) carflag(snum)];
set(handles.axes,'visible','off');
set(handles.close_serial,'position',get(handles.open_serial,'position'))

% UIWAIT makes serial wait for user response (see UIRESUME)
% uiwait(handles.figure);

function varargout = serial_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
function open_serial_Callback(hObject, eventdata, handles)
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
% hObject    handle to open_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function scan_Callback(hObject, eventdata, handles)
global path
[filename,filepath]=uigetfile('*.jpg;*.png;*.gif','���ļ�');%gui�д��ļ�
path = strcat(filepath,filename);
set(handles.ads,'String',path);
if path
    I = imread(path);
    set(handles.axes,'visible','on');
    handles.axes;
    imshow(I);
    %image(I);
else
    set(handles.axes,'visible','off');
end
% hObject    handle to scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function ads_CreateFcn(hObject, ~, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ads_Callback(hObject, eventdata, handles)
% hObject    handle to ads (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ads as text
%        str2double(get(hObject,'String')) returns contents of ads as a double
% --- Executes on button press in getpoint.
function getpoint_Callback(hObject, eventdata, handles)
global path
global num
global p q
global flag carflag x y
if path
    but= 1;
    set(handles.uppan,'enable','off')
    set(handles.getend,'enable','off')
    set(handles.getagain,'enable','off')
    set(handles.prompt,'visible','on')
    x0 = 0;
    y0 = 0;
    while but == 1                      % while button 1 being pressed
        [x, y, but] = ginput(1);
        if but~=1
            set(handles.uppan,'enable','on')
            set(handles.getend,'enable','on')
            set(handles.getagain,'enable','on')
            set(handles.getpoint,'enable','on')
            set(handles.prompt,'visible','off')
            x = x0;
            y = y0;
            break
        else
        text(x-9,y-9,'��','Fontsize',24,'Color','r')
        num = num + 1;
        x0 = x;
        y0 = y;
        p = x/2.3;%ͼƬ��СΪ460x400px
        q = y/2;
        calculate_Callback(hObject, eventdata, handles)
        end
        set(handles.pointpos,'string',[p,q])
        if flag == 1;
            carflag(num) = 3;%С��ֹͣ
            num = num + 1;
            p = x/2.3;%ͼƬ��СΪ460x400px
            q = y/2;
            calculate_Callback(hObject, eventdata, handles)
            carflag(num) = 1;%С��ǰ��
            flag = 0;
        else %if %flag==0
            carflag(num) = 3;%С��ֹͣ
        end
    end
else
    msgbox('Please load the picture your wanted!','Warning','warn');
end
%dlmwrite('a.txt',[x,y] ,'delimiter', ' ');
% hObject    handle to getpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in uppan.
function uppan_Callback(hObject, eventdata, handles)
global num x y
global flag carflag p q
num = num + 1;
carflag(num) = 2;%С������
p = x/2.3;%ͼƬ��СΪ460x400px
q = y/2;
calculate_Callback(hObject, eventdata, handles)
flag = 1;
% hObject    handle to uppan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in getend.
function getend_Callback(hObject, eventdata, handles)
global time1h time1l time2h time2l timelefth timeleftl carflag
global num
txtnamestr = strcat(get(handles.txtname,'String'),'.txt');
try
    if strcmp(txtnamestr,'.txt')
        msgbox('Please input the name of the data-points !','Prompt');
        return
    else
        fid=fopen(txtnamestr,'wt');
        for i=1:num
            fprintf(fid,'%2.0f\t%2.0f\t%2.0f\t%2.0f\t%2.0f\t%2.0f\t%1.0f\n',...
                time1h(i),time1l(i),time2h(i),time2l(i),timelefth(i),timeleftl(i),carflag(i));%\t is the tab
        end
        fclose(fid);
        % Rsave d:\a.txt xx -ascii;
        m = msgbox('       The data are saved successfully!','Congratulation');
        pause(1.5);delete(m)
        set(handles.getpoint,'enable','off')
        set(handles.uppan,'enable','off')
        set(handles.getend,'enable','off')
        return
    end
catch
    msgbox('The data are saved unsuccessfully!','Error','Err')
    return;
end
% hObject    handle to getend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in getagain.
function getagain_Callback(hObject, eventdata, handles)
global num time1h time1l time2h time2l timelefth timeleftl
global flag
flag = 1;
num = 0;
time1h = [];
time1l = [];
time2h = [];
time2l = [];
timelefth = [];
timeleftl = [];
set(handles.sendnum,'enable','off')
getpoint_Callback(hObject, eventdata, handles)
% hObject    handle to getagain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
global p q
global num zz
global time1h time1l % ��ʱ��1��λ���λ
global time2h time2l % ��ʱ��2��λ���λ
global timelefth timeleftl% ��ʱ��λ���λ
p = p + 100;
q = 150 - q;
beta = atan(q / p);
afa = acos((180 ^ 2 + p ^ 2 + q ^ 2 - 170 ^ 2) / (2 * 180 * (p ^ 2 + q ^ 2) ^ 0.5));
thta1 = (beta + afa) * 180 / pi;
thta2 = acos((p ^ 2 + q ^ 2 - 180 ^ 2 - 170 ^ 2) / (2 * 170 * 170)) * 180 / pi;
time01 = floor((-thta1+90)*800/90+1120);
time1 = dec2hex(65536-time01);
time02 = floor(thta2*800/90+700);
time2 = dec2hex(65536-time02);
timeleft = dec2hex(65536 - 20000+(time01 + time02));
time1h(num) = hex2dec(time1(1:length(time1)-2));
time1l(num) = hex2dec(time1(length(time1)-1:end));
time2h(num) = hex2dec(time2(1:length(time2)-2));
time2l(num) = hex2dec(time2(length(time2)-1:end));
timelefth(num) = hex2dec(timeleft(1:length(timeleft)-2));
timeleftl(num) = hex2dec(timeleft(length(timeleft)-1:end));
if num == 1
        set(handles.sendnum,'enable','on')
        zz = [time1h(1) time1l(1) time2h(1) time2l(1) ...
        timelefth(1) timeleftl(1) 3];%�˴�ȡֵ3������Ϊ��һ�β�����carflagû��Ԫ��
    %������������Ϊ��ֵ3��Ҳ������С��ֹͣ��������е�ֶ�λ
end
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function EveBytesAvailableFcn(obj, ~, handles)
%   ���ڵ�BytesAvailableFcn�ص�����
%   ���ڽ�������
global time1h time1l time2h time2l timelefth timeleftl carflag zz snum 
%% ��ȡ����
strRec = getappdata(handles.figure, 'strRec'); %��ȡ����Ҫ��ʾ������
numRec = getappdata(handles.figure, 'numRec'); %��ȡ�����ѽ������ݵĸ���
isShow = getappdata(handles.figure, 'isShow');  %�Ƿ�����ִ����ʾ���ݲ���
% %% �Ƿ�Ϊ��ȡ���ݷ���
% if get(handles.datasend,'value')
%     ii = ii + 1;
%     return;
% end
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
%guidata(handles.figure,'hasData')
% --- Executes on button press in close_serial.
function close_serial_Callback(hObject, eventdata, handles)
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
% hObject    handle to close_serial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function axes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes


% --- Executes during object creation, after setting all properties.
function txtname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in com.
function com_Callback(hObject, eventdata, handles)
% hObject    handle to com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns com contents as cell array
%        contents{get(hObject,'Value')} returns selected item from com


% --- Executes on button press in manual_send.
function manual_send_Callback(hObject, eventdata, handles)
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
% hObject    handle to manual_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sends_Callback(hObject, eventdata, handles)
str = get(hObject,'string');
n = find(str==' ');   %���ҿո�
n =[0 n length(str)+1]; %�ո������ֵ
%% ÿ�������ڿո�֮����ַ���Ϊ��ֵ��ʮ��������ʽ������ת��Ϊ��ֵ
for i = 1 : length(n)-1
    temp = str(n(i)+1 : n(i+1)-1);  %���ÿ�����ݵĳ��ȣ�Ϊ����ת��Ϊʮ������׼��
    if ~rem(length(temp), 2)
        b{i} = reshape(temp, 2, [])'; %��ÿ��ʮ�������ַ���ת��Ϊ��Ԫ����
        val = hex2dec(b)';     %��ʮ�������ַ���ת��Ϊʮ���������ȴ�д�봮��
    else
        break;
    end
end
set(handles.sends,'UserData',val)
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


% --- Executes on button press in clear_zero.
function clear_zero_Callback(hObject, eventdata, handles)
set([handles.rec, handles.trans], 'string', '0')
setappdata(handles.figure, 'numRec', 0);
setappdata(handles.figure, 'numSend', 0);
% hObject    handle to clear_zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --- Executes during object creation, after setting all properties.
function getpoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to getpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


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


% --- Executes on button press in period_send.
function period_send_Callback(hObject, eventdata, handles)
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
% hObject    handle to period_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in sendnum.
function sendnum_Callback(hObject, eventdata, handles)
clear snum
global snum zz time1h time1l time2h time2l timelefth timeleftl
snum = 1;
set(handles.sends,'string','')
zz = [time1h(1) time1l(1) time2h(1) time2l(1) ...
    timelefth(1) timeleftl(1) 3];
% hObject    handle to sendnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txtname_Callback(hObject, eventdata, handles)
% hObject    handle to txtname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtname as text
%        str2double(get(hObject,'String')) returns contents of txtname as a double


% --- Executes on button press in clearxs.
function clearxs_Callback(hObject, eventdata, handles)
strRec = ' ' ;
setappdata(handles.figure,'strRec',strRec)
set(handles.xianshi,'string',strRec)
% hObject    handle to clearxs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function sendnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sendnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
