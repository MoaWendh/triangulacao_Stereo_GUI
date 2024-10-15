function ct= fShowPCs(xyzStereo, ShowDuasPCsSobrepostas, pathToReadPC, pathToSaveFigure, habSaveFigure, ct)
clc;
%close all;

% Escolha a pc que foi gerada:
numPCs= size(xyzStereo, 2);
msg= sprintf('Escolha uma PC para plotar entre 1 e %d', numPCs);
prompt = {msg};
dlgtitle = 'Escolha PC para exibição.';
definput = {num2str(numPCs)};
dims = [1 40];
opts.Interpreter = 'tex';
answer = inputdlg(prompt, dlgtitle, dims, definput, opts);
pcNum= str2num(cell2mat(answer));

% Obtém a posição dos monitores:
% monitorPositions = get(0, 'MonitorPositions');

fig= figure;
% fig.Position=[200 200 1800 1100];
fig.Position= [-1915 269 1526 720];
tamFonte= 20;

if ~ShowDuasPCsSobrepostas
    plot3(xyzStereo{pcNum}(1,:), xyzStereo{pcNum}(2,:), xyzStereo{pcNum}(3,:), 'or')
    msg= sprintf('PC n°:%d', pcNum);
    ax= gca;
    set(ax,'FontSize', 14)
    
    % Reposiciona a câmera para colocar o eixo Z na profundidade e o Y na vertica:
    ax.CameraPosition= [90 -2000 565];
    
    %subtitle(msg, 'FontSize', tamFonte); 
    axis equal;
    grid on;
    xlabel('X (mm)', 'FontSize', tamFonte);
    ylabel('Y (mm)', 'FontSize', tamFonte);
    zlabel('Z (mm)', 'FontSize', tamFonte);

else
    files= fullfile(pathToReadPC, '*.txt');
    % Escolhe a PC original para sobrepor a PC gerada "xyzStereo":
    [nameFile path]= uigetfile(files, 'Escolha a PC Stereo para sobrepor a PC criada.');
    
    if ~path
        msg= sprintf('Processo de escolha da PC Stereo foi cancelado!');
        msgbox(msg, '', 'warn');
        return;
    end
    
    fullPath= fullfile(path, nameFile);
    pcStereo= load(fullPath);
    
    plot3(xyzStereo{pcNum}(1,:), xyzStereo{pcNum}(2,:), xyzStereo{pcNum}(3,:), 'or')
    hold on;
    
    plot3(pcStereo(:,1), pcStereo(:,2), pcStereo(:,3), '.b')
    
    axis equal;
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
end

if habSaveFigure
    ct= ct +1;
    % Escolha a pasta onde serão salvas as PCs:
    pathToSave= uigetdir(pathToSaveFigure, 'Escolha a pasta onde serão salvas as figuras no formato .png.');

    if ~pathToSave
        msg= sprintf('Procedimento de triangulação cancelado!');
        msgbox(msg, '', 'warn');
        return;
    end
    
    % Salva a figura .png:
    nameFile= sprintf('grafico_PC_%.2d.png', ct); 
    fullFile= fullfile(pathToSave, nameFile);
    saveas(gcf, fullFile);
    
    % Salva a figura .svg:
    nameFile= sprintf('grafico_PC_%.2d.svg', ct); 
    fullFile= fullfile(pathToSave, nameFile);
    saveas(gcf, fullFile);    
end

end