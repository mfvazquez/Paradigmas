function DecisionLexica()

clc;
sca;
clear all;
close all;

%% LIBRERIAS

addpath('lib');

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% CONSTANTES GLOBALES

global TAMANIO_INSTRUCCIONES
global TAMANIO_ESTIMULOS

global TIEMPO_ESTIMULO
global TIEMPO_VACIO
global TIEMPO_ESPERA

global EEG
EEG = false;

TAMANIO_INSTRUCCIONES = 0.03;
TAMANIO_ESTIMULOS = 0.05;

TIEMPO_ESTIMULO = 0.3;
TIEMPO_VACIO = 2.5;
TIEMPO_ESPERA = [1.5 2.5];


%% BOTONES

KbName('UnifyKeyNames');
teclas.ExitKey = KbName('ESCAPE');
teclas.Negativo = KbName('N');
teclas.Afirmativo = KbName('M');
teclas.Continuar = KbName('SPACE');
teclas.Pausa.inicio = KbName('P');
teclas.Pausa.fin = KbName('Q');

%% DATOS

dir_actual = 'data';
% Instrucciones
bloque_actual.instrucciones = CargarTextosDeCarpeta(fullfile(dir_actual, 'instrucciones'));
% Practica
bloque_actual.practica.instrucciones = fileread(fullfile(dir_actual, 'practica.txt'));
bloque_actual.practica.estimulos = CargarEstimulos(fullfile(dir_actual, 'practica.csv'), ';');
% Bloque
bloque_actual.bloque.instrucciones = fileread(fullfile(dir_actual, 'bloque.txt'));
bloque_actual.bloque.estimulos = CargarEstimulos(fullfile(dir_actual, 'bloque.csv'), ';');

bloque = bloque_actual;
    
MENSAJE_DESPEDIDA = 'Hemos terminado esta tarea \n ¡Muchas gracias!\n\n\n\nPulse ESPACIO para finalizar.';


%% LOG

log = cell(length(bloque.bloque.estimulos), 1);
%% INICIO PSYCHOTOOLBOX

hd = init_psych();
Screen('Flip', hd.window);

%% PARADIGMA

% Instrucciones 
for y = 1:length(bloque.instrucciones)
    TextoCentrado(bloque.instrucciones{y}, TAMANIO_INSTRUCCIONES, hd);        
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        break
    end
end 

% Practica
if ~exit
    TextoCentrado(bloque.practica.instrucciones, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
end

if ~exit
    [~, exit] = CorrerSecuencia(bloque.practica.estimulos, hd, teclas, []);
end

% Bloque
if ~exit
    TextoCentrado(bloque.bloque.instrucciones, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
end

if ~exit
    [log, ~] = CorrerSecuencia(bloque.bloque.estimulos, hd, teclas, log);
end

TextoCentrado(MENSAJE_DESPEDIDA, TAMANIO_INSTRUCCIONES, hd);    
Screen('Flip', hd.window);    
EsperarBoton(teclas.Continuar, teclas.ExitKey);

%% GUARDO LOG
nombre_archivo_log = PrepararLog('log', nombre, 'DecisionLexica');
save(nombre_archivo_log, 'log');
% Log2Celda(log, [nombre_archivo_log(1:end-3) 'csv']);

Salir;

end