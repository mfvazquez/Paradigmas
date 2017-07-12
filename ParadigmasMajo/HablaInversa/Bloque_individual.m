function Bloque_individual()

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
teclas.saltear = KbName('return');

%% NOMBRE

nombre = inputdlg('Código de participante:');
nombre = nombre{1};
log.nombre = nombre;

%% MENSAJE FIN

MENSAJE_DESPEDIDA = 'Hemos terminado esta tarea \n ¡Muchas gracias!';

%% SECUENCIA

secuencias = {'R1' 'R2' 'R3' 'R4' 'L5' 'L6' 'L7' 'L8'};
choice = menu('Secuencia:', secuencias);
secuencia_elegida = secuencias{choice};
secuencia = strsplit(secuencia_elegida,'-');
log.secuencia = secuencia;

bloques = cell(length(secuencia),1);
instrucciones = cell(length(bloques),1);
for x = 1:length(bloques)
    [instrucciones{x}, bloque_actual.estimulos, bloque_actual.practica, bloque_actual.mensaje] = CargarBloque(fullfile('data',secuencia{x}));
    
    datos_bloque.audio = false;
    datos_bloque.texto = false;
    datos_bloque.duracion_texto = 0;
    datos_bloque.duracion_blanco = 0;
    datos_bloque.duracion_grabacion = 0;
    
    if strcmp(secuencia{x},'R1')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 3;
        
    elseif strcmp(secuencia{x},'R2')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 5;
        
    elseif strcmp(secuencia{x},'R3')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 7;
        
    elseif strcmp(secuencia{x},'R4')
        datos_bloque.audio = true;
        datos_bloque.duracion_grabacion = 11;
        
    elseif strcmp(secuencia{x},'L5')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 0.4;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 5;
        
    elseif strcmp(secuencia{x},'L6')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 0.4;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 7;
        
    elseif strcmp(secuencia{x},'L7')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 2;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 10;
        
    elseif strcmp(secuencia{x},'L8')
        datos_bloque.texto = true;
        datos_bloque.duracion_texto = 2;
        datos_bloque.duracion_blanco = 2;
        datos_bloque.duracion_grabacion = 15;
        
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

global TAMANIO_INSTRUCCIONES TAMANIO_TEXTO triggerlevel freq

TAMANIO_TEXTO = 0.03;
TAMANIO_INSTRUCCIONES = 0.03;
triggerlevel = 0.03;
freq = 44100;

%% PARADIGMA

for x = 1:length(bloques)
    
    exit = PresentarInstrucciones(hd, instrucciones{x}, TAMANIO_INSTRUCCIONES, teclas);
    if exit
        break
    end
    
    [exit, ~] = CorrerBloque(hd, bloques{x}.practica, bloques{x}.datos, teclas, []);
    if exit
        break
    end
    
    exit = PresentarInstrucciones(hd, {bloques{x}.mensaje}, TAMANIO_INSTRUCCIONES, teclas);
    if exit
        break
    end
    
    [exit, log.datos{x}.trials] = CorrerBloque(hd, bloques{x}.estimulos, bloques{x}.datos, teclas, log.datos{x}.trials);
    if exit
        break
    end
end

TextoCentrado(MENSAJE_DESPEDIDA, TAMANIO_INSTRUCCIONES, hd);    
Screen('Flip', hd.window);    
Esperar(1, teclas.salir,[], []);

%% GUARDO LOG
[carpeta_log, log_file] = PrepararLog('log', nombre, secuencia_elegida);
save(fullfile(carpeta_log, log_file), 'log');

%% PASO AUDIOS A ARCHIVOS
for x = 1:length(log.datos)
    carpeta_bloque = fullfile(carpeta_log, log.datos{x}.tipo_bloque);
    mkdir(carpeta_bloque);
    
    for y = 1:length(log.datos{x}.trials)
        if isempty(log.datos{x}.trials{y}) || isempty(log.datos{x}.trials{y}.grabacion)
            break
        end
        archivo = fullfile(carpeta_bloque ,[num2str(y) '.wav']);
        wavwrite(log.datos{x}.trials{y}.grabacion.audio, freq, archivo);
    end
    
end

%% SALIR
Salir;

end