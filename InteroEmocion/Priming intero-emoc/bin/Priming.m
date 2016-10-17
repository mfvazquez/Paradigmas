
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
% % % global MENSAJE_PRACTICA
% % % global MENSAJE_BLOQUES
global TAMANIO_INSTRUCCIONES


%% CONSTANTES

KbName('UnifyKeyNames');
ExitKey = KbName('ESCAPE');
AfirmativeKey = KbName('LeftArrow');
NegativeKey = KbName('RightArrow');

TAMANIO_TEXTO = 0.08;

TAMANIO_INSTRUCCIONES = 0.03;

% MAPA CON LAS IMAGENES CORRESPONDIENTES A CADA CODIGO
keySet = {'N1'	    'N2'	    'N3'	    'N4'	    'N5'	    'N6'	    'N7'	    'N8'	    'N9'	    'N10'	'A1'	'A2'	'A3'	'A4'	'A5'	'A6'	'A7'	'A8'	'A9'	'A10'	'T1'	'T2'	'T3'	'T4'	'T5'	'T6'	'T7'	'T8'	'T9'	'T10'	'E1'	'E2'	'E3'	'E4'	'E5'	'E6'	'E7'	'E8'	'E9'	'E10'};
nombres_imagenes = {'MC01_NEU'	'MC02_NEU'	'MC03_NEU'	'MC04_NEU'	'MC05_NEU'	'MC06_NEU'	'MC07_NEU'	'MC08_NEU'	'MC09_NEU'	'MC10_NEU'	'MC01_HAP'	'MC02_HAP'	'MC03_HAP'	'MC04_HAP'	'MC05_HAP'	'MC06_HAP'	'MC07_HAP'	'MC08_HAP'	'MC09_HAP'	'MC10_HAP'	'MC01_SAD'	'MC02_SAD'	'MC03_SAD'	'MC04_SAD'	'MC05_SAD'	'MC06_SAD'	'MC07_SAD'	'MC08_SAD'	'MC09_SAD'	'MC10_SAD'	'MC01_ANG'	'MC02_ANG'	'MC03_ANG'	'MC04_ANG'	'MC05_ANG'	'MC06_ANG'	'MC07_ANG'	'MC08_ANG'	'MC09_ANG'	'MC10_ANG'};

directorio_imagenes = fullfile('data','imagenes');
bloques_dir = fullfile('data','bloques');


%% NOMBRE
% % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % nombre = inputdlg('Nombre:');
% % % % % % % % % % % % % % % nombre = nombre{1};


%% BLOQUE A CORRER

bloques_carpetas = ArchivosDeCarpeta(bloques_dir);
choice = menu('test:',bloques_carpetas);
archivo = bloques_carpetas{choice};


%% INICIO PSYCHOTOOLBOX

hd = init_psych();
Screen('Flip', hd.window);


%% CARGO DATOS
valueSet = CargarTexturas(directorio_imagenes, nombres_imagenes, 'JPG');
map = containers.Map(keySet,valueSet);

bloque = CargarBloque(fullfile(bloques_dir, archivo));
bloque = Decodificar(bloque, map, directorio_imagenes);

CorrerSecuencia(bloque);

% % % % %% LOG
% % % % log = cell(1, length(bloques));
% % % % for i = 1:length(bloques)
% % % %     log{i} = cell(length(bloques{i}.bloque_texturas), 1);
% % % % end

% % % % PARADIGMA
% % % 
% % % % CorrerSecuencia(bloque);
% % % 
% % % % for i = 1:length(bloques)
% % % %     [exit, log{i}] = CorrerBloque(bloques{i}, log{i});
% % % %     if exit
% % % %         break;
% % % %     end
% % % % end


% % % % % % % % % % % % % % % % %% GUARDO LOG
% % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % nombre_archivo_log = PrepararLog('log', nombre, 'PictureWordAssociation');
% % % % % % % % % % % % % % % % save(nombre_archivo_log, 'log');

Salir;

