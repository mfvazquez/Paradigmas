function InteroPriming()

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

global hd BLINK_DURATION IEEG

IEEG = true;

BLINK_DURATION = 20e-3;

TAMANIO_TEXTO = 0.05;
TAMANIO_INSTRUCCIONES = 0.03; 

TIEMPO_MOTOR_PRACTICA = 30;
TIEMPO_MOTOR = 120;

%% TECLAS

KbName('UnifyKeyNames');
teclas.ExitKey = KbName('ESCAPE');
teclas.LatidosKey = KbName('Z'); 
teclas.botones_salteado = [KbName('P') KbName('Q')];
teclas.RightKey = KbName('RightArrow');
teclas.LeftKey = KbName('LeftArrow');
teclas.DownKey = KbName('DownArrow');
teclas.UpKey = KbName('UpArrow');
teclas.EnterKey = KbName('DownArrow');  
teclas.Continuar = KbName('SPACE');

teclas.emociones = {KbName('LeftArrow') KbName('DownArrow') KbName('RightArrow')};
emociones_textos_botones = {'Negativa' 'Neutral' 'Positiva'; 'izquierda' 'abajo' 'derecha'};

log.emociones.textos_botones = emociones_textos_botones;


%% NOMBRE DEL PACIENTE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% ORDEN DE INTERO - EXTERO

opciones = {'Intero-Extero' 'Extero-Intero'};
choice = menu('Orden:', opciones);
if choice == 1
    secuencia_actual.intero = {'motor' 'intero' 'motor' 'intero'};
else
    secuencia_actual.intero = {'intero' 'motor' 'intero' 'motor'};
end

%% SECUENCIA DE EMOCIONES
load(fullfile('data','secuencias.mat'))
cantidad_secuencias = size(secuencias,1);
numero_secuencia = NaN;
while numero_secuencia < 1 || numero_secuencia > cantidad_secuencias || isnan(numero_secuencia)
    numero_secuencia = inputdlg(sprintf('Nº de secuencia (1 al %d):', cantidad_secuencias));
    numero_secuencia  = str2double(numero_secuencia{1});
end

secuencia_actual.emociones = secuencias(numero_secuencia,:);


%% PSYCHOTOOLBOX
hd = init_psych;

%% LOG
log.secuencia = secuencia_actual;
log.nombre = nombre;


%% CARGO DATOS DE INTERO

log.intero = cell(length(secuencia_actual.intero),1);
intero.bloques = cell(length(secuencia_actual.intero),1);
intero.marcas = cell(length(secuencia_actual.intero),1);

contador_intero = 1;
contador_motor = 1;
intero_dir = fullfile('data','intersujeto');
for i = 1:length(secuencia_actual.intero)

    bloque = secuencia_actual.intero{i};
    data_dir = fullfile(intero_dir, bloque);
    
    if strcmp(bloque, 'motor')
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, contador_motor);    
        marca.inicio = contador_motor;
        contador_motor = contador_motor + 1;
    else
        intero.bloques{i} = CargarBloqueInteroMotor(data_dir, contador_intero);
        marca.inicio = contador_intero + 2;
        contador_intero = contador_intero + 1;
    end
    
    marca.respuesta = 100 + marca.inicio;
    marca.fin = 11*marca.inicio;
    
    intero.marcas{i} = marca;
    
end

practica_dir = fullfile(intero_dir, 'practica');
intero.practica = CargarBloqueInteroMotor(practica_dir, 1);

%% CARGO DATOS DE EMOCIONES

% MAPA CON LAS IMAGENES CORRESPONDIENTES A CADA CODIGO
emociones_dir = fullfile('data','emociones');
directorio_imagenes = fullfile(emociones_dir,'imagenes');
bloques_dir = fullfile(emociones_dir,'bloques');

keySet = ArchivosDeCarpeta(directorio_imagenes);
valueSet = CargarTexturas(directorio_imagenes, keySet, hd.window);
map = containers.Map(keySet,valueSet);

emociones.codigos = containers.Map(keySet, 1:length(keySet)); % le asigna un numero a cada imagen para enviar como marca
log.emociones = cell(length(secuencia_actual.emociones), 1);
emociones.texturas = cell(length(secuencia_actual.emociones),1);
emociones.archivos = cell(length(secuencia_actual.emociones),1);
for i = 1:length(emociones.texturas)
    bloque = secuencia_actual.emociones(i);
    archivo = CargarArchivo(fullfile(bloques_dir, [bloque '.dat']));
    [emociones.texturas{i}, emociones.archivos{i}] = Decodificar(archivo, map);
    log.emociones{i} = cell(length(emociones.texturas{i}),1);
end

emociones.instrucciones = fileread(fullfile(emociones_dir,'instrucciones.txt'));
emociones.textos_botones = emociones_textos_botones;

practica_dir = fullfile(emociones_dir, 'practica');
emociones_practica.instrucciones = emociones.instrucciones;
emociones_practica.mensaje_practica =  fileread(fullfile(emociones_dir,'mensaje_practica.txt'));
emociones_practica.texturas = CargarTexturasDeCarpeta(practica_dir, hd.window);
emociones_practica.texturas = emociones_practica.texturas(randperm(numel(emociones_practica.texturas)));
emociones_practica.texturas = {emociones_practica.texturas};
emociones_practica.duraciones = 0.2;
emociones_practica.textos_botones = emociones.textos_botones;

%% INSTRUCCIONES PRINCIPALES
instrucciones = CargarTextosDeCarpeta(fullfile('data','instrucciones'));
for x = 1:length(instrucciones)
    TextoCentrado(instrucciones{x}, TAMANIO_INSTRUCCIONES, hd);   
    DibujarCuadradoNegro();
    Screen('Flip',hd.window);
    exit = EsperarBoton(teclas.Continuar, teclas.ExitKey);
    if exit
        Salir(hd);
        return;
    end
end
    

%% PRACTICAS
exit = false;
[~, exit] = CorrerSecuenciaIntero(intero.practica, teclas, hd, TIEMPO_MOTOR_PRACTICA, true, []);
if exit
    Salir(hd);
    return
end

[~, exit] = CorrerSecuenciaEmociones(emociones_practica, 1, hd, teclas, []);
if exit
    Salir(hd);
    return
end

%% PARADIGMA

for i = 1:length(secuencia_actual.intero)
    [log.intero{i}, exit] = CorrerSecuenciaIntero(intero.bloques{i}, teclas, hd, TIEMPO_MOTOR, false, intero.marcas{i});
    if exit
        break;
    end
    [log.emociones{i}, exit] = CorrerSecuenciaEmociones(emociones, i, hd, teclas, log.emociones{i});
    if exit
        break;
    end
    [log.preguntas{i}, exit] = BloquePreguntas(hd, teclas);
    if exit
        break;
    end    
    
end

TextoCentrado('Usted lo hizo muy bien, gracias por participar', TAMANIO_INSTRUCCIONES, hd, hd.white);
DibujarCuadradoNegro();
Screen('Flip',hd.window);


%% GUARDO LOG
log_file = PrepararLog('log', nombre, 'InteroPriming');
save(log_file, 'log');

if ~exit
    contador(secuencia_actual.emociones) = contador(secuencia_actual.emociones) + 1;
    save(fullfile('data','secuencias.mat'), 'secuencias', 'contador');
end

WaitSecs(2);

%% SALIR
Salir(hd);
end