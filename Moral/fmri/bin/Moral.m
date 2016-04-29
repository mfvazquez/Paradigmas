function Moral()

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

LARGO_LINEA = 65;

INSTRUCCIONES = 'A continuación se le presentarán una serie de situaciones. Por favor léalas y responda las preguntas usando las escalas correspondientes.';
INSTRUCCIONES = AgregarFinLinea(INSTRUCCIONES, round(LARGO_LINEA/2));
% -------------------- TECLAS A UTILIZAR -------------------------------

global escKey;
global rightKey;
global leftKey;
global downKey;

KbName('UnifyKeyNames');
escKey = KbName('ESCAPE');
rightKey = KbName('RightArrow');
leftKey = KbName('LeftArrow');
downKey = KbName('DownArrow');

% -------------------- NOMBRE -----------------------------------------

nombre = inputdlg('Nombre:');
nombre = nombre{1};

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
    historias{1,i} = AgregarFinLinea(historias{1,i}, LARGO_LINEA);
end

% ------------------- RESERVO ESPACIO PARA EL LOG ---------------------

log.version = version;
log.historia_inicio = cell(1, length(historias));
log.historia_fin = cell(1, length(historias));

log.respuesta_inicio = cell(1, length(historias));
log.respuesta_fin = cell(1, length(historias));
log.respuestas = cell(1, length(historias));
log.respuesta_PrimerMovimiento = cell(1, length(historias));

% ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
ListenChar(2);
HideCursor;
init_psych();

% ------------------- INICIO DEL PARADIGMA ----------------------------

% ------------------- + PARA CENTRAR VISTA ----------------------------

textoCentrado('+', tamanio_fijacion);
Screen('Flip', hd.window);
WaitSecs(TIEMPO_INICIAL_CENTRADO);

% ------------------- INTRODUCCION -----------------------------------

textoCentrado(INSTRUCCIONES, tamanio_fijacion);
[~, OnSetTime] = Screen('Flip', hd.window);
log.instrucciones_inicio = OnSetTime;
KbWait;
log.instrucciones_fin = GetSecs;


exit = false;
for i = 1:length(historias)

    % ------------------- + PARA CENTRAR VISTA ---------------------------

    textoCentrado('+', tamanio_fijacion);
    Screen('Flip', hd.window);
    WaitSecs(TIEMPO_PRE_HISTORIA);


    % ------------------- HISTORIA ---------------------------------------

    textoCentrado(historias{1,i}, tamanio_historia);
    [~, OnSetTime] = Screen('Flip', hd.window);
    log.historia_inicio{1,i} = OnSetTime;
    KbPressWait;
    log.historia_fin{1,i} = GetSecs;

    % ------------------- + PARA CENTRAR VISTA ---------------------------

    textoCentrado('+', tamanio_fijacion);
    Screen('Flip', hd.window);
    WaitSecs(TIEMPO_POST_HISTORIA);

    % ------------------- OPCIONES ---------------------------------------

    [exit, log_respuesta] = Respuesta(textos_opciones);
    
    if (exit)
        break;
    end
    
    log.respuesta_inicio{1,i} =log_respuesta.respuesta_inicio;
    log.respuesta_PrimerMovimiento{1,i} =log_respuesta.primer_movimiento;
    log.respuesta_fin{1,i} = log_respuesta.respuesta_fin;
    log.respuestas{1,i} = log_respuesta.respuesta;
    
end

% ---------------------- GUARDO LOG ----------------------------------

GuardarLog(log, nombre, version);

% ---------------------- FIN DEL PARADIGMA ---------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;

end
