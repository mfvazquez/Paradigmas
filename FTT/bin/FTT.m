clc;
sca;
close all;
clearvars;

% ------------------- CONSTANTES GLOBALES --------------------------------
global hd; 
global window;
global scrnsize;
global escKey;
global fKey;
global gKey;
global hKey;
global jKey;



nombre = inputdlg('Nombre:');
if isempty(nombre)
    return
end
nombre = nombre{1};

ListenChar(2);
HideCursor;
[window, scrnsize] = init_psych();

DATA_PATH = fullfile('..','data');

TIEMPO_MENSAJE = 8;
TIEMPO_CENTRADO = 5;

% ----------------------- TECLAS A USAR ----------------------------------

escKey = KbName('ESCAPE');
fKey = KbName('f');
gKey = KbName('g');
hKey = KbName('h');
jKey = KbName('j');

% ------------------ MENSAJE DE BIENVENIDA -------------------------------

MensajeBienvenida = fileread(fullfile(DATA_PATH,'MensajeBienvenida.txt'));

textoCentrado(TIEMPO_MENSAJE, MensajeBienvenida);

% ------------------- + PARA CENTRAR VISTA -------------------------------

textoCentrado(TIEMPO_CENTRADO, '+');

% ------------------- INICIO DEL BLOQUE ----------------------------------

Bloque();

% ------------------- CIERRO PSYCHOTOOLBOX  ------------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;