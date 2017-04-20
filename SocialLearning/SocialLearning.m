function SocialLearning()

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
log.genero = genero;

%% BLOQUE
[opciones directorios] = ObtenerCategorias(fullfile('data','bloques'));
choice = menu('Bloques:', opciones);
bloque_dir = directorios{choice};
bloque = opciones{choice};
log.bloque = bloque;

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
    
%% LOG
log.ciclos = cell(1,length(ciclos));
for i = 1:length(ciclos)
    log.ciclos{i} = cell(1,length(ciclos{i}));
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

[exit, ~] = CorrerCiclo(hd, practica, texturas, teclas, []);
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

    [exit, log.ciclos{i}] = CorrerCiclo(hd, ciclos{i}, texturas, teclas, log.ciclos{i});
    if exit
        break;
    end
end

%% GUARDO LOG
log_file = PrepararLog('log', nombre, ['SocialLearning_' bloque]);
save(log_file, 'log');

%% SALIR
Salir;

end