%% Face Word Task - Version 5

% Clear the workspace
close all;
clear all;
sca;

addpath('lib');
addpath(fullfile('lib','xlwrite','xlwrite'));
addpath(fullfile('lib','strings'));
% loadPOI;

%% ----------------------- CONSTANTES ------------------------------------

global hd;

TEXT_SIZE = 0.04;

PAUSA_TEXTO = '¡Hagamos una pausa!\n\n Presiona cualquier tecla para continuar';
FIN_TEXTO = 'Fin de la prueba \n ¡MUCHAS GRACIAS!';
PREGUNTA_TEXTO = '¿Tienes alguna pregunta? \n\n Presiona cualquier tecla para continuar';

%% ----------------------- BOTONES ---------------------------------------

KbName('UnifyKeyNames');
escKey = KbName('ESCAPE');
vKey = KbName('v');
bKey = KbName('b');

botones_bloque_impar.Si = vKey;
botones_bloque_impar.No = bKey;

botones_bloque_par.Si = bKey;
botones_bloque_par.No = vKey;

botones_bloque_impar.Salir = escKey;
botones_bloque_par.Salir = escKey;

%% ------------------------ NOMBRE ---------------------------------------

nombre = inputdlg('Nombre:');
if isempty(nombre)
    return
end
nombre = nombre{1};

%% ----------------------- CARGO DATOS ------------------------------------

instrucciones_practica = fileread(fullfile('data','instrucciones_practica.txt'));
instrucciones_bloque_par = fileread(fullfile('data','instrucciones_bloque_par.txt'));
instrucciones_bloque_impar = fileread(fullfile('data','instrucciones_bloque_impar.txt'));

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

practica = CargarBloque('data', 'practica.txt');

%% ----------------------- PREPARO LOG ----------------------------------

log = cell(1, length(bloques));

for i = 1:length(log)
    largo = length(bloques{1,i}.palabra);
    log{i}.palabra = bloques{1,i}.palabra;
    log{i}.categoria = bloques{1,i}.categoria;
    log{i}.fijacion_time = cell(1,largo);
    log{i}.stim_time = cell(1,largo);    
    log{i}.resp_time = cell(1,largo);
    log{i}.reaction_time = cell(1,largo);
    log{i}.accuracy = cell(1,largo);
    log{i}.inicio = -1;
    log{i}.fin = -1;
end


%% ------------------------ PSYCHOTOOLBOX INIT ----------------------------

ListenChar(2);
HideCursor;
hd = init_psych();

%% Parallel Port

% global pportobj pportaddr
% 
% pportaddr = 'C020';
% 
% if exist('pportaddr','var') && ~isempty(pportaddr)
%     fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
%     pportaddr = hex2dec(pportaddr);
% 
%     pportobj = io32;
%     io32status = io32(pportobj);
%     
%     if io32status ~= 0
%         error('io32 failure: could not initialise parallel port.\n');
%     end
% end

% % ------------------ PRACTICA ----------------------------------

exit = CorrerBloque(instrucciones_practica, practica, botones_bloque_impar, []);

if exit
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    ListenChar(1);
    ShowCursor;
    return
end

%% ------------------ CORRO CADA BLOQUE ----------------------------------

textoCentrado(PREGUNTA_TEXTO, TEXT_SIZE);
Screen('Flip',hd.window);
KbPressWait;

for i = 1:length(bloques)

    if mod(i,2) == 1 % Bloque impar
        [exit, log{1,i}] = CorrerBloque(instrucciones_bloque_impar, bloques{1,i}, botones_bloque_impar, log{1,i});
    else % Bloque par
        [exit, log{1,i}] = CorrerBloque(instrucciones_bloque_par, bloques{1,i}, botones_bloque_par, log{1,i});
    end
        
    if exit
        break;
    end    
    
    if i == length(bloques)
        textoCentrado(FIN_TEXTO, TEXT_SIZE);
        Screen('Flip',hd.window);
        WaitSecs(3);
    else
        textoCentrado(PAUSA_TEXTO, TEXT_SIZE);
        Screen('Flip',hd.window);
        KbPressWait;
    end
        
end

%% ---------------------- GUARDO EL LOG ------------------------------------

textoCentrado('Guardando Datos...', TEXT_SIZE);
Screen('Flip', hd.window);
GuardarLog(log, nombre);

%% -------------------------- END ----------------------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;
