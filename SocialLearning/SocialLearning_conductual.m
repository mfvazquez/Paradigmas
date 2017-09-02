function SocialLearning_conductual()

clc;
sca;
close all;
clearvars;
clear;

%% LIBRERIAS

% PsychDebugWindowConfiguration

addpath('lib');

%% TECLAS

KbName('UnifyKeyNames');
teclas.salir = KbName('ESCAPE');
teclas.derecha = KbName('RightArrow');
teclas.izquierda = KbName('LeftArrow');
teclas.continuar = KbName('SPACE');
teclas.pausa.inicio = KbName('P');
teclas.pausa.fin = KbName('Q');

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};
log.nombre = nombre;

%% GENERO

opciones = {'Femenino' 'Masculino'};
choice = menu('Genero:', opciones);
genero = opciones{choice};
log.genero = genero;

%% BLOQUE
codificador = containers.Map({'S1' 'S2' 'S3' 'NS1' 'NS2' 'NS3'}, 1:6);
secuencias = {'S1-NS1-S2-NS2-S3-NS3' 'NS1-S1-NS2-S2-NS3-S3' 'S1-NS1-S3-NS3-S2-NS2' 'NS1-S1-NS3-S3-NS2-S2' 'S2-NS2-S1-NS1-S3-NS3' 'NS2-S2-NS1-S1-NS3-S3' 'S2-NS2-S3-NS3-S1-NS1' 'NS2-S2-NS3-S3-NS1-S1' 'S3-NS3-S1-NS1-S2-NS2' 'NS3-S3-NS1-S1-NS2-S2' 'S3-NS3-S2-NS2-S1-NS1' 'NS3-S3-NS2-S2-NS1-S1'};
choice = menu('Secuencia:', secuencias);
secuencia = secuencias{choice};
secuencia = strsplit(secuencia, '-');
marcas_bloque = zeros(1,6);
for x = 1:length(marcas_bloque)
    marcas_bloque(x) = codificador(secuencia{x}); 
end
log.secuencia = secuencia;

%% INSTRUCCIONES
instrucciones_dir = fullfile('data','instrucciones');

instrucciones.principales = CargarInstruccionesDir(fullfile(instrucciones_dir, 'principales'));
instrucciones.practica = CargarInstruccion(fullfile(instrucciones_dir, 'practica.txt'));
instrucciones.bloque = CargarInstruccion(fullfile(instrucciones_dir, 'bloque.txt'));
instrucciones.tarea = CargarInstruccion(fullfile(instrucciones_dir, 'tarea.txt'));
instrucciones.fin = CargarInstruccion(fullfile(instrucciones_dir, 'fin.txt'));

%% BLOQUES

bloques = cell(length(secuencia),1);
for x = 1:length(secuencia)
    bloque_dir = fullfile('data','bloques',secuencia{x});
    
    % PRACTICA
    archivo_practica = fullfile(bloque_dir,'practica.dat');
    bloque_actual.practica = CargarCSV(archivo_practica, ';');
    
    % CICLOS
    ciclos_dir = fullfile(bloque_dir, 'ciclos');
    ciclos_archivos = ArchivosDeCarpeta(ciclos_dir);
    ciclos = cell(length(ciclos_archivos), 1);
    for i = 1:length(ciclos_archivos)
        ciclos{i} = CargarCSV(fullfile(ciclos_dir,ciclos_archivos{i}), ';');
    end
    bloque_actual.ciclos = ciclos;
    

    bloques{x} = bloque_actual;
end
    
%% LOG
log.bloques = cell(1,length(bloques));
for x = 1:length(bloques)
    log.bloques{x} = cell(1,length(ciclos));
    for i = 1:length(ciclos)
        log.bloques{x}{i} = cell(1,length(ciclos{i}));
    end
end

%% PSYCHOTOOLBOX
global hd
hd = init_psych;

%% CONSTANTES

global TAMANIO_INSTRUCCIONES
global TAMANIO_TEXTO
global TAMANIO_CRUZ

TAMANIO_CRUZ = 0.1;
TAMANIO_TEXTO = 0.1;
TAMANIO_INSTRUCCIONES = 0.03;


global MARCA_PAUSA_INICIO
global MARCA_PAUSA_FIN

MARCA_PAUSA_INICIO = 254;
MARCA_PAUSA_FIN = 255;

global PROPORCION_MARGEN
% PRIMER ELEMENTO ES ANCHO Y SEGUNDO ELEMENTO ES LA ALTURA

% define el tamaño del margen relativo al tamaño del monitor. 
% Ej si es [5 3] habra 1/5 del ancho del monitor que estara en 
% blanco del lado izquierdo y derecho. Lo mismo para la altura pero con 1/3
PROPORCION_MARGEN = [3.5 2.5]; 


%% IMAGENES

texturas.figuras = CargarTexturasDeCarpetaNombre(fullfile('data', 'imagenes', 'figuras'), hd.window);
texturas.sujetos = CargarTexturasDeCarpetaNombre(fullfile('data', 'imagenes', genero), hd.window);
texturas.opciones = CargarTexturasDeCarpetaNombre(fullfile('data', 'imagenes','opciones'), hd.window);

%% PUERTO PARALELO

global pportobj pportaddr MARCA_DURACION EEG

EEG = false;

MARCA_DURACION = 1e-3;
pportaddr = 'C020';

if EEG

    if exist('pportaddr','var') && ~isempty(pportaddr)
        fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
        pportaddr = hex2dec(pportaddr);

        pportobj = io64;
        io64status = io64(pportobj);
        EnviarMarca(0);
        if io64status ~= 0
            error('io64 failure: could not initialise parallel port.\n');
        end
    end
end

%% INICIO DEL PARADIGMA

log.inicio = GetSecs;

% INSTRUCCIONES PRINCIPALES

for x = 1:length(instrucciones.principales)
    
	PresentarInstruccion(hd, instrucciones.principales{x}, texturas);
        
    Screen('Flip',hd.window);
    
    exit = EsperarBoton(teclas.continuar, teclas.salir);
    if exit
        Salir;
        return
    end
    
end

log_file = PrepararLog('log', nombre, 'SocialLearning');

for x = 1:length(bloques)

    % INSTRUCCIONES INICIO DE BLOQUE
    if x ~= 1
        PresentarInstruccion(hd, instrucciones.bloque, texturas);
        Screen('Flip',hd.window);
        exit = EsperarBoton(teclas.continuar, teclas.salir);
        if exit
            break
        end
    end
    
    % PRACTICA
    PresentarInstruccion(hd, instrucciones.practica, texturas);
    Screen('Flip',hd.window);
    exit = EsperarBoton(teclas.continuar, teclas.salir);
    if exit
        break
    end

    [exit, ~] = CorrerCiclo(hd, bloques{x}.practica, texturas, teclas, [], []);
    if exit
        break
    end

    % TAREA
    PresentarInstruccion(hd, instrucciones.tarea, texturas);
    Screen('Flip',hd.window);
    exit = EsperarBoton(teclas.continuar, teclas.salir);
    if exit
        break
    end
    for i = 1:length(ciclos)
        marca = (i + (marcas_bloque(x)-1)*length(ciclos));
        [exit, log.bloques{x}{i}] = CorrerCiclo(hd, bloques{x}.ciclos{i}, texturas, teclas, log.bloques{x}{i}, marca);
        if exit
            break;
        end
    end
    save(log_file, 'log');
    if exit
        break 
    end

end

log.preguntas = PreguntasEntendimiento(hd, texturas, teclas);

log.duracion = GetSecs - log.inicio;

%% FIN
PresentarInstruccion(hd, instrucciones.fin, texturas);
Screen('Flip',hd.window);
WaitSecs(1);

save(log_file, 'log');

%% SALIR
Salir;

end