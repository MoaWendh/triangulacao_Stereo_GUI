function fShowPCs(xyzStereo, ShowDuasPCsSobrepostas, pathToReadPC)
clc;
close all;

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

if ~ShowDuasPCsSobrepostas
    plot3(xyzStereo{pcNum}(1,:), xyzStereo{pcNum}(2,:), xyzStereo{pcNum}(3,:), '.r')

    axis equal;
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
else
    files= fullfile(pathToReadPC, '*.txt');
    % Escolhe a PC original para sobrepor a PC gerada "xyzStereo":
    [nameFile path]= uigetfile(files, 'Escolha a PC Stereo para sobrepor a PC criada.');
    
    if ~path
        msg= sprintf('Processo de escolha do arquivo de calibração foi cancelado!');
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
end