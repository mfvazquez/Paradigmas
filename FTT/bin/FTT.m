clc;
sca;
close all;
clearvars;

% ------------------- CONSTANTES GLOBALES --------------------------------
global hd;
global escKey;
global fKey;
global gKey;
global hKey;
global jKey;

% nombre = inputdlg('Nombre:');
% if isempty(nombre)
%     return
% end
% nombre = nombre{1};
% 
% versiones = {'Baseline' 'Trial'};
% choice = menu('Version:',versiones);
% version = versiones{choice};
% 
% manos = {'Diestro' 'Zurdo'};
% choice = menu('�Eres Diestro o Zurdo?:', manos);
% mano = manos{choice};


hd = init_psych();
ListenChar(2);
HideCursor;

DATA_PATH = fullfile('..','data');

TIEMPO_CENTRADO = 5;

MENSAJE_CONTINUAR = 'Presione cualquier tecla para continuar';

% ----------------------- TECLAS A USAR ----------------------------------

escKey = KbName('ESCAPE');
fKey = KbName('f');
gKey = KbName('g');
hKey = KbName('h');
jKey = KbName('j');

% ------------------ MENSAJE DE BIENVENIDA -------------------------------

% MensajeBienvenida = fileread(fullfile(DATA_PATH,'MensajeBienvenida.txt'));
% 
% textoCentrado(MensajeBienvenida);
% MensajeContinuar(MENSAJE_CONTINUAR);
% Screen('Flip', hd.window);
% KbWait;
% 
% % ------------------- + PARA CENTRAR VISTA -------------------------------
% 
% textoCentrado('+');
% Screen('Flip', hd.window);
% WaitSecs(TIEMPO_CENTRADO);

% ------------------- INICIO DEL BLOQUE ----------------------------------

Bloque('2-5-3-4-3', 10);

% ------------------- CIERRO PSYCHOTOOLBOX  ------------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;