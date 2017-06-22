function EMorphing()
clc;
sca;
close all;
clearvars;
clear all;

%% LIBRERIAS

addpath('lib');

%% ELEGIR BLOQUE
bloques = ArchivosDeCarpeta(fullfile('data','bloques'));
choice = menu('Bloque:',bloques);
bloque_carpeta = bloques{choice};

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};
log.nombre = nombre;


%% PSYCHOTOOLBOX
hd = init_psych;

%% CONSTANTES
global TAMANIO_TEXTO

TAMANIO_TEXTO = 0.025;


%% BOTONES
KbName('UnifyKeyNames');
botones.salir = KbName('ESCAPE');
botones.continuar = KbName('return');
botones.aceptar = KbName('SPACE');
botones.opciones = [49:54]; % teclas del 1 al 6 que no son del numpad


%% CARGO LAS TEXTURAS
sujetos = [1 2 3 5 7 8 9 10];
emociones = {'alegria' 'asco' 'ira' 'miedo' 'sorpresa' 'tristeza'};
rango = [0 20];

texturas = cell(sujetos(end), 1);
for x = sujetos
    for y = 1:length(emociones)        
        texturas_actuales = cell(rango(end)- rango(1) + 1,1);
        for z = 1:length(texturas_actuales)
            actual = [num2str(x) emociones{y} num2str(z+rango(1)-1) '.jpg'];
            texturas_actuales{z} =  CargarTextura(fullfile('data','imagenes', actual), hd.window);
        end
        sujeto_actual.(emociones{y}) = texturas_actuales;
    end
    texturas{x} = sujeto_actual;
end

%% CARGO TEXTOS

% INSTRUCCIONES
instrucciones = fileread(fullfile('data','bloques',bloque_carpeta,'instrucciones.txt'));

% OPCIONES
texto_opciones = fileread(fullfile('data','bloques',bloque_carpeta,'pregunta.txt'));
log.opciones = texto_opciones;
%% CARGO BLOQUE

bloque = CargarCSV(fullfile('data','bloques',bloque_carpeta,'estimulos.csv'), ';');
for x = 1:length(bloque)
    bloque{x,1} = str2double(bloque{x,1});
end

%% PREPARO LOG

log.bloque = cell(length(bloque),1);
for x = 1:length(log.bloque)
    % IMAGENES
    log_trial.on_set = cell(rango(end)-rango(1)+1,1);
    log_trial.tiempo_respuesta = [];
    log_trial.reaction_time = [];
    log_trial.emocion = [];
    log_trial.sujeto = [];
    
    % PREGUNTAS CON OPCIONES
    log_trial.opcaiones_on_set = [];
    log_trial.opciones_respuesta_tiempo = [];
    log_trial.opciones_respuesta_reaction_time = [];
    log_trial.opciones_emocion_elegida_numero = [];
    log_trial.opciones_emocion_elegida = [];
    
    log.bloque{x} = log_trial;
end

%% INICIO PARADIGMA
% INSTRUCCIONES
TextoCentrado(instrucciones, TAMANIO_TEXTO, hd);
Screen('Flip', hd.window);
[exit, ~] = EsperarBotonesApretar(botones.salir, botones.continuar);
if exit
    Salir;
    return
end
% BLOQUE
[~, log.bloque] = CorrerBloque(hd, texturas, botones, bloque, texto_opciones, log.bloque);

%% GUARDO LOG
log_file = PrepararLog('log', nombre, ['EMorphing_Bloque' bloque_carpeta]);
save(log_file, 'log');

Salir;

end
