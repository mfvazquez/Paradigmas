% function NegationTask_conductual()
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
global MARCA_DURACION
global pportobj pportaddr
global EEG

%% CONSTANTES

% PsychDebugWindowConfiguration

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
DOT.SIZE = 0.035;
DOT.KEY_VALUE = 'l';
DOT.KEY = KbName('DownArrow');

% CONSTANTE PREGUNTA

PREGUNTA.STR = '?';
PREGUNTA.STIM = 7;

TEXTO_CONTINUAR = 'pulsa espacio para continuar';

OPCION_DIST = 0.3;

EEG = true;

%% MARCAS

MARCAS_ESTIMULOS = {0 10 20 {30 35 31} 40 50 {60 65}};
MARCAS.ESTIMULOS = MARCAS_ESTIMULOS;
MARCAS.AMARILLO = 101;
MARCAS.ACIERTO = 150;
MARCAS.ERROR = 151;
MARCA_DURACION = 0.001;

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% VERSION

versiones = {'V1' 'V2'};

choice = menu('Version a correr:',versiones);
version = versiones{choice};
data_dir = fullfile('data', version);

OPCION_IZQ.KEY = KbName('LeftArrow');
OPCION_DER.KEY = KbName('RightArrow');

if choice == 1
    OPCION_IZQ.KEY_VALUE = 'sí';
    OPCION_IZQ.STR = 'SI';
    OPCION_DER.KEY_VALUE = 'no';
    OPCION_DER.STR = 'NO';
else
    OPCION_IZQ.KEY_VALUE = 'no';
    OPCION_IZQ.STR = 'NO';
    OPCION_DER.KEY_VALUE = 'sí';
    OPCION_DER.STR = 'SI';
end

%% PUERTO PARALELO

pportaddr = 'C020';

if EEG

    if exist('pportaddr','var') && ~isempty(pportaddr)
        fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
        pportaddr = hex2dec(pportaddr);

        pportobj = io64;
        io64status = io64(pportobj);

        if io64status ~= 0
            error('io64 failure: could not initialise parallel port.\n');
        end
    end

end

%% INICIO PSYCHOTOOLBOX

ListenChar(2);
HideCursor;
hd = init_psych();

Screen('Flip', hd.window);

%% DURACIONES

T_ESTIMULOS = {0.5 0.3 0.3 {0.3 0.2 0.2} 0.3 0.6 {0.3 5}};
T_BLANCOS = {0.15 0.15 0.15 0.15 0.15 0.3 0.5};
TIEMPOS.ESTIMULOS = T_ESTIMULOS;
TIEMPOS.BLANCOS = T_BLANCOS;

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

%% LOG

log_entrenamiento = CrearLog({entrenamiento});
log = CrearLog(bloques);

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

[exit, log_entrenamiento{1}] = CorrerBloque(entrenamiento, true, log_entrenamiento{1});
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
    [exit, log{i}] = CorrerBloque(bloques{i}, false, log{i});
    if exit
        break;
    end
end

%% FIN

TextoCentrado(TEXTO_FIN, TEXT_SIZE_INST);
Screen('Flip', hd.window);
EsperarBoton(ContinueKey, ExitKey);

%% GUARDO LOG

GuardarLog(log, nombre, 'log', 'NegationTask_conductual', 'bloques');
GuardarLog(log_entrenamiento, nombre, 'log', 'NegationTask_conductual', 'entrenamiento');

Salir;
% end