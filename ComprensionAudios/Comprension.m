function Comprension()

clc;
sca;
close all;
clearvars;
clear all;

%% LIBRERIAS

addpath('lib');

%% CONSTANTES

global hd BLINK_DURATION TAMANIO_TEXTO

BLINK_DURATION = 20e-3;
TAMANIO_TEXTO = 0.03;

MENSAJE_CONTINUAR = 'Presione ESPACIO para continuar';
MENSAJE_COMENZAR = 'Presione ENTER para comenzar';

%% BOTONES
KbName('UnifyKeyNames');
botones.salir = KbName('ESCAPE');
botones.aceptar = KbName('return');
botones.continuar = KbName('SPACE');
botones.opciones = 49:58; % teclas del 1 al 0 que no son del numpad


%% DATOS
nombre = inputdlg('Nombre:');
nombre = nombre{1};

%% TIPO DE BLOQUE A CORRER
carpetas = ArchivosDeCarpeta('data');
choice = menu('Tipo:', carpetas);
tipo = carpetas{choice};
data_dir = fullfile('data',tipo);

bloques = CargarBloques(data_dir);

%% LOG

log = cell(1,length(bloques));
for x = 1:length(log)
    actual.audio = [];
    actual.preguntas = cell(1,length(bloques{x}.preguntas));
    log{x} = actual;
end

%% PSYCHOTOOLBOX
hd = init_psych;

for x = 1:length(bloques)

    %% INSTRUCCIONES
    TextoCentrado(bloques{x}.instrucciones, TAMANIO_TEXTO, hd);
    MensajeContinuar(MENSAJE_CONTINUAR, hd.white, hd);
    Screen('Flip',hd.window);
    exit = EsperarBoton(botones.continuar, botones.salir);
    if exit
        Salir;
        return
    end
    
    %% AUDIO
    MensajeContinuar(MENSAJE_COMENZAR, hd.white, hd);
    Screen('Flip',hd.window);
    exit = EsperarBoton(botones.aceptar, botones.salir);
%     if exit
%         Salir;
%         return1
%     end
    Screen('Flip',hd.window);
    [log{x}.audio, exit] = ReproducirAudio(hd, bloques{x}.audio, bloques{x}.freq, botones.salir, log{x}.audio);
%     if exit
%         break
%     end
    
    %% PREGUNTAS
    [log{x}.preguntas, exit] = BloquePreguntas(hd, bloques{x}.preguntas, botones, log{x}.preguntas);
%     if exit
%         break
%     end
end

nombre_archivo_log = PrepararLog('log', [nombre '_' tipo], 'ComprensionAudios');
save(nombre_archivo_log, 'log');

Salir();

end