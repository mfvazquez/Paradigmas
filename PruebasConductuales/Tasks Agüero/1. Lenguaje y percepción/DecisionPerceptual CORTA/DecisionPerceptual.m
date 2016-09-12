function DecisionPerceptual()

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

global SEPARACION
global TAMANIO_TEXTO


%% CONSTANTES

KbName('UnifyKeyNames');
ExitKey = KbName('ESCAPE');
AfirmativeKey = KbName('LeftArrow');
NegativeKey = KbName('RightArrow');

SEPARACION = 0.1;
TAMANIO_TEXTO = 0.08;

TAMANIO_INSTRUCCIONES = 0.03;

MENSAJE_PRACTICA = 'Hagamos una tanda de práctica.\n\nPresione cualquier tecla para comenzar.';
MENSAJE_BLOQUES = '¿Listo para la prueba?\n\nPresione cualquier tecla para comenzar.';

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};


%% INSTRUCCIONES
instrucciones_carpeta = fullfile('data','instrucciones');
instrucciones = CargarTextosDeCarpeta(instrucciones_carpeta);

%% DATOS

datos_dir = fullfile('data');
practica_archivo = fullfile(datos_dir, 'practica.csv');
bloques_dir = fullfile(datos_dir, 'bloques');

secuencia_practica = CargarBloque(practica_archivo);
secuencia_bloques = CargarBloquesDeCarpeta(bloques_dir);

%% INICIO PSYCHOTOOLBOX

hd = init_psych();
Screen('Flip', hd.window);

%% IMAGENES

texturas.flecha = CargarTextura(fullfile('data','imagenes','flecha.jpg'));
texturas.rect = CargarTextura(fullfile('data','imagenes','rect.jpg'));
texturas.tri = CargarTextura(fullfile('data','imagenes','tri.jpg'));

%% LOG

log = cell(1, length(secuencia_bloques));


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
exit = CorrerBloque(secuencia_practica, texturas);

%% BLOQUES
TextoCentrado(MENSAJE_BLOQUES, TAMANIO_INSTRUCCIONES);
Screen('Flip', hd.window);
KbStrokeWait;
if ~exit
    for i = 1:length(secuencia_bloques)
        [~, log] = CorrerBloque(secuencia_bloques{i}, texturas, log);
    end
end

%% GUARDO LOG

nombre_archivo_log = PrepararLog('log', nombre, 'DecisionPerceptual');
save(nombre_archivo_log, 'log');

Salir;

end