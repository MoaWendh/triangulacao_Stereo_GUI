%******************************** Triangulação estéreo **************************
% Triangulação estéreo a partir de pontos 3D e 2D obtidos pelo algoritmo
% Bouguet.
%**************************************************************************
function xyzStereo= fTriangulacaoStereo(paramStereo, param_L, param_R, pathToSave)

close all;
clc;

% Define o formato dos dado snume´ricos como long:
format long;

numFiles= size(param_L, 2);

% Efetua a trinagulçãoa para os n arquivos carregados:
for (ct=1:numFiles)
    % Carrega os pontos 2D no plano imagem:
    if numFiles==1
        xL{ct}= param_L.param.x_ext;
        xR{ct}= param_R.param.x_ext;
    else
        xL{ct}= param_L{ct}.param.x_ext;
        xR{ct}= param_R{ct}.param.x_ext;        
    end
    % Efetua a triangulação estéreo:
    [XL, XR]= stereo_triangulation(xL{ct}, xR{ct}, paramStereo.om, paramStereo.T, paramStereo.fc_left, paramStereo.cc_left ... 
                                   ,paramStereo.kc_left, paramStereo.alpha_c_left, paramStereo.fc_right, paramStereo.cc_right ...
                                   ,paramStereo.kc_right, paramStereo.alpha_c_right);
    
    % Salva os pontos 3D, nuvem de pontos, obtida por triangulação em arquivo no formato .txt:                             
    % Define o nome do arquivo:
    nameFile= sprintf('pontos3D_Stereo_%.02d.txt', ct); 
    fullPath= fullfile(pathToSave, nameFile);
    
    % Abre o arquivo apara salvar os pontos 3D (nuvem de pontos) obtidos por triangulação:
    fid = fopen(fullPath,'wt'); 

    % Salva o arquivo contendo os pontos 3D no formato .txt usando TB (\t) como tabulação:
    fprintf(fid,'%.4f\t%.4f\t%.4f\n', XL);
    
    % fecha o arquivo geradao:
    fclose(fid); 
    
    % Retorna as PC geradas no formato xyz:
    xyzStereo{ct}= XL;
end
end
