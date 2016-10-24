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



%% PUERTO PARALELO
% % % 
% % % pportaddr = 'C020';
% % % 
% % % if exist('pportaddr','var') && ~isempty(pportaddr)
% % %     fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
% % %     pportaddr = hex2dec(pportaddr);
% % % 
% % %     pportobj = io32;
% % %     io32status = io32(pportobj);
% % %     
% % %     if io32status ~= 0
% % %         error('io32 failure: could not initialise parallel port.\n');
% % %     end
% % % end


%% NOMBRE DEL PACIENTE

nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% CARGO LA SECUENCIA A CORRER
load(fullfile('data','secuencias.mat'));
[~,IX] = sort([secuencias.contador]);
secuencias = secuencias(IX);
secuencia_actual = secuencias(1);
secuencias(1).contador = secuencias(1).contador + 1;
save(fullfile('data','secuencias.mat'), 'secuencias');

%% LOG
log.secuencia = secuencia_actual;
log.nombre = nombre;
log.intero = cell(length(secuencia_actual.intero),1);
log.emociones = cell(length(secuencia_actual.emociones),1);

%% PSYCHOTOOLBOX
hd = init_psych;

%% INSTRUCCIONES PRINCIPALES
instrucciones = fileread(fullfile('data','instrucciones.txt'));
TextoCentrado(instrucciones, TAMANIO_INSTRUCCIONES, hd);
Screen('Flip',hd.window);
KbStrokeWait;


%% PARADIGMA
exit = false;
for i = 1:length(secuencia_actual.intero)
    [log.intero{i}, exit] = BloqueIntero(secuencia_actual.intero{i}, hd);
    if exit
        break;
    end
    [log.emociones{i}, exit] = BloqueEmociones(secuencia_actual.emociones(i), hd);
    if exit
        break;
    end
end

%% GUARDO LOG
log_file = PrepararLog('log', nombre, 'InteroPriming');
save(log_file, 'log');

%% SALIR
Salir(hd);