function SocialLearning()

clc;
sca;
close all;
clearvars;
clear all;

%% LIBRERIAS

addpath('lib');

%% TECLAS

KbName('UnifyKeyNames');
teclas.salir = KbName('ESCAPE');
teclas.derecha = KbName('RightArrow');
teclas.izquierda = KbName('LeftArrow');
teclas.continuar = KbName('SPACE');
teclas.pausa = KbName('P');

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

secuencias = {'S1-N1-S2-N2' 'N1-S1-N2-S2' 'S2-N2-S1-N1' 'N2-S2-N1-S1'};
choice = menu('Secuencia:', secuencias);
secuencia = secuencias{choice};
secuencia = strsplit(secuencia, '-');
log.secuencia = secuencia;


%% INSTRUCCIONES
instrucciones_dir = fullfile('data','instrucciones');
instrucciones.principales = CargarTextosDeCarpeta(fullfile(instrucciones_dir, 'principales'));
instrucciones.practica = fileread(fullfile(instrucciones_dir, 'practica.txt'));
instrucciones.bloque = fileread(fullfile(instrucciones_dir, 'bloque.txt'));
instrucciones.tarea = fileread(fullfile(instrucciones_dir, 'tarea.txt'));
instrucciones.fin = fileread(fullfile(instrucciones_dir, 'fin.txt'));


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

TAMANIO_TEXTO = 0.1;
TAMANIO_INSTRUCCIONES = 0.03;

%% IMAGENES

texturas.figuras = CargarTexturasDeCarpetaNombre(fullfile('data', 'imagenes', 'figuras'), hd.window);
texturas.sujetos = CargarTexturasDeCarpetaNombre(fullfile('data', 'imagenes', genero), hd.window);
texturas.opciones = CargarTexturasDeCarpetaNombre(fullfile('data', 'imagenes','opciones'), hd.window);

%% INICIO DEL PARADIGMA

log.inicio = GetSecs;

% INSTRUCCIONES PRINCIPALES
for x = 1:length(instrucciones.principales)
    TextoCentrado(instrucciones.principales{x}, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip',hd.window);
    exit = EsperarBoton(teclas.continuar, teclas.salir);
    if exit
        Salir;
        return
    end
end

for x = 1:length(bloques)

    % INSTRUCCIONES INICIO DE BLOQUE
    if x ~= 1
        TextoCentrado(instrucciones.bloque, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip',hd.window);
        exit = EsperarBoton(teclas.continuar, teclas.salir);
        if exit
            break
        end
    end
    
    % PRACTICA
    TextoCentrado(instrucciones.practica, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip',hd.window);
    exit = EsperarBoton(teclas.continuar, teclas.salir);
    if exit
        break
    end

    [exit, ~] = CorrerCiclo(hd, bloques{x}.practica, texturas, teclas, []);
    if exit
        break
    end

    % TAREA
    TextoCentrado(instrucciones.tarea, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip',hd.window);
    exit = EsperarBoton(teclas.continuar, teclas.salir);
    if exit
        break
    end

    for i = 1:length(ciclos)
        [exit, log.bloques{x}{i}] = CorrerCiclo(hd, bloques{x}.ciclos{i}, texturas, teclas, log.bloques{x}{i});
        if exit
            break;
        end
    end
    if exit
        break
    end

end

log.preguntas = PreguntasEntendimiento(hd, texturas, teclas);

log.duracion = GetSecs - log.inicio;

%% FIN
TextoCentrado(instrucciones.fin, TAMANIO_INSTRUCCIONES, hd);
Screen('Flip',hd.window);
WaitSecs(1);

%% GUARDO LOG
log_file = PrepararLog('log', nombre, 'SocialLearningV1');
save(log_file, 'log');

%% SALIR
Salir;

end