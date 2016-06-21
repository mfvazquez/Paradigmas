function FWT_EEG()


% Clear the workspace
close all;
clear all;
sca;

addpath('lib');
addpath(fullfile('lib','xlwrite','xlwrite'));
addpath(fullfile('lib','strings'));

%% ----------------------- CONSTANTES ------------------------------------

global hd;

TEXT_SIZE = 0.03;

PAUSA_TEXTO = '�Hagamos una pausa!\n\n Presiona cualquier tecla para continuar';
FIN_TEXTO = 'Fin de la prueba \n �MUCHAS GRACIAS!';
PREGUNTA_TEXTO = '�Tienes alguna pregunta? \n\n Presiona cualquier tecla para continuar';

LOG_PATH = fullfile('log','con_marcas');

%% ----------------------- BOTONES ---------------------------------------

KbName('UnifyKeyNames');
escKey = KbName('ESCAPE');
vKey = KbName('v');
bKey = KbName('b');

botones_impar.Si = vKey;
botones_impar.No = bKey;
botones_impar.Salir = escKey;

botones_par.Si = bKey;
botones_par.No = vKey;
botones_par.Salir = escKey;

%% ------------------------ NOMBRE ---------------------------------------

nombre = inputdlg('Nombre:');
if isempty(nombre)
    return
end
nombre = nombre{1};

% ------------------ PUERTO PARALELO --------------------------

global pportobj pportaddr

pportaddr = 'C020';

if exist('pportaddr','var') && ~isempty(pportaddr)
    fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
    pportaddr = hex2dec(pportaddr);

    pportobj = io32;
    io32status = io32(pportobj);
    
    if io32status ~= 0
        error('io32 failure: could not initialise parallel port.\n');
    end
end

%% ----------------------- CARGO DATOS ------------------------------------

instrucciones_impar = fileread(fullfile('data','instrucciones_impar.txt'));
instrucciones_par = fileread(fullfile('data','instrucciones_par.txt'));

practica_impar = CargarBloque('data', 'practica_impar.txt');
practica_par = CargarBloque('data', 'practica_par.txt');

bloques_path = fullfile('data','bloques');
bloques_files = dir(bloques_path);
bloques_files = {bloques_files.name};
bloques_files(1) = [];
bloques_files(1) = [];
bloques_files = natsort(bloques_files);

bloques = cell(1,length(bloques_files));
for i = 1:length(bloques_files)
    bloques{1,i} = CargarBloque(bloques_path ,bloques_files{i});    
end

%% ----------------------- PREPARO LOG ----------------------------------

log = cell(1, length(bloques));

for i = 1:length(log)
    largo = length(bloques{1,i}.palabra);
    log{i}.palabra = bloques{1,i}.palabra;
    log{i}.categoria = bloques{1,i}.categoria;
    log{i}.codigo = bloques{1,i}.codigo;
    log{i}.fijacion_time = cell(1,largo);
    log{i}.stim_time = cell(1,largo);    
    log{i}.resp_time = cell(1,largo);
    log{i}.reaction_time = cell(1,largo);
    log{i}.accuracy = cell(1,largo);
    log{i}.inicio = -1;
    log{i}.fin = -1;
end


%% ------------------------ PSYCHOTOOLBOX INIT ----------------------------

% ListenChar(2);
HideCursor;
hd = init_psych();

for i = 1:length(bloques)

    if mod(i,2) == 1
        instrucciones = instrucciones_impar;
        practica = practica_impar;
        botones = botones_impar;
    else
        instrucciones = instrucciones_par;
        practica = practica_par;
        botones = botones_par;
    end
    
    
    %% ------------------ INSTRUCCIONES -----------------------------
    textoCentrado(instrucciones, TEXT_SIZE);
    Screen('Flip',hd.window);
    KbPressWait;

    %% ------------------ PRACTICA ----------------------------------
    exit = CorrerBloque(practica, botones, [], false);

    if exit
        break;
    end

    textoCentrado(PREGUNTA_TEXTO, TEXT_SIZE);
    Screen('Flip', hd.window);
    KbPressWait;
    
    %% ------------------ BLOQUE ------------------------------------
    [exit, log{1,i}] = CorrerBloque(bloques{1,i}, botones, log{1,i}, true);

    if exit
        break;
    end    
    
    %% ------------------ FIN BLOQUE --------------------------------
    
    if i == length(bloques)
        textoCentrado(FIN_TEXTO, TEXT_SIZE);
        Screen('Flip', hd.window);
        WaitSecs(3);
    else
        textoCentrado(PAUSA_TEXTO, TEXT_SIZE);
        Screen('Flip', hd.window);
        KbPressWait;
    end
        
end

%% ---------------------- GUARDO EL LOG ------------------------------------

textoCentrado('Guardando Datos...', TEXT_SIZE);
Screen('Flip', hd.window);
loadPOI;
GuardarLog(log, nombre, LOG_PATH);

%% -------------------------- END ----------------------------------------

% ListenChar(1);
ShowCursor;
Screen('CloseAll'); % Cierro ventana del Psychtoolbox

end