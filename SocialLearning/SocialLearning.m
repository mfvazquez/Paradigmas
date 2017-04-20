clc;
sca;
close all;
clearvars;
clear all;

%% LIBRERIAS

addpath('lib');

%% CONSTANTES

global TAMANIO_INSTRUCCIONES
global TAMANIO_TEXTO

TAMANIO_TEXTO = 0.05;
TAMANIO_INSTRUCCIONES = 0.03;

%% TECLAS

KbName('UnifyKeyNames');
teclas.salir = KbName('ESCAPE');
teclas.derecha = KbName('RightArrow');
teclas.izquierda = KbName('LeftArrow');
teclas.continuar = KbName('SPACE');

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% GENERO

opciones = {'Femenino' 'Masculino'};
choice = menu('Genero:', opciones);
genero = opciones{choice};

%% BLOQUE
[opciones directorios] = ObtenerCategorias(fullfile('data','bloques'));
choice = menu('Bloques:', opciones);
bloque_dir = directorios{choice};
bloque = opciones{choice};

%% INSTRUCCIONES
instrucciones_dir = fullfile('data','instrucciones');
instrucciones.principales = fileread(fullfile(instrucciones_dir, 'principales.txt'));
instrucciones.practica = fileread(fullfile(instrucciones_dir, 'practica.txt'));
instrucciones.bloque = fileread(fullfile(instrucciones_dir, 'bloque.txt'));

%% PRACTICA
practica = CargarCSV(fullfile(bloque_dir,'practica.dat'), ';');

%% BLOQUES
ciclos_dir = fullfile(bloque_dir, 'ciclos');
ciclos_archivos = ArchivosDeCarpeta(ciclos_dir);
ciclos = cell(length(ciclos_archivos), 1);
for i = 1:length(ciclos_archivos)
    ciclos{i} = CargarCSV(fullfile(ciclos_dir,ciclos_archivos{i}), ';');
end
    

%% PSYCHOTOOLBOX
hd = init_psych;

%% IMAGENES

texturas.figuras = CargarTexturasDeCarpetaNombre(fullfile('data', 'imagenes', 'figuras'), hd.window);
texturas.sujetos = CargarTexturasDeCarpetaNombre(fullfile('data', 'imagenes', genero), hd.window);
texturas.opciones = CargarTexturasDeCarpetaNombre(fullfile('data', 'imagenes','opciones'), hd.window);

%% INICIO DEL PARADIGMA

% INSTRUCCIONES

TextoCentrado(instrucciones.principales, TAMANIO_INSTRUCCIONES, hd);
Screen('Flip',hd.window);
exit = EsperarBoton(teclas.continuar, teclas.salir);
if exit
    Salir;
    return
end

% PRACTICA

TextoCentrado(instrucciones.practica, TAMANIO_INSTRUCCIONES, hd);
Screen('Flip',hd.window);
exit = EsperarBoton(teclas.continuar, teclas.salir);
if exit
    Salir;
    return
end

exit = CorrerCiclo(hd, practica, texturas, teclas);
if exit
    Salir;
    return
end

% BLOQUES

TextoCentrado(instrucciones.bloque, TAMANIO_INSTRUCCIONES, hd);
Screen('Flip',hd.window);
exit = EsperarBoton(teclas.continuar, teclas.salir);
if exit
    Salir;
    return
end

for i = 1:length(ciclos)

    exit = CorrerCiclo(hd, ciclos{i}, texturas, teclas);
    if exit
        break;
    end
end
    

%% SALIR
Salir;