function DecisionLexica()
clc;
sca;
close all;
clearvars;

%% LIBRERIAS

addpath('lib');

%% CONSTANTES GLOBALES

global hd
global ExitKey
global AfirmativeKey
global NegativeKey

global SEPARACION_PALABRAS
global TAMANIO_TEXTO


%% CONSTANTES

KbName('UnifyKeyNames');
ExitKey = KbName('ESCAPE');

AfirmativeKey = KbName('LeftArrow');
NegativeKey = KbName('RightArrow');

SEPARACION_PALABRAS = 0.05;
TAMANIO_TEXTO = 0.08;

TAMANIO_INSTRUCCIONES = 0.03;

MENSAJE_PRACTICA = 'Hagamos una tanda de pr�ctica.\n\nPresione cualquier tecla para comenzar.';
MENSAJE_BLOQUES = '�Listo para la prueba?\n\nPresione cualquier tecla para comenzar.';

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% IDIOMA

idiomas_dir = fullfile('data', 'idiomas');
idiomas = ArchivosDeCarpeta(idiomas_dir);
choice = menu('Idioma:',idiomas);
idioma = idiomas{choice};

%% INSTRUCCIONES
instrucciones_carpeta = fullfile('data','instrucciones');
instrucciones = CargarTextosDeCarpeta(instrucciones_carpeta);

%% DATOS

datos_dir = fullfile(idiomas_dir, idioma);
practica_archivo = fullfile(datos_dir, 'practica.csv');
bloques_dir = fullfile(datos_dir, 'bloques');

secuencia_practica = CargarBloque(practica_archivo);
secuencia_bloques = CargarBloquesDeCarpeta(bloques_dir);

AUXILIAR = fileread(fullfile(datos_dir, 'auxiliar.txt'));

%% LOG

log = cell(1, length(secuencia_bloques));
for i = 1:length(secuencia_bloques)
    log{i} = cell(length(secuencia_bloques{i}), 1);
end

%% INICIO PSYCHOTOOLBOX

hd = init_psych();
Screen('Flip', hd.window);

%% INSTRUCCIONES

for i = 1:length(instrucciones)
    TextoCentrado(instrucciones{i}, TAMANIO_INSTRUCCIONES);
    Screen('Flip', hd.window);
    KbStrokeWait;
end


%% PRACTICA
TextoCentrado(MENSAJE_PRACTICA, TAMANIO_INSTRUCCIONES);
Screen('Flip', hd.window);
KbStrokeWait;
exit = CorrerBloque(secuencia_practica, AUXILIAR);

%% BLOQUES
if ~exit
    TextoCentrado(MENSAJE_BLOQUES, TAMANIO_INSTRUCCIONES);
    Screen('Flip', hd.window);
    KbStrokeWait;
    for i = 1:length(secuencia_bloques)
        [~, log{i}] = CorrerBloque(secuencia_bloques{i}, AUXILIAR, log{i});
    end 
end

%% GUARDO LOG

nombre_archivo_log = PrepararLog('log', nombre, 'DecisionLexica', idioma);
save(nombre_archivo_log, 'log');

Salir;
end