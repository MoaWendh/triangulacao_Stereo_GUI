function varargout = triangulacao_stereo_GUI(varargin)
% TRIANGULACAO_STEREO_GUI MATLAB code for triangulacao_stereo_GUI.fig
%      TRIANGULACAO_STEREO_GUI, by itself, creates a new TRIANGULACAO_STEREO_GUI or raises the existing
%      singleton*.
%
%      H = TRIANGULACAO_STEREO_GUI returns the handle to a new TRIANGULACAO_STEREO_GUI or the handle to
%      the existing singleton*.
%
%      TRIANGULACAO_STEREO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRIANGULACAO_STEREO_GUI.M with the given input arguments.
%
%      TRIANGULACAO_STEREO_GUI('Property','Value',...) creates a new TRIANGULACAO_STEREO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before triangulacao_stereo_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to triangulacao_stereo_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help triangulacao_stereo_GUI

% Last Modified by GUIDE v2.5 23-Apr-2024 10:18:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @triangulacao_stereo_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @triangulacao_stereo_GUI_OutputFcn, ...
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


% --- Executes just before triangulacao_stereo_GUI is made visible.
function triangulacao_stereo_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to triangulacao_stereo_GUI (see VARARGIN)


handles.pathToReadCalibFile= 'C:\Projetos\Matlab\programas_GUI\triangulacao_Stereo_GUI\src';
handles.pathToRead_L= 'C:\Projetos\Matlab\programas_GUI\triangulacao_Stereo_GUI\in\L';
handles.pathToRead_R= 'C:\Projetos\Matlab\programas_GUI\triangulacao_Stereo_GUI\in\R';
handles.pathToSave= 'C:\Projetos\Matlab\programas_GUI\triangulacao_Stereo_GUI\out';
handles.pathToReadPC= 'C:\Projetos\Matlab\programas_GUI\triangulacao_Stereo_GUI\in'; 

handles.fileCalibration_ok= 0;
handles.pontos2D_L_Ok= 0;
handles.pontos2D_R_Ok= 0;

handles.TriangulacaoStereo_ok= 0;

% Choose default command line output for triangulacao_stereo_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes triangulacao_stereo_GUI wait for user response (see UIRESUME)
% uiwait(handles.figureMain);


% --- Outputs from this function are returned to the command line.
function varargout = triangulacao_stereo_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbClose.
function pbClose_Callback(hObject, eventdata, handles)
% hObject    handle to pbClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.figureMain.HandleVisibility= 'on';

close all;
clear;
clc;


% --- Executes on button press in pbLoadParametrosCalibracaoStereo.
function pbLoadParametrosCalibracaoStereo_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoadParametrosCalibracaoStereo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Abre tela para escolhar as PCs para serem filtradas:

clc;
close all;

file= fullfile(handles.pathToReadCalibFile, '*.mat');
[nameFile pathToRead]= uigetfile(file, 'Escolha o arquivo de calibração estéreo.');

if ~pathToRead
    msg= sprintf('Processo de escolha do arquivo de calibração foi cancelado!');
    msgbox(msg, '', 'warn');
    return;
end

fileName= fullfile(pathToRead, nameFile);

% Carrega os parãmetros de calibração na variável "handles.paramStereo":
handles.paramStereo= load(fileName);

handles.fileCalibration_ok= 1;

if handles.fileCalibration_ok && handles.pontos2D_L_Ok 
    handles.pbExecTriangulacao.Enable= 'on'; 
end  

% Se handles.TriangulacaoStereo_ok=1 significa que já foi feita a triangulação,
% Neste caso ao carregar um novo arquivo de calibração, uma nova triangulação deverá ser feita.
if handles.TriangulacaoStereo_ok
    handles.pbExecTriangulacao.Enable= 'off'; 
end  

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pbLoadPontosPlanoImagem_L.
function pbLoadPontosPlanoImagem_L_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoadPontosPlanoImagem_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc;
close all;
path= fullfile(handles.pathToRead_L,'*.mat');
[nameFile pathToRead]= uigetfile(path, 'Escolha o arquivo com os pontos 2D da esquerda.', 'MultiSelect', 'on');

if ~pathToRead
    msg= sprintf('Processo de escolha do arquivo foi cancelado!');
    msgbox(msg, '', 'warn');
    return;
end
handles.pathToRead_L= pathToRead;

if ~iscell(nameFile)
   numFiles= 1;
else
   numFiles= size(nameFile, 2); 
end

% Carrega os pontos 2D, no plano imagem, e outros parâmetros obtidos pela função calib_gui do Yves Bouguet:
for ctFile=1:numFiles
    if numFiles==1
        fileName= fullfile(pathToRead, nameFile);
        handles.param_L= load(fileName);    
    else    
        fileName= fullfile(pathToRead, nameFile{ctFile});
        handles.param_L{ctFile}= load(fileName);
    end
end

handles.pontos2D_L_Ok= 1;

if handles.fileCalibration_ok && handles.pontos2D_R_Ok 
    handles.pbExecTriangulacao.Enable= 'on'; 
end

% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pbLoadPontosPlanoImagem_R.
function pbLoadPontosPlanoImagem_R_Callback(hObject, eventdata, handles)
% hObject    handle to pbLoadPontosPlanoImagem_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
close all;
path= fullfile(handles.pathToRead_R,'*.mat');
[nameFile pathToRead]= uigetfile(path, 'Escolha o arquivo com os pontos 2D da direita.', 'MultiSelect', 'on');

if ~pathToRead
    msg= sprintf('Processo de escolha do arquivo foi cancelado!');
    msgbox(msg, '', 'warn');
    return;
end
handles.pathToRead_R= pathToRead;

if ~iscell(nameFile)
   numFiles= 1;
else
   numFiles= size(nameFile, 2); 
end

for ctFile=1:numFiles
    if numFiles==1
        fileName= fullfile(pathToRead, nameFile);
        handles.param_R= load(fileName);    
    else    
        fileName= fullfile(pathToRead, nameFile{ctFile});
        handles.param_R{ctFile}= load(fileName);
    end
end

handles.pontos2D_R_Ok= 1;

if handles.fileCalibration_ok && handles.pontos2D_L_Ok 
    handles.pbExecTriangulacao.Enable= 'on'; 
end    
    
% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pbExecTriangulacao.
function pbExecTriangulacao_Callback(hObject, eventdata, handles)
% hObject    handle to pbExecTriangulacao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
close all;

pathToSave= uigetdir(handles.pathToSave, 'Defina onde salvar os arquivos.');

if ~pathToSave
    msg= sprintf('Processo de escolha do arquivo foi cancelado!');
    msgbox(msg, '', 'warn');
    return;
end

handles.pathToSave= pathToSave;

handles.xyzStereo= fTriangulacaoStereo(handles.paramStereo, handles.param_L, handles.param_R, handles.pathToSave);

handles.TriangulacaoStereo_ok= 1;

handles.pbShowPCs.Enable= 'on';

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in rdLoadPontos2DFromFile.
function rdLoadPontos2DFromFile_Callback(hObject, eventdata, handles)
% hObject    handle to rdLoadPontos2DFromFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdLoadPontos2DFromFile

handles.LoadPontos2DFromFile= hObject.Value;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pbShowPCs.
function pbShowPCs_Callback(hObject, eventdata, handles)
% hObject    handle to pbShowPCs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fShowPCs(handles.xyzStereo, handles.ShowDuasPCsSobrepostas, handles.pathToReadPC);

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in rdShowDuasPCsSobrepostas.
function rdShowDuasPCsSobrepostas_Callback(hObject, eventdata, handles)
% hObject    handle to rdShowDuasPCsSobrepostas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rdShowDuasPCsSobrepostas

handles.ShowDuasPCsSobrepostas= hObject.Value;

% Update handles structure
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function rdShowDuasPCsSobrepostas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rdShowDuasPCsSobrepostas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles.ShowDuasPCsSobrepostas= hObject.Value

% Update handles structure
guidata(hObject, handles);


