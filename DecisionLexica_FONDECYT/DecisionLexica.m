function DecisionLexica()

clc;
sca;
close all;
clearvars;

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

TAMANIO_INSTRUCCIONES = 0.03;
TAMANIO_ESTIMULOS = 0.05;

TIEMPO_ESTIMULO = 0.15;
TIEMPO_VACIO = 2.5;
TIEMPO_ESPERA = [1.5 2.5];

TEXTO_PAUSA = 'Es momento de una pausa.\n\n\n Descanse y presione la ESPACIO para continuar';

%% BOTONES

KbName('UnifyKeyNames');
teclas.ExitKey = KbName('ESCAPE');
teclas.Afirmativo = 192; %Numero de boton de la tecla Ñ
teclas.Negativo = KbName('L');
teclas.Continuar = KbName('SPACE');

%% DATOS

practica_instrucciones = fileread(fullfile('data', 'practica_instrucciones.txt'));
bloque_instrucciones = fileread(fullfile('data', 'bloque_instrucciones.txt'));

vueltas_dir = fullfile('data', 'vueltas');
vueltas = ArchivosDeCarpeta(vueltas_dir);
choice = menu('Vuelta:',vueltas);
vuelta = vueltas{choice};

datos_dir = fullfile('data','vueltas',vuelta);
bloques_dir = ArchivosDeCarpeta(datos_dir);
bloques = cell(length(bloques_dir), 1);
for x = 1:length(bloques)
    aux.practica = CargarEstimulos(fullfile(datos_dir, bloques_dir{x}, 'practica.csv'), ';');
    aux.estimulos = CargarEstimulos(fullfile(datos_dir, bloques_dir{x}, 'estimulos.csv'), ';');
    bloques{x} = aux;
end

%% LOG
log = cell(length(bloques), 1);
for i = 1:length(bloques)
    log{i} = cell(length(bloques{i}.estimulos), 1);
end
%% INICIO PSYCHOTOOLBOX

hd = init_psych();
Screen('Flip', hd.window);

%% PARADIGMA

for x = 1:length(bloques)

    TextoCentrado(practica_instrucciones, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        break
    end
    [~, exit] = CorrerSecuencia(bloques{x}.practica, hd, teclas, []);
    if exit
        break
    end
    
    TextoCentrado(bloque_instrucciones, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        break
    end
    [log{x}, exit] = CorrerSecuencia(bloques{x}.estimulos, hd, teclas, log{x});
    if exit
        break
    end
    
    if x ~= length(bloques)
        TextoCentrado(TEXTO_PAUSA, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
        if exit
            break
        end

    end

end


%% GUARDO LOG
nombre_archivo_log = PrepararLog('log', nombre, 'DecisionLexica_FONDECYT');
save(nombre_archivo_log, 'log');

Salir;

end