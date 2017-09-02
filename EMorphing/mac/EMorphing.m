function EMorphing()
clc;
sca;
close all;
clearvars;
clear all;

%% LIBRERIAS

addpath('lib');

%% ELEGIR BLOQUE
bloques = ArchivosDeCarpeta(fullfile('data','bloques'));
choice = menu('Bloque:',bloques);
bloque_carpeta = bloques{choice};

tipo = strsplit(bloque_carpeta,'-');
tipo = tipo{end};

%% NOMBRE

nombre = inputdlg('Nombre:');
nombre = nombre{1};
log.nombre = nombre;


%% PSYCHOTOOLBOX
hd = init_psych;

%% CONSTANTES
global TAMANIO_TEXTO
global TIEMPO_ENTRE_IMAGENES

TIEMPO_ENTRE_IMAGENES = 0.5;

TAMANIO_TEXTO = 0.025;

MENSAJE_INICIO = 'Ahora comenzaremos con la tarea.\n\nPresione ENTER para comenzar';

%% BOTONES
KbName('UnifyKeyNames');
botones.salir = KbName('ESCAPE');
botones.continuar = KbName('return');
botones.aceptar = KbName('SPACE');
botones.opciones = 30:35; % teclas del 1 al 6 que no son del numpad
if strcmp(tipo, 'cambios')
    botones.opciones = 30:34;
end


%% CARGO LAS TEXTURAS
sujetos = [1 2 3 5 7 8 9 10];
emociones = {'alegria' 'asco' 'ira' 'miedo' 'sorpresa' 'tristeza'};
rango = [0 20];

texturas = cell(sujetos(end), 1);
for x = sujetos
    for y = 1:length(emociones)        
        texturas_actuales = cell(rango(end)- rango(1) + 1,1);
        for z = 1:length(texturas_actuales)
            actual = [num2str(x) emociones{y} num2str(z+rango(1)-1) '.jpg'];
            texturas_actuales{z} =  CargarTextura(fullfile('data','imagenes', actual), hd.window);
        end
        sujeto_actual.(emociones{y}) = texturas_actuales;
    end
    texturas{x} = sujeto_actual;
end

%% CARGO TEXTOS

bloque_dir = fullfile('data','bloques',bloque_carpeta);

% INSTRUCCIONES
instrucciones = CargarTextosDeCarpeta(fullfile(bloque_dir,'instrucciones'));

% OPCIONES
texto_opciones = fileread(fullfile(bloque_dir,'pregunta.txt'));
log.opciones = texto_opciones;
%% CARGO BLOQUE

bloque = CargarCSV(fullfile(bloque_dir,'estimulos.csv'), ';');
for x = 1:length(bloque)
    bloque{x,1} = str2double(bloque{x,1});
end

%% CARGO PRACTICA

carpetas_practica = ArchivosDeCarpeta(fullfile(bloque_dir, 'practica'));
texturas_practica = cell(1,length(carpetas_practica));
for x = 1:length(carpetas_practica)
    texturas_practica{x} = CargarTexturasDeCarpeta(fullfile(bloque_dir, 'practica', carpetas_practica{x}), hd.window);
end

%% PREPARO LOG

log.bloque = cell(length(bloque),1);
for x = 1:length(log.bloque)
    % IMAGENES
    log_trial.on_set = cell(rango(end)-rango(1)+1,1);    
    log.bloque{x} = log_trial;
end

%% A PARTIR DE ACA INICIA EL PARADIGMA

%% INSTRUCCIONES

exit = PresentarInstrucciones(hd, instrucciones, TAMANIO_TEXTO, botones);
if exit
    Salir;
    return
end

%% PRACTICA
for x = 1:length(texturas_practica)
    [exit, ~] = CorrerSecuencia(hd, botones, texturas_practica{x}, []);        
    if exit
        Salir;
        return
    end
    
    TextoCentrado(texto_opciones, TAMANIO_TEXTO, hd);
    Screen('Flip', hd.window);
    [exit, ~] = EsperarBotonesApretar(botones.salir, botones.opciones);
    if exit
        Salir;
        return
    end
end

exit = PresentarInstrucciones(hd, {MENSAJE_INICIO}, TAMANIO_TEXTO, botones);
if exit
    Salir;
    return
end

%% BLOQUE
[~, log.bloque] = CorrerBloque(hd, texturas, botones, bloque, texto_opciones, log.bloque);

%% GUARDO LOG
log_file = PrepararLog('log', nombre, ['EMorphing_Bloque' bloque_carpeta]);
save(log_file, 'log');

Salir;

end
