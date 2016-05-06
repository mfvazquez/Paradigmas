function FTT()

clc;
sca;
close all;
clearvars;

lib_path = fullfile('..','lib');
addpath(lib_path);
loadPOI;

% ------------------- CONSTANTES GLOBALES --------------------------------
global hd;
global escKey;

% ----------------------- TECLAS A USAR ----------------------------------

KbName('UnifyKeyNames');
escKey = KbName('ESCAPE');
fKey = KbName('f');
gKey = KbName('g');
hKey = KbName('h');
jKey = KbName('j');

% ----------------------- CONSTANTES -------------------------------------

DATA_PATH = fullfile('..','data');
TIEMPO_CENTRADO = 5;
MENSAJE_CONTINUAR = 'Presione cualquier tecla para continuar';
BIENVENIDA_LARGO = 40;
BLOQUE_DURACION = 120;
BREAK_DURACION = 96;

% ------------------------ LOG -------------------------------------------

log = cell(1,6);

% ------------------------ NOMBRE ----------------------------------------

nombre = inputdlg('Nombre:');
if isempty(nombre)
    return
end
nombre = nombre{1};

% ----------------------- VERSION A CORRER -------------------------------

versiones_path = fullfile(DATA_PATH, 'versiones');
carpetas = dir(versiones_path);
carpetas = {carpetas.name};
carpetas(1) = []; % elimino el .
carpetas(1) = []; % elimino el ..

versiones = cell(1,length(carpetas));
for i = 1:length(carpetas)
    versiones{1,i} = carpetas{i}(1:end-4);
end

choice = menu('Version:',versiones);
version = versiones{choice};

secuencia = fileread(fullfile(versiones_path,[version '.txt']));

bloques = 6;
BloquesID = fopen(fullfile(DATA_PATH,'Bloques.txt'));
linea = fgets(BloquesID);
while linea ~= -1
    bloque = textscan(linea,'%q%d', 'delimiter',',');
    linea = fgets(BloquesID);
    if strcmp(bloque{1}, version)
        bloques = bloque{2};
    end
end

% ------------------------ MANO A USAR -----------------------------------

manos = {'Diestro' 'Zurdo'};
choice = menu('¿Eres Diestro o Zurdo?:', manos);

if choice == 1
    teclas = [jKey hKey gKey fKey];
else
    teclas = [fKey gKey hKey jKey];
end

% ------------------ INICIO PSYCHOTOOLBOX --------------------------------

ListenChar(2);
HideCursor;
hd = init_psych();

% ------------------ MENSAJE DE BIENVENIDA -------------------------------

MensajeBienvenida = fileread(fullfile(DATA_PATH,'MensajeBienvenida.txt'));
MensajeBienvenida = AgregarFinLinea(MensajeBienvenida, BIENVENIDA_LARGO);

textoCentrado(MensajeBienvenida);
MensajeContinuar(MENSAJE_CONTINUAR);
Screen('Flip', hd.window);
KbWait;

% ------------------- INICIO DEL BLOQUE ----------------------------------

for i = 1:bloques

    CentrarVista(TIEMPO_CENTRADO);
    
    [log{1,i}, exit] = Bloque(secuencia, BLOQUE_DURACION, teclas);
    if exit
        bloques = i;
        break
    end
    if i ~= bloques
        WaitSecs(BREAK_DURACION);
    end
end

%---------------------- GUARDO EL LOG ------------------------------------

textoCentrado('Guardando Datos...');
Screen('Flip', hd.window);
GuardarLog(log, nombre, version, bloques);


% -------------------- CIERRO PSYCHOTOOLBOX ------------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;

end
