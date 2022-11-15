function varargout = CalCellNum_qka(varargin)
% CALCELLNUM_QKA MATLAB code for CalCellNum_qka.fig
%      CALCELLNUM_QKA, by itself, creates a new CALCELLNUM_QKA or raises the existing
%      singleton*.
%
%      H = CALCELLNUM_QKA returns the handle to a new CALCELLNUM_QKA or the handle to
%      the existing singleton*.
%
%      CALCELLNUM_QKA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCELLNUM_QKA.M with the given input arguments.
%
%      CALCELLNUM_QKA('Property','Value',...) creates a new CALCELLNUM_QKA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CalCellNum_qka_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CalCellNum_qka_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CalCellNum_qka

% Last Modified by GUIDE v2.5 27-Oct-2022 21:21:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CalCellNum_qka_OpeningFcn, ...
                   'gui_OutputFcn',  @CalCellNum_qka_OutputFcn, ...
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


% --- Executes just before CalCellNum_qka is made visible.
function CalCellNum_qka_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CalCellNum_qka (see VARARGIN)

% Choose default command line output for CalCellNum_qka
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CalCellNum_qka wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CalCellNum_qka_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_open.
function pushbutton_open_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axis on  
global im;
axes(handles.Init_image_axes);
cla reset;
[filename, pathname] =uigetfile({'*.Bmp';'*.jpg';'*.*'},'打开图片');
str=[pathname filename];
im=imread(str);

imshow(im);



% --- Executes on button press in pushbutton_Thre_seg.
function pushbutton_Thre_seg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Thre_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im1;
T=globalthreshold( im );
im1=im2bw(im,T/255);
% I=rgb2gray(im);
% im1=imbinarize(I,graythresh(I));
axes(handles.Image_TS_axes);
cla reset;
imshow(im1);

% --- Executes on button press in pushbutton_filter.
function pushbutton_filter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im1;
global A;
A=im1;
% type1
% B=[0 1 0
%    1 1 1
%    0 1 0];
% % B=strel('disk',3);
% 
% %膨胀
% for i =1:5
%     A=imdilate(A,B);
% end
% %腐蚀
% for i =1:6
%     A=imerode(A,B);
% end
% se1=strel('disk',1);%这里是创建一个半径为1的平坦型圆盘结构元素
% A=imerode(A,se1);

axes(handles.Image_Filter_axes);
cla reset;
A=imcomplement(A);%翻转黑白
BW1=A;
BW2=imfill(BW1,'holes');
se1=strel('disk',14);
BW3=imopen(BW2,se1);%初步开运算减少白色区域
BW4=BW2-BW3;%对比开运算前后图像，找出被删除的细胞
se2=strel('disk',6);
BW5=imopen(BW4,se2);%开运算对比后图像，消除因细胞大小改变产生的细胞轮廓
se2=strel('disk',13);
BW7=imerode(BW3,se2);%对图像进行彻底但不消失细胞的侵蚀，使细胞不再连接
BW8=BW5+BW7;%与此前消失的细胞的图像合并，恢复他们
A=BW8;
imshow(A);

% --- Executes on button press in pushbutton_calNum.
function pushbutton_calNum_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_calNum (see GCBO)
% eventdata  reserved - to be defined .in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%约 29个
global im;
global A;
[Label, Number]=bwlabel(A,4);
stats=regionprops(Label,'all');
tongji='';
for i = 1:Number
    S(i)=stats(i).Area;%区域，记录了区域内像素点的个数
    L(i)=stats(i).Perimeter;%区域的周长
    tongji_temp=['第',num2str(i),'个细胞的面积为',num2str(S(i)),';',10];
    tongji=[tongji tongji_temp];
end
S,L
axes(handles.Final_axes);
cla reset;
imshow(im);

for i = 1:Number
    [r,c]=find(Label==i);
    rmin=min(r);rmax=max(r);
    cmin=min(c);cmax=max(c);
    w=cmax-cmin+1;
    h=rmax-rmin+1;
    hold on
    %if (h>w && 1.5*w>h) || (w>h && 1.5*h>w)||(w==h)
%         if (h>w && 1.5*w<h) || (w>h && 1.5*h<w) 
        rectangle('Position',[cmin,rmin,w,h],'linewidth',1.2,'edgecolor',[189 30 30]/255);%画一个正方形
        drawnow;%将正方形画在打开的figure即原图中
end

% x=2/3;
% x
% set(handles.edit_ShowNum,'string',[num2str(x*100),'%']);

set(handles.edit_ShowNum,'string',Number);
set(handles.edit_Tongji,'string',tongji);
% --- Exsyecutes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ShowNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ShowNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ShowNum as text
%        str2double(get(hObject,'String')) returns contents of edit_ShowNum as a double


% --- Executes during object creation, after setting all properties.
function edit_ShowNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ShowNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Move.
function pushbutton_Move_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im_temp;
delt=inputdlg({'水平平移距离','垂直平移距离'},'图像平移参数');
deltX=delt{1};
deltY=delt{2};
deltX=str2double(deltX);deltY=str2double(deltY);
axes(handles.Transformation_axes);
cla reset;
im_temp=Trans_Move(im,deltX,deltY);
imshow(im_temp);

% --- Executes on button press in pushbutton_HM.
function pushbutton_HM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_HM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im_temp;
axes(handles.Transformation_axes);
cla reset;
im_temp=Trans_HM(im);
imshow(im_temp);

% --- Executes on button press in pushbutton_VM.
function pushbutton_VM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_VM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im_temp;
axes(handles.Transformation_axes);
cla reset;
im_temp=Trans_VM(im);
imshow(im_temp);


% --- Executes on button press in pushbutton_Scale.
function pushbutton_Scale_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im_temp;
rate=inputdlg('请输入缩放比例','缩放参数');
rate=str2double(rate);
axes(handles.Transformation_axes);
cla reset;
im_temp=imresize(im,rate,'bicubic');
imshow(im_temp);

% --- Executes on button press in pushbutton_Transpose.
function pushbutton_Transpose_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Transpose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im_temp;
axes(handles.Transformation_axes);
cla reset;
im_temp=Trans_T(im);
imshow(im_temp);

% --- Executes on button press in pushbutton_Cut.
function pushbutton_Cut_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im_temp;
axes(handles.Transformation_axes);
cla reset;
im_temp=Trans_Cut(im);
imshow(im_temp);

% --- Executes on button press in pushbutton_Rotaiton.
function pushbutton_Rotaiton_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Rotaiton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im_temp;
rate=inputdlg('请输入旋转弧度','旋转参数');
rate=str2double(rate);
axes(handles.Transformation_axes);
cla reset;
im_temp=Trans_Rot(im,rate);
imshow(im_temp);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global im;
global im_temp;
alpha=get(handles.slider1,'Value');
alpha = alpha*10;
set(handles.edit_alpha,'string',num2str(alpha));
axes(handles.Transformation_axes);
cla reset;
im_temp=LaplacianFilter(im,alpha);
imshow(im_temp);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_Smoothing.
function pushbutton_Smoothing_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Smoothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im_temp;
rate=inputdlg('请输入模板大小(奇数)','模板尺寸');
rate=str2double(rate);
axes(handles.Transformation_axes);
cla reset;
im_temp=S_averfilter(im,rate);
imshow(im_temp);

% --- Executes on button press in pushbutton_Sharpening.
function pushbutton_Sharpening_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Sharpening (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im;
global im_temp;
alpha=inputdlg('请输入锐化系数(-100~100)','模板尺寸');
alpha=str2double(alpha);
set(handles.edit_alpha,'string',num2str(alpha));
axes(handles.Transformation_axes);
cla reset;
im_temp=LaplacianFilter(im,alpha);
imshow(im_temp);



function edit_alpha_Callback(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_alpha as text
%        str2double(get(hObject,'String')) returns contents of edit_alpha as a double


% --- Executes during object creation, after setting all properties.
function edit_alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Grey.
function pushbutton_Grey_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Grey (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global im;
global im_temp;
Fa=get(handles.slider2,'Value');
Fb=get(handles.slider3,'Value');
Fa = Fa*10;
Fb = Fb*200-100;
set(handles.edit_Comp,'string',num2str(Fa));
axes(handles.Transformation_axes);
cla reset;
im_temp=Grey_Linear(im,Fa,Fb);
imshow(im_temp);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global im;
global im_temp;
%Fa=get(handles.slider2,'Value');
Fb=get(handles.slider3,'Value');
%Fa = Fa*10;
Fb = Fb*0.4;
set(handles.edit_liang,'string',num2str(Fb));
axes(handles.Transformation_axes);
cla reset;
im_temp=Grey_exp(im,Fb);
imshow(im_temp);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_Comp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Comp as text
%        str2double(get(hObject,'String')) returns contents of edit_Comp as a double


% --- Executes during object creation, after setting all properties.
function edit_Comp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_liang_Callback(hObject, eventdata, handles)
% hObject    handle to edit_liang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_liang as text
%        str2double(get(hObject,'String')) returns contents of edit_liang as a double


% --- Executes during object creation, after setting all properties.
function edit_liang_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_liang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global im;
global im_temp;
Temp_Size=get(handles.slider4,'Value');
Temp_Size = round(Temp_Size*40);
if(mod(Temp_Size,2)==0)
    Temp_Size=Temp_Size+1;
end
set(handles.edit_Size,'string',num2str(Temp_Size));
% axes(handles.Transformation_axes);
% cla reset;
im_temp=S_averfilter(im,Temp_Size);
imshow(im_temp);


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_Size_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Size as text
%        str2double(get(hObject,'String')) returns contents of edit_Size as a double


% --- Executes during object creation, after setting all properties.
function edit_Size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Num.
function pushbutton_Num_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global im;
% [NUM] = CellNum(im)



function edit_Tongji_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Tongji (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Tongji as text
%        str2double(get(hObject,'String')) returns contents of edit_Tongji as a double


% --- Executes during object creation, after setting all properties.
function edit_Tongji_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Tongji (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
