function Moral()

clc;
sca;
close all;
clearvars;

addpath(fullfile('..','lib'));

% -------------------- CONSTANTES -------------------------------------

LARGO_OPCIONES = 35;
LINEAS_HISTORIA = 15;
LARGO_LINEA = 55;

textos_conducta.pregunta = '¿En términos de conducta moral, cómo calificaría la acción de Juan?';
textos_conducta.pregunta = AgregarFinLinea(textos_conducta.pregunta, LARGO_OPCIONES);
textos_conducta.minimo = 'Totalmente mala';
textos_conducta.medio = 'Neutral';
textos_conducta.maximo = 'Totalmente buena';

textos_danio.pregunta = '¿Qué tan dañino considera que fue el resultado de la acción de Juan?';
textos_danio.pregunta = AgregarFinLinea(textos_danio.pregunta, LARGO_OPCIONES);
textos_danio.minimo = 'Nada dañino';
textos_danio.medio = 'Neutral';
textos_danio.maximo = 'Muy dañino';

tamanio_fijacion = 0.05;
tamanio_historia = 0.035;


INSTRUCCIONES = 'A continuación se le presentarán una serie de situaciones. Por favor léalas y responda las preguntas usando las escalas correspondientes. Para responder utilice las flechas izquierda y derecha del teclado. Para confirmar su respuesta, presione la flecha hacia abajo.';
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

% nombre = inputdlg('Nombre:');
% nombre = nombre{1};

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

textoCentrado('Cargando Datos...', 0.04);
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

% log.version = version;
% log.historia_inicio = cell(1, length(historias));
% log.historia_fin = cell(1, length(historias));
%       
% log.conducta_inicio = cell(1, length(historias));
% log.conducta_fin = cell(1, length(historias));
% log.conducta_respuesta = cell(1, length(historias));
% log.conducta_PrimerMovimiento = cell(1, length(historias));
% 
% log.danio_inicio = cell(1, length(historias));
% log.danio_fin = cell(1, length(historias));
% log.danio_respuesta = cell(1, length(historias));
% log.danio_PrimerMovimiento = cell(1, length(historias));

%% ------------------- INICIO DEL PARADIGMA ----------------------------

% ------------------- INTRODUCCION -----------------------------------

% textoCentrado(INSTRUCCIONES, tamanio_fijacion);
% [~, OnSetTime] = Screen('Flip', hd.window);
% log.instrucciones_inicio = OnSetTime;
% KbPressWait;
% log.instrucciones_fin = GetSecs;

exit = false;
for i = 1:length(historias)


    % ------------------- HISTORIA ---------------------------------------

    log.historia_inicio{1,i} = GetSecs;
    for x = 1:length(historias{1,i})
        textoCentrado(historias{1,i}{x}, tamanio_historia);
        Screen('Flip', hd.window);
        KbPressWait;
    end
    log.historia_fin{1,i} = GetSecs;
    
    
%     % ------------------- PREGUNTA CONDUCTA ------------------------------
% 
%     [exit, log_respuesta] = Respuesta(textos_conducta);
%     
%     if (exit)
%         break;
%     end
%     
%     log.conducta_inicio{1,i} =log_respuesta.respuesta_inicio;
%     log.conducta_PrimerMovimiento{1,i} =log_respuesta.primer_movimiento;
%     log.conducta_fin{1,i} = log_respuesta.respuesta_fin;
%     log.conducta_respuesta{1,i} = log_respuesta.respuesta;
%     
    % ------------------- PREGUNTA DANIO ---------------------------------

%     [exit, log_respuesta] = Respuesta(textos_danio);
%     
%     if (exit)
%         break;
%     end
%     
%     log.danio_inicio{1,i} =log_respuesta.respuesta_inicio;
%     log.danio_PrimerMovimiento{1,i} =log_respuesta.primer_movimiento;
%     log.danio_fin{1,i} = log_respuesta.respuesta_fin;
%     log.danio_respuesta{1,i} = log_respuesta.respuesta;
    
end

% ---------------------- GUARDO LOG ----------------------------------

% textoCentrado('Guardando Datos...', 0.04);
% Screen('Flip', hd.window);
% 
% GuardarLog(log, nombre, version);

% ---------------------- FIN DEL PARADIGMA ---------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;

end
