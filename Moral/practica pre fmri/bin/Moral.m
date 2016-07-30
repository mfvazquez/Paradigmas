function Moral()

clc;
sca;
close all;
clearvars;

addpath(fullfile('..','lib'));

% -------------------- CONSTANTES -------------------------------------

LARGO_OPCIONES = 40;
LINEAS_HISTORIA = 5;
LARGO_LINEA = 30;

TIEMPO_INICIAL_CENTRADO = 8;
TIEMPO_PRE_HISTORIA = 1;
TIEMPO_POST_HISTORIA = 6;

TAMANIO = 0.075;

textos_opciones.pregunta = '¿Cuanto castigo considera que merece Juan?';
textos_opciones.minimo = 'Ningún castigo';
textos_opciones.medio = 'Neutral';
textos_opciones.maximo = 'Mucho castigo';

INSTRUCCIONES = 'A continuación se le presentarán una serie de situaciones. Por favor léalas y responda las preguntas usando las escalas correspondientes. Presione el boton rojo para continuar.';
INSTRUCCIONES = AgregarFinLinea(INSTRUCCIONES, LARGO_LINEA);

MENSAJE_FINAL = 'La prueba ha terminado, ahora por favor espere unos minutos mientras termina el registro. Trate de no pensar en nada.';
MENSAJE_FINAL = AgregarFinLinea(MENSAJE_FINAL, LARGO_LINEA);

% -------------------- TECLAS A UTILIZAR -------------------------------

global hd; 
global rightKey;
global leftKey;
global spaceKey;
global auxKey;
global botones;
global escKey;

leftKey = '1';
rightKey =  '2';
auxKey = '3';
spaceKey = '4';

escKey = 'x';

triggerKey = '5';

botones = [leftKey rightKey auxKey spaceKey];

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

%% ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
ListenChar(2);
HideCursor;
hd = init_psych();


%% -------------- CARGO DATOS -------------------------------------------

textoCentrado('Cargando Datos...', TAMANIO);
Screen('Flip', hd.window);

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
    historias{1,i} = SepararHistoria(historias{1,i}, LINEAS_HISTORIA);
end

% ------------------- RESERVO ESPACIO PARA EL LOG ---------------------

log.version = version;
log.historia_inicio = cell(1, length(historias));
log.historia_fin = cell(1, length(historias));

log.respuesta_inicio = cell(1, length(historias));
log.respuesta_fin = cell(1, length(historias));
log.respuestas = cell(1, length(historias));
log.respuesta_PrimerMovimiento = cell(1, length(historias));

% ------------------- INTRODUCCION -----------------------------------

textoCentrado(INSTRUCCIONES, TAMANIO);
[~, OnSetTime] = Screen('Flip', hd.window);
log.instrucciones_inicio = OnSetTime;
exit = ButtonWait(spaceKey);
if exit
    Salir;
    return;
end
log.instrucciones_fin = GetSecs;


%% -------------------- ESPERO AL RESONADOR ---------------------------
textoCentrado('Esperando al resonador...', TAMANIO);
Screen('Flip', hd.window);
exit = ButtonWait(triggerKey);
if exit
    Salir;
    return;
end

%% ------------------- INICIO DEL PARADIGMA ----------------------------
% ------------------- + PARA CENTRAR VISTA ----------------------------

textoCentrado('+', TAMANIO);
Screen('Flip', hd.window);
WaitSecs(TIEMPO_INICIAL_CENTRADO);


exit = false;
for i = 1:length(historias)


    % ------------------- + PARA CENTRAR VISTA ---------------------------

    textoCentrado('+', TAMANIO);
    Screen('Flip', hd.window);
    WaitSecs(TIEMPO_PRE_HISTORIA);
    
    % ------------------- HISTORIA ---------------------------------------

    log.historia_inicio{1,i} = GetSecs;
    for x = 1:length(historias{1,i})
        textoCentrado(historias{1,i}{x}, TAMANIO);
        Screen('Flip', hd.window);
        exit = ButtonWait(spaceKey);
        if exit
            break;
        end
    end
    if exit
        break;
    end
    log.historia_fin{1,i} = GetSecs;

%          ------------------- + PARA CENTRAR VISTA ---------------------------

    textoCentrado('+', TAMANIO);
    Screen('Flip', hd.window);
    WaitSecs(TIEMPO_POST_HISTORIA);
    
    % ------------------- PREGUNTA CONDUCTA ------------------------------

    [exit, log_respuesta] = Respuesta(textos_opciones);
    if exit
        break;
    end
    
    log.respuesta_inicio{1,i} =log_respuesta.respuesta_inicio;
    log.respuesta_PrimerMovimiento{1,i} =log_respuesta.primer_movimiento;
    log.respuesta_fin{1,i} = log_respuesta.respuesta_fin;
    log.respuestas{1,i} = log_respuesta.respuesta;
    
end

% ---------------------- GUARDO LOG ----------------------------------

textoCentrado(MENSAJE_FINAL, TAMANIO);
Screen('Flip', hd.window);

GuardarLog(log, nombre, version);

% ---------------------- FIN DEL PARADIGMA ---------------------------

WaitSecs(10);
Screen('Flip', hd.window);
ButtonWait(triggerKey);
Salir;

end
