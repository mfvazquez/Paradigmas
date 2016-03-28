clc;
sca;
close all;
clearvars;

addpath(fullfile('..','lib'));

%PsychJavaTrouble
global hd; 

% -------------------- CONSTANTES -------------------------------------

TIEMPO_INICIAL_CENTRADO = 8;
TIEMPO_PRE_HISTORIA = 3;
TIEMPO_POST_HISTORIA = 6;

textos_opciones.pregunta = '¿Cuanto castigo considera que merece Juan?';
textos_opciones.minimo = 'Ningún castigo';
textos_opciones.medio = 'Neutral';
textos_opciones.maximo = 'Mucho castigo';

% -------------------- TECLAS A UTILIZAR -------------------------------
KbName('UnifyKeyNames');
escKey = KbName('ESCAPE');
rightKey = KbName('RightArrow');
leftKey = KbName('LeftArrow');
downKey = KbName('DownArrow');

% -------------------- COLORES A UTILIZAR -----------------------------

white = [255 255 255];
black = [0 0 0];
red = [255 0 0];

% ------------------- VERSION A CORRER --------------------------------

versiones = {'Gráfico versión 1','Gráfico versión 2','Simple versión 1','Simple versión 2'};
carpetas = {'grafico_v1','grafico_v2', 'simple_v1', 'simple_v2'};
choice = menu('Version de lenguaje:',versiones);
carpeta_historias = carpetas{choice};
arch_historia = fullfile('..', 'data', carpeta_historias, 'historia_1.txt'); %aca deberia abrir todos los archivos en la carpeta, ojo que no estan ordenados, hay que ordenarlos

a = dir(['..\data\' carpeta_historias]);
a(1) = [];
a(1) = [];
arch = {a.name};
arch = natsort(arch);


% ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
ListenChar(2);
HideCursor;
[window, scrnsize] = init_psych(hd);

% ------------------- INICIO DEL PARADIGMA ----------------------------

% % % % % % ------------------- + PARA CENTRAR VISTA ----------------------------
% % % % % 
% % % % % textoCentrado(window, scrnsize, TIEMPO_INICIAL_CENTRADO, '+');

% ------------------- INTRODUCCION -----------------------------------




% % % % % % ------------------- + PARA CENTRAR VISTA ---------------------------
% % % % % 
% % % % % textoCentrado(window, scrnsize, TIEMPO_PRE_HISTORIA, '+');

% % % % % % ------------------- HISTORIA ---------------------------------------
% % % % % 
% % % % % text = fileread(arch_historia);
% % % % % textoCentradoBoton(window, scrnsize, text);


% % % % % % ------------------- + PARA CENTRAR VISTA ---------------------------
% % % % % 
% % % % % textoCentrado(window, scrnsize, TIEMPO_POST_HISTORIA, '+');

% ------------------- OPCIONES ---------------------------------------

elegido = 5;
dibujarOpciones(window, scrnsize, elegido, textos_opciones);

continuar = true;
while continuar

    [~, keyCode, ~] = KbPressWait;
    
    if keyCode(rightKey) && elegido < 9
        elegido = elegido + 1;
        dibujarOpciones(window, scrnsize, elegido, textos_opciones);
    elseif keyCode(leftKey) && elegido > 1
        elegido = elegido - 1;
        dibujarOpciones(window, scrnsize, elegido, textos_opciones);
    elseif keyCode(escKey)
        continuar = false;
    end   
   
end


% ---------------------- FIN DEL PARADIGMA ---------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;
