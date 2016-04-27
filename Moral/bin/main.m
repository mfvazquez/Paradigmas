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

tamanio_fijacion = 0.05;
tamanio_historia = 0.035;


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

data_path = fullfile('..','data');
carpetas = dir(data_path);
carpetas = {carpetas.name};
carpetas(1) = []; % elimino el .
carpetas(1) = []; % elimino el ..

versiones = cell(1,length(carpetas));
for i = 1:length(carpetas)
    versiones{1,i} = carpetas{i};
end

choice = menu('Version:',versiones);
version = carpetas{choice};

historias_path = fullfile(data_path, version);
historias_arch = dir(historias_path);
historias_arch = {historias_arch.name};
historias_arch(1) = [];
historias_arch(1) = [];
historias_arch = natsort(historias_arch);

historias = cell(1, length(historias_arch));
for i = 1:length(historias)
    archivo = fullfile(historias_path, historias_arch{i});
    historias{1,i} = fileread(archivo);
end


% ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
ListenChar(2);
HideCursor;
init_psych();

% ------------------- INICIO DEL PARADIGMA ----------------------------

% % % % % % ------------------- + PARA CENTRAR VISTA ----------------------------
% % % % % 
% % % % % textoCentrado('+', tamanio_fijacion);
% % % % % Screen('Flip', hd.window);
% % % % % WaitSecs(TIEMPO_INICIAL_CENTRADO);
% % % % % 
% % % % % % ------------------- INTRODUCCION -----------------------------------
% % % % % 
% % % % % textoCentrado('INSTRUCCIONES INSTRUCTIVAS', tamanio_fijacion);
% % % % % Screen('Flip', hd.window);
% % % % % KbWait;


exit = false;
for i = 1:length(historias)

% % % % %     % ------------------- + PARA CENTRAR VISTA ---------------------------
% % % % % 
% % % % %     textoCentrado('+', tamanio_fijacion);
% % % % %     Screen('Flip', hd.window);
% % % % %     WaitSecs(TIEMPO_PRE_HISTORIA);
% % % % % 

    % ------------------- HISTORIA ---------------------------------------

    textoCentrado(historias{1,i}, tamanio_historia);
    Screen('Flip', hd.window);
    KbPressWait;
% % % % % 
% % % % %     % ------------------- + PARA CENTRAR VISTA ---------------------------
% % % % % 
% % % % %     textoCentrado('+', tamanio_fijacion);
% % % % %     Screen('Flip', hd.window);
% % % % %     WaitSecs(TIEMPO_POST_HISTORIA);
% % % % % 
% % % % %     % ------------------- OPCIONES ---------------------------------------

% % % % %     elegido = 5;
% % % % %     dibujarOpciones(elegido, textos_opciones);
% % % % %     Screen('Flip', hd.window);
% % % % % 
% % % % %     continuar = true;
% % % % %     while continuar
% % % % % 
% % % % %         [~, keyCode, ~] = KbPressWait;
% % % % % 
% % % % %         if keyCode(rightKey) && elegido < 9
% % % % %             elegido = elegido + 1;
% % % % %             dibujarOpciones(elegido, textos_opciones);
% % % % %             Screen('Flip', hd.window);
% % % % %         elseif keyCode(leftKey) && elegido > 1
% % % % %             elegido = elegido - 1;
% % % % %             dibujarOpciones(elegido, textos_opciones);
% % % % %             Screen('Flip', hd.window);
% % % % %         elseif keyCode(downKey)
% % % % %             continuar = false;
% % % % %         elseif keyCode(escKey)
% % % % %             continuar = false;
% % % % %             exit = true;
% % % % %         end
% % % % % 
% % % % %     end
% % % % %     
% % % % %     if (exit)
% % % % %         break;
% % % % %     end
    
end


% ---------------------- FIN DEL PARADIGMA ---------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;
