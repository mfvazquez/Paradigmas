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

global TIEMPO_ESTIMULO
global TIEMPO_VACIO
global TIEMPO_ESPERA

global MARCA_PAUSA_INICIO
global MARCA_PAUSA_FIN

MARCA_PAUSA_INICIO = 254;
MARCA_PAUSA_FIN = 255;

MARCA_DURACION = 1e-3;

keySet =   {'Wman', 'Wnman', 'Wabs', 'nWman', 'nWnman', 'nWabs'};
valueSet = [1, 2, 3, 4, 5, 6];
MARCAS = containers.Map(keySet,valueSet);

TAMANIO_INSTRUCCIONES = 0.03;
TAMANIO_ESTIMULOS = 0.05;

TIEMPO_ESTIMULO = 0.3;
TIEMPO_VACIO = 2.5;
TIEMPO_ESPERA = [1.5 2.5];

TEXTO_PAUSA = 'Es momento de una pausa.\n\n\n Descanse y presione la ESPACIO para continuar';

%% PUERTO PARALELO

pportaddr = 'C020';

if exist('pportaddr','var') && ~isempty(pportaddr)
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
teclas.Negativo = KbName('LeftArrow');
teclas.Afirmativo = KbName('RightArrow');
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
    bloque_actual.instrucciones = CargarTextosDeCarpeta(fullfile(dir_actual, 'instrucciones'));
    % Practica
    bloque_actual.practica.instrucciones = fileread(fullfile(dir_actual, 'practica.txt'));
    bloque_actual.practica.estimulos = CargarEstimulos(fullfile(dir_actual, 'practica.csv'), ';');
    % Bloque
    bloque_actual.bloque.instrucciones = fileread(fullfile(dir_actual, 'bloque.txt'));
    bloque_actual.bloque.estimulos = CargarEstimulos(fullfile(dir_actual, 'bloque.csv'), ';');
    
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
    
    % Practica
    TextoCentrado(bloques{x}.practica.instrucciones, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        break
    end
    
    [~, exit] = CorrerSecuencia(bloques{x}.practica.estimulos, hd, teclas, [], []);
    if exit
        break
    end
    
    % Bloque
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
    [log{x}, exit] = CorrerSecuencia(bloques{x}.bloque.estimulos, hd, teclas, log{x}, x);
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
nombre_archivo_log = PrepararLog('log', [nombre '_' vuelta], 'DecisionLexica_FONDECYT');
save(nombre_archivo_log, 'log');
Log2Celda(log, [nombre_archivo_log(1:end-3) 'csv']);

Salir;

end