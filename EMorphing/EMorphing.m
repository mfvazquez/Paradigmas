
clc;
sca;
close all;
clearvars;
clear all;

%% LIBRERIAS

addpath('lib');

hd = init_psych;

% archivos = ArchivosDeCarpeta(fullfile('data','imagenes'))
imagenes = CargarTexturasDeCarpeta('data', hd.window);


for i = 1:length(imagenes)
    DibujarTexturaCentrada(imagenes{i}, hd.window);
    Screen('Flip', hd.window);
    WaitSecs(0.5);
end

KbWait;

Salir;
