clc;
sca;
close all;
clearvars;

%% LIBRERIAS

addpath('lib');

%% CONSTANTES

global TAMANIO_INSTRUCCIONES
global TAMANIO_TEXTO

TAMANIO_TEXTO = 0.05;
TAMANIO_INSTRUCCIONES = 0.03;

TIEMPO_MOTOR_PRACTICA = 30;
TIEMPO_MOTOR = 120;

%% PUERTO PARALELO
% % 
% % pportaddr = 'C020';
% % 
% % if exist('pportaddr','var') && ~isempty(pportaddr)
% %     fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
% %     pportaddr = hex2dec(pportaddr);
% % 
% %     pportobj = io32;
% %     io32status = io32(pportobj);
% %     
% %     if io32status ~= 0
% %         error('io32 failure: could not initialise parallel port.\n');
% %     end
% % end

%% TECLAS

KbName('UnifyKeyNames');
teclas.ExitKey = KbName('ESCAPE');
teclas.LatidosKey = KbName('Z'); 
teclas.afirmativo = KbName('LeftArrow');
teclas.negativo = KbName('RightArrow');
teclas.botones_salteado = [KbName('P') KbName('Q')];
teclas.RightKey = KbName('RightArrow');
teclas.LeftKey = KbName('LeftArrow');
teclas.EnterKey = KbName('DownArrow');


%% NOMBRE DEL PACIENTE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% CARGO LA SECUENCIA A CORRER
load(fullfile('data','secuencias.mat'));
[~,IX] = sort([secuencias.contador]);
secuencias = secuencias(IX);
secuencia_actual = secuencias(1);

%% PSYCHOTOOLBOX
hd = init_psych;

%% LOG
log.secuencia = secuencia_actual;
log.nombre = nombre;


%% CARGO DATOS DE INTERO

log.intero = cell(length(secuencia_actual.intero),1);
intero.bloques = cell(length(secuencia_actual.intero),1);

intero_dir = fullfile('data','intersujeto');
for i = 1:length(secuencia_actual.intero)

    bloque = secuencia_actual.intero{i};
    data_dir = fullfile(intero_dir, bloque);
    
    intero.bloques{i} = CargarBloqueInteroMotor(data_dir);    
    
end

practica_dir = fullfile(intero_dir, 'practica');
intero.practica = CargarBloqueInteroMotor(practica_dir);

%% CARGO DATOS DE EMOCIONES

% MAPA CON LAS IMAGENES CORRESPONDIENTES A CADA CODIGO
keySet = {'N1'	    'N2'	    'N3'	    'N4'	    'N5'	    'N6'	    'N7'	    'N8'	    'N9'	    'N10'	'A1'	'A2'	'A3'	'A4'	'A5'	'A6'	'A7'	'A8'	'A9'	'A10'	'T1'	'T2'	'T3'	'T4'	'T5'	'T6'	'T7'	'T8'	'T9'	'T10'	'E1'	'E2'	'E3'	'E4'	'E5'	'E6'	'E7'	'E8'	'E9'	'E10'};
nombres_imagenes = {'MC01_NEU'	'MC02_NEU'	'MC03_NEU'	'MC04_NEU'	'MC05_NEU'	'MC06_NEU'	'MC07_NEU'	'MC08_NEU'	'MC09_NEU'	'MC10_NEU'	'MC01_HAP'	'MC02_HAP'	'MC03_HAP'	'MC04_HAP'	'MC05_HAP'	'MC06_HAP'	'MC07_HAP'	'MC08_HAP'	'MC09_HAP'	'MC10_HAP'	'MC01_SAD'	'MC02_SAD'	'MC03_SAD'	'MC04_SAD'	'MC05_SAD'	'MC06_SAD'	'MC07_SAD'	'MC08_SAD'	'MC09_SAD'	'MC10_SAD'	'MC01_ANG'	'MC02_ANG'	'MC03_ANG'	'MC04_ANG'	'MC05_ANG'	'MC06_ANG'	'MC07_ANG'	'MC08_ANG'	'MC09_ANG'	'MC10_ANG'};

emociones_dir = fullfile('data','emociones');
directorio_imagenes = fullfile(emociones_dir,'imagenes');
bloques_dir = fullfile(emociones_dir,'bloques');

valueSet = CargarTexturas(directorio_imagenes, nombres_imagenes, 'JPG', hd.window);
map = containers.Map(keySet,valueSet);

log.emociones = cell(length(secuencia_actual.emociones), 1);
emociones.bloques = cell(length(secuencia_actual.emociones),1);
emociones.codigos = cell(length(secuencia_actual.emociones),1);
for i = 1:length(emociones.bloques)
    bloque = secuencia_actual.emociones(i);
    archivo = CargarArchivo(fullfile(bloques_dir, [bloque '.dat']));
    [emociones.bloques{i}, emociones.codigos{i}] = Decodificar(archivo, map);
    log.emociones{i} = cell(length(emociones.bloques{i}),1);
end

emociones.instrucciones = fileread(fullfile(emociones_dir,'instrucciones.txt'));
emociones.mensaje_practica = fileread(fullfile(emociones_dir,'mensaje_practica.txt'));

practica_dir = fullfile(emociones_dir, 'practica');
emociones.practica = CargarTexturasDeCarpeta(practica_dir, hd.window);
emociones.practica = emociones.practica(randperm(numel(emociones.practica)));

%% INSTRUCCIONES PRINCIPALES
instrucciones = fileread(fullfile('data','instrucciones.txt'));
TextoCentrado(instrucciones, TAMANIO_INSTRUCCIONES, hd);
Screen('Flip',hd.window);
KbStrokeWait;

exit = false;

%% PRACTICAS

[~, exit] = CorrerSecuenciaIntero(intero.practica, teclas, hd, TIEMPO_MOTOR_PRACTICA);
if exit
    Salir;
    return
end

TextoCentrado(emociones.instrucciones, TAMANIO_INSTRUCCIONES, hd);
Screen('Flip',hd.window);
KbStrokeWait;

[~, exit] = CorrerSecuenciaEmociones(emociones.practica, [], emociones.mensaje_practica, hd, teclas, []);
if exit
    Salir;
    return
end

%% PARADIGMA

for i = 1:length(secuencia_actual.intero)
    [log.intero{i}, exit] = CorrerSecuenciaIntero(intero.bloques{i}, teclas, hd, TIEMPO_MOTOR);
    if exit
        break;
    end
    [log.emociones{i}, exit] = CorrerSecuenciaEmociones(emociones.bloques{i}, emociones.codigos{i} ,emociones.instrucciones,hd, teclas, log.emociones{i});
    if exit
        break;
    end
    [log.preguntas{i}, exit] = BloquePreguntas(hd, teclas);
    if exit
        break;
    end    
    
end

%% GUARDO LOG
log_file = PrepararLog('log', nombre, 'InteroPriming');
save(log_file, 'log');

if ~exit
    secuencias(1).contador = secuencias(1).contador + 1;
    save(fullfile('data','secuencias.mat'), 'secuencias');
end

%% SALIR
Salir(hd);