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

global pportobj pportaddr MARCA_DURACION MARCAS

global TAMANIO_INSTRUCCIONES
global TAMANIO_ESTIMULOS

global TIEMPO_FIJACION
global TIEMPO_VACIO_ALEATORIO
global TIEMPO_ESTIMULO
global TIEMPO_VACIO_FIN

global MARCA_PAUSA_INICIO
global MARCA_PAUSA_FIN

global EEG

EEG = false;

MARCA_PAUSA_INICIO = 254;
MARCA_PAUSA_FIN = 255;

MARCA_DURACION = 1e-3;

keySet =   {'L1wNeu', 'L1wAff', 'L1nwAff', 'L1nwNeu'};
valueSet = [1, 2, 3, 4];
MARCAS = containers.Map(keySet,valueSet);

TAMANIO_INSTRUCCIONES = 0.03;
TAMANIO_ESTIMULOS = 0.05;

TIEMPO_FIJACION = 0.3;
TIEMPO_VACIO_ALEATORIO = [0.5 0.7];
TIEMPO_ESTIMULO = 0.3;
TIEMPO_VACIO_FIN = 3.7;

%% PUERTO PARALELO

pportaddr = 'C020';

if EEG && exist('pportaddr','var') && ~isempty(pportaddr)
    fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
    pportaddr = hex2dec(pportaddr);

    pportobj = io32;
    io32status = io32(pportobj);
    EnviarMarca(0);
    if io32status ~= 0
        error('io32 failure: could not initialise parallel port.\n');
    end
end


%% BOTONES

KbName('UnifyKeyNames');
teclas.ExitKey = KbName('ESCAPE');
teclas.Negativo = KbName('RightArrow');
teclas.Afirmativo = KbName('LeftArrow');
teclas.Continuar = KbName('SPACE');
teclas.Pausa.inicio = KbName('P');
teclas.Pausa.fin = KbName('Q');

%% DATOS

vueltas = ArchivosDeCarpeta('data');
choice = menu('Vuelta:',vueltas);
vuelta = vueltas{choice};

vuelta_dir = fullfile('data',vuelta);
bloques_dir = ArchivosDeCarpeta(vuelta_dir);
bloques = cell(length(bloques_dir), 1);

for x = 1:length(bloques)
    dir_actual = fullfile(vuelta_dir, bloques_dir{x});
    % Instrucciones
    carpeta_instrucciones = fullfile(dir_actual, 'instrucciones');
    bloque_actual.instrucciones = [];
    if exist(carpeta_instrucciones, 'dir');
        bloque_actual.instrucciones = CargarTextosDeCarpeta(carpeta_instrucciones);
    end
    % Practica instrucciones
    archivo_practica_instrucciones = fullfile(dir_actual, 'practica.txt');
    bloque_actual.practica.instrucciones = [];
    if exist(archivo_practica_instrucciones, 'file')
        bloque_actual.practica.instrucciones = fileread(archivo_practica_instrucciones);
    end
    % Practica estimulos
    archivo_practica_estimulos = fullfile(dir_actual, 'practica.csv');
    bloque_actual.practica.estimulos = [];
    if exist(archivo_practica_estimulos, 'file')
        bloque_actual.practica.estimulos = CargarEstimulos(archivo_practica_estimulos, ';');
    end
    % Bloque instrucciones
    archivo_bloque_instrucciones = fullfile(dir_actual, 'bloque.txt');
    bloque_actual.bloque.instrucciones = [];
    if exist(archivo_bloque_instrucciones, 'file')
        bloque_actual.bloque.instrucciones = fileread(archivo_bloque_instrucciones);
    end
    % bloque estimulos
    archivo_bloque_estimulos = fullfile(dir_actual, 'bloque.csv');
    bloque_actual.bloque.estimulos = [];
    if exist(archivo_bloque_estimulos, 'file');
        bloque_actual.bloque.estimulos = CargarEstimulos(archivo_bloque_estimulos, ';');
    end
    
    bloques{x} = bloque_actual;
    
end


%% LOG
log = cell(length(bloques), 1);
for i = 1:length(bloques)
    log{i} = cell(length(bloques{i}.bloque.estimulos), 1);
end
%% INICIO PSYCHOTOOLBOX

hd = init_psych();
Screen('Flip', hd.window);

%% PARADIGMA

for x = 1:length(bloques)

    % Instrucciones 
    if ~isempty(bloques{x}.instrucciones)
        for y = 1:length(bloques{x}.instrucciones)
            TextoCentrado(bloques{x}.instrucciones{y}, TAMANIO_INSTRUCCIONES, hd);        
            Screen('Flip', hd.window);
            exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
            if exit
                break
            end
        end
        if exit
            break
        end    
    end
    
    % Practica
    if ~isempty(bloques{x}.practica.instrucciones)
        TextoCentrado(bloques{x}.practica.instrucciones, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
        if exit
            break
        end
    end
    
    if ~isempty(bloques{x}.practica.estimulos)
        [~, exit] = CorrerSecuencia(bloques{x}.practica.estimulos, hd, teclas, [], []);
        if exit
            break
        end
    end
    
    % Bloque
    if ~isempty(bloques{x}.bloque.instrucciones)
        TextoCentrado(bloques{x}.bloque.instrucciones, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        if ~isempty(log)
            marca = x;
            EnviarMarca(marca);
        end
        exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
        if exit
            break
        end
    end
    
    if ~isempty(bloques{x}.bloque.estimulos)
        [log{x}, exit] = CorrerSecuencia(bloques{x}.bloque.estimulos, hd, teclas, log{x}, x);
        if exit
            break
        end
    end

end


%% GUARDO LOG
nombre_archivo_log = PrepararLog('log', [nombre '_' vuelta], 'DecisionLexica_conductual');
save(nombre_archivo_log, 'log');
% Log2Celda(log, [nombre_archivo_log(1:end-3) 'csv']);

Salir;

end