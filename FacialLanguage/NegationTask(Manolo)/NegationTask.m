% Negation Task

clc;
sca;
close all;
clearvars;

%% LIBRERIAS

addpath('lib');

%% CONSTANTES GLOBALES

global hd
global TEXT_SIZE_INST
global TEXT_SIZE_STIM
global ExitKey
global ContinueKey
global DOT
global PREGUNTA
global OPCION_IZQ
global OPCION_DER
global OPCION_DIST
global TEXTO_CONTINUAR
global TIEMPOS
global MARCAS

%% CONSTANTES

LARGO_LINEA = 40;

TEXT_SIZE_INST = 0.025;
TEXT_SIZE_STIM = 0.04;
KbName('UnifyKeyNames');
ExitKey = KbName('ESCAPE');
ContinueKey = KbName('SPACE');

% CONSTANTES DEL PUNTO

DOT.STIM = [4 2];
DOT.AMARILLO = [255 255 0];
DOT.AZUL = [0 0 255];
DOT.POS = [0.5 0.45];
DOT.SIZE = 0.03;
DOT.KEY_VALUE = 'l';
DOT.KEY = KbName('l');

% CONSTANTE PREGUNTA

PREGUNTA.STR = '?';
PREGUNTA.STIM = 7;

TEXTO_CONTINUAR = 'pulsa espacio para continuar';

OPCION_DIST = 0.3;

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% VERSION

versiones = {'V1' 'V2'};

choice = menu('Version a correr:',versiones);
version = versiones{choice};
data_dir = fullfile('data', version);

OPCION_IZQ.KEY = KbName('v');
OPCION_IZQ.KEY_VALUE = 'v';

OPCION_DER.KEY = KbName('b');
OPCION_DER.KEY_VALUE = 'b';

if choice == 1
    OPCION_IZQ.STR = 'CORRECTO';
    OPCION_DER.STR = 'INCORRECTO';
else
    OPCION_IZQ.STR = 'INCORRECTO';
    OPCION_DER.STR = 'CORRECTO';
end

%% INICIO PSYCHOTOOLBOX

ListenChar(2);
HideCursor;
hd = init_psych();

TextoCentrado('Cargando Datos...', TEXT_SIZE_INST);
Screen('Flip', hd.window);

%% DURACIONES

T_ESTIMULOS = {0.5 0.2 0.3 {0.3 0.15 0.15} 0.2 0.3 {0.3 5}};
T_BLANCOS = {0.15 0.15 0.15 0.15 0.15 0.3 0.5};
TIEMPOS.ESTIMULOS = T_ESTIMULOS;
TIEMPOS.BLANCOS = T_BLANCOS;

%% MARCAS

MARCAS_ESTIMULOS = {0 10 20 {30 39 31} 40 50 {60 65}};
MARCAS.ESTIMULOS = MARCAS_ESTIMULOS;
MARCAS.AMARILLO = 101;
MARCAS.ACIERTO = 150;
MARCAS.ERROR = 151;
MARCAS.DURACION = 0.05;

%% TEXTOS

TEXTO_COMIENZO = fileread(fullfile(data_dir, 'comienzo.txt'));
TEXTO_FIN = fileread(fullfile(data_dir, 'fin.txt'));

instrucciones_dir = fullfile(data_dir,'instrucciones');
archivos_instrucciones = ArchivosDeCarpeta(instrucciones_dir);

textos_instrucciones = cell(1,length(archivos_instrucciones));
for i = 1:length(archivos_instrucciones)
    archivo = fullfile(data_dir,'instrucciones', archivos_instrucciones(i).name);
    textos_instrucciones{i} = fileread(archivo);
end

%% BLOQUES

entrenamiento = CargarBloque(data_dir,'entrenamiento.csv');

bloques_dir = fullfile(data_dir, 'bloques');
bloques_arch = ArchivosDeCarpeta(bloques_dir);
bloques = cell(1, length(bloques_arch));
for i = 1:length(bloques_arch)
    bloques{i} = CargarBloque(bloques_dir, bloques_arch(i).name);
end


%% INSTRUCCIONES

for i = 1:length(textos_instrucciones)
    TextoCentrado(textos_instrucciones{i}, TEXT_SIZE_INST);
    Screen('Flip', hd.window);
    exit = EsperarBoton(ContinueKey, ExitKey);
    if exit
        Salir;
        return;
    end
end


%% ENTRENAMIENTO

exit = CorrerBloque(entrenamiento, true);
if exit
    Salir;
    return;
end

%% COMIENZO

TextoCentrado(TEXTO_COMIENZO, TEXT_SIZE_INST);
Screen('Flip', hd.window);
exit = EsperarBoton(ContinueKey, ExitKey);
if exit
    Salir;
    return;
end

%% BLOQUES

for i = 1:length(bloques)
    exit = CorrerBloque(bloques{i}, false);
    if exit
        Salir;
        return;
    end
end

%% FIN

%% COMIENZO

TextoCentrado(TEXTO_FIN, TEXT_SIZE_INST);
Screen('Flip', hd.window);
EsperarBoton(ContinueKey, ExitKey);

Salir;