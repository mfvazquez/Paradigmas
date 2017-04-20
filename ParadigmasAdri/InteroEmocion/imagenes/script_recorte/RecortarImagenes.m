rect = [5 55 305  409];

archivos = dir('recortar');
archivos(1) = [];
archivos(1) = [];

for x = 1:length(archivos)
   
    nombre = archivos(x).name;
    I = imread(fullfile('recortar',nombre));
%     [I_recortado, rect] = imcrop(I);
    I_recortado = imcrop(I, rect);
%     nombre = [nombre(1:8) nombre(end-3:end)];
%     nombre = upper(nombre);
    imwrite(I_recortado,fullfile('recortados',nombre),'jpg');
    
end