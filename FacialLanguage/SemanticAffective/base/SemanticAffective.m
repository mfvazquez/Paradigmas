% function SemanticAffective()
% Negation Task

clc;
sca;
close all;
clearvars;

%% LIBRERIAS

addpath('lib');

%% CONSTANTES GLOBALES

global hd
global TEXT_SIZE_INST
global TEXT_SIZE_STIM
global ExitKey
global TIEMPOS
global MARCAS
global pportobj pportaddr
global VERSIONES
global OPCION_DIST

%% CONSTANTES

TEXT_SIZE_INST = 0.025;
TEXT_SIZE_STIM = 0.04;
KbName('UnifyKeyNames');
ExitKey = KbName('ESCAPE');
MASK_DURATION = [50 200];

OPCION_DIST = 0.3;

%% MARCAS

MARCAS.PRIME = 3;
MARCAS.TARGET = 12;
MARCAS.ERROR = 100;
MARCAS.CORRECTO = 101;
MARCAS.DURACION = 0.001;



%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% VERSION

OPCIONES.IZQ.KEY = KbName('v');
OPCIONES.IZQ.KEY_VALUE = 'v';

OPCIONES.DER.KEY = KbName('b');
OPCIONES.DER.KEY_VALUE = 'b';

OPCIONES.IZQ.STR = 'vivo';
OPCIONES.DER.STR = 'no vivo';

VERSIONES = cell(1,2);
VERSIONES{1} = OPCIONES;

OPCIONES.IZQ.STR = 'no vivo';
OPCIONES.DER.STR = 'vivo';
VERSIONES{2} = OPCIONES;

%% DURACIONES

TIEMPOS.FIJACION = 0.5;
TIEMPOS.PRIME = 0.15;
TIEMPOS.MASK = 0.05;
TIEMPOS.TARGET = 2.7;
TIEMPOS.ESPERA = 0.5;

%% PUERTO PARALELO

% % % % % % % % % % % % % % % % % % pportaddr = 'C020';
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % if exist('pportaddr','var') && ~isempty(pportaddr)
% % % % % % % % % % % % % % % % % %     fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
% % % % % % % % % % % % % % % % % %     pportaddr = hex2dec(pportaddr);
% % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % %     pportobj = io32;
% % % % % % % % % % % % % % % % % %     io32status = io32(pportobj);
% % % % % % % % % % % % % % % % % %     
% % % % % % % % % % % % % % % % % %     if io32status ~= 0
% % % % % % % % % % % % % % % % % %         error('io32 failure: could not initialise parallel port.\n');
% % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % end

%% INICIO PSYCHOTOOLBOX

ListenChar(2);
HideCursor;
hd = init_psych();

Screen('Flip', hd.window);



%% TEXTOS

data_dir = 'data';

INTRODUCCIONES = cell(1,2);
INTRODUCCIONES{1} = fileread(fullfile(data_dir, 'instrucciones1.txt'));
INTRODUCCIONES{2} = fileread(fullfile(data_dir, 'instrucciones2.txt'));

START = fileread(fullfile(data_dir, 'start.txt'));
BREAK = fileread(fullfile(data_dir, 'break.txt'));
FIN = fileread(fullfile(data_dir, 'fin.txt'));

%% BLOQUES

practica = CargarBloque(data_dir,'practica.csv');

bloques_dir = fullfile(data_dir, 'bloques');
bloques_arch = ArchivosDeCarpeta(bloques_dir);
bloques = cell(1, length(bloques_arch));
for i = 1:length(bloques_arch)
    bloques{i} = CargarBloque(bloques_dir, bloques_arch(i).name);
end

%% LOG
log = cell(1,length(VERSIONES));
for i = 1:length(log)
    log{i} = CrearLog(bloques);
end

%% PARADIGMA
exit = false;
for i = 1:length(VERSIONES)
    
    %% INSTRUCCIONES
    MostrarMensaje(INTRODUCCIONES{i}, TEXT_SIZE_INST, hd.window);
    
    %% PRACTICA
    
    exit = CorrerBloque(practica, true, VERSIONES{i});
    if exit
        break
    end
    
%% START
    MostrarMensaje(START, TEXT_SIZE_INST, hd.window);

    
    %% BLOQUES
    
    for j = 1:length(bloques)
        [exit, log{i}{j}] = CorrerBloque(bloques{j}, false, VERSIONES{i}, log{i}{j});
        if exit
            break
        end
        MostrarMensaje(BREAK, TEXT_SIZE_INST, hd.window);
    end
    if exit
        break
    end
    
end

%% FIN
MostrarMensaje(FIN, TEXT_SIZE_INST, hd.window);

%% GUARDO LOG

GuardarLog(log, nombre, 'log', 'SemanticAffective', 'bloques');

Salir;
% end