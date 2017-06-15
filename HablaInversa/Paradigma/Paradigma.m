clc;
sca;
close all;
clearvars;
clear all;

addpath('lib');

%% TECLAS

KbName('UnifyKeyNames');
teclas.salir = KbName('ESCAPE');
teclas.continuar = KbName('SPACE');

%% NOMBRE

nombre = inputdlg('Código de participante:');
nombre = nombre{1};
log.nombre = nombre;

%% SECUENCIA

secuencias = {
'R1-R2-R3-R4-L5-L6-L7-L8';
'R1-R2-R3-R4-L6-L5-L8-L7';
'R2-R1-R4-R3-L5-L6-L7-L8';
'R2-R1-R4-R3-L6-L5-L8-L7';
'L5-L6-L7-L8-R1-R2-R3-R4';
'L5-L6-L7-L8-R2-R1-R4-R3';
'L6-L5-L8-L7-R1-R2-R3-R4';
'L6-L5-L8-L7-R2-R1-R4-R3'};
choice = menu('Secuencia:', secuencias);
secuencia_elegida = secuencias{choice};
secuencia = strsplit(secuencia_elegida,'-');
log.secuencia = secuencia;

bloques = cell(length(secuencia),1);
instrucciones = cell(length(bloques),1);
for x = 1:length(bloques)
    [instrucciones{x}, bloque_actual.estimulos] = CargarBloque(fullfile('data',secuencia{x}));
    
    datos_bloque.audio = false;
    datos_bloque.texto = false;
    datos_bloque.duracion_texto = 0;
    datos_bloque.duracion_blanco = 0;
    datos_bloque.duracion_grabacion = 0;
    datos_bloque.duracion_silencio = 0;
    
    if strcmp(secuencia{x},'R1')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 3;
        datos_bloque.duracion_silencio = 0.2;
        
    elseif strcmp(secuencia{x},'R2')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 5;
        datos_bloque.duracion_silencio = 0.2;
        
    elseif strcmp(secuencia{x},'R3')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 7;
        datos_bloque.duracion_silencio = 0.3;
        
    elseif strcmp(secuencia{x},'R4')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 11;
        datos_bloque.duracion_silencio = 0.35;
        
    elseif strcmp(secuencia{x},'L5')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 0.4;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 5;
        datos_bloque.duracion_silencio = 0.2;
        
    elseif strcmp(secuencia{x},'L6')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 0.4;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 7;
        datos_bloque.duracion_silencio = 0.2;
        
    elseif strcmp(secuencia{x},'L7')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 2;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 10;
        datos_bloque.duracion_silencio = 0.3;
        
    elseif strcmp(secuencia{x},'L8')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 2;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 15;
        datos_bloque.duracion_silencio = 0.35;
        
    end
    
    bloque_actual.datos = datos_bloque;
    bloques{x} = bloque_actual;
    
end

%% LOG

log.datos = cell(1, length(bloques));
for x = 1:length(bloques)
    actual.trials = cell(1,length(bloques{x}.estimulos));
    actual.tipo_bloque = secuencia{x};
    log.datos{x} = actual;
end

%% PSYCHOTOOLBOX
% PsychDebugWindowConfiguration
hd = init_psych;

global TAMANIO_INSTRUCCIONES TAMANIO_TEXTO triggerlevel

TAMANIO_TEXTO = 0.1;
TAMANIO_INSTRUCCIONES = 0.03;

triggerlevel = 0.035;

%% PARADIGMA

for x = 1:length(bloques)
    
    exit = PresentarInstrucciones(hd, instrucciones{x}, TAMANIO_INSTRUCCIONES, teclas);
    if exit
        break
    end
    
    [exit, log.datos{x}.trials] = CorrerBloque(hd, bloques{x}, teclas, log.datos{x}.trials);
    if exit
        break
    end
end

%% GUARDO LOG
log_file = PrepararLog('log', nombre, secuencia_elegida);
save(log_file, 'log');

%% SALIR
Salir;