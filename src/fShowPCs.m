function fShowPCs(xyzStereo)

numPCs= size(xyzStereo, 2);
msg= sprintf('Escolha uma PC para plotar entre 1 e %d', numPCs);
prompt = {msg};
dlgtitle = 'Escolha PC para exibição.';
definput = {num2str(numPCs)};
dims = [1 40];
opts.Interpreter = 'tex';
answer = inputdlg(prompt, dlgtitle, dims, definput, opts);
pcNum= str2num(cell2mat(answer));

plot3(xyzStereo{pcNum}(1,:), xyzStereo{pcNum}(2,:), xyzStereo{pcNum}(3,:), '.r')

axis equal;
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');

end