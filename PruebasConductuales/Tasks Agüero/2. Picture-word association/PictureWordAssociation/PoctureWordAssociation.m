% function PictureWordAssociation()

clc;
sca;
close all;
clearvars;

%% LIBRERIAS

addpath('lib');

%% CONSTANTES GLOBALES

global hd
global ExitKey
global AfirmativeKey
global NegativeKey
global TAMANIO_TEXTO
global MENSAJE_PRACTICA
global MENSAJE_BLOQUES
global TAMANIO_INSTRUCCIONES


%% CONSTANTES

KbName('UnifyKeyNames');
ExitKey = KbName('ESCAPE');
AfirmativeKey = KbName('LeftArrow');
NegativeKey = KbName('RightArrow');

TAMANIO_TEXTO = 0.08;

TAMANIO_INSTRUCCIONES = 0.03;

MENSAJE_PRACTICA = 'Hagamos una tanda de pr�ctica.\n\nPresione cualquier tecla para comenzar.';
MENSAJE_BLOQUES = '�Listo para la prueba?\n\nPresione cualquier tecla para comenzar.';

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};


%% INICIO PSYCHOTOOLBOX

hd = init_psych();
Screen('Flip', hd.window);


%% DATOS

bloques_carpetas = ArchivosDeCarpeta('data');
bloques = cell(1,length(bloques_carpetas));
for i = 1:length(bloques)
    data_dir = fullfile('data',bloques_carpetas{i});    
    bloques{i} = CargarBloque(data_dir);
end

% %% LOG
% 
% log = cell(1, length(secuencia_bloques));


% PARADIGMA

for i = 1:length(bloques)
    exit = CorrerBloque(bloques{i});
    if exit
        break;
    end
end


%% GUARDO LOG

% nombre_archivo_log = PrepararLog('log', nombre, 'DecisionPerceptual');
% save(nombre_archivo_log, 'log');

Salir;

% end