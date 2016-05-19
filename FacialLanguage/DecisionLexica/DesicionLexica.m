%% Face Word Task - Version 5

% Clear the workspace
close all;
clear all;
sca;

addpath('lib');
addpath(fullfile('lib','xlwrite','xlwrite'));
% loadPOI;

%% ----------------------- CONSTANTES ------------------------------------

global hd;

PAUSA_TEXTO = '¡Hagamos una pausa!\n\n Presiona cualquier tecla para continuar';
FIN_TEXTO = 'Fin de la prueba \n ¡MUCHAS GRACIAS!';
PREGUNTA_TEXTO = '¿Tienes alguna pregunta? \n\n Presiona cualquier tecla para continuar';


%% ------------------------ NOMBRE ---------------------------------------

% nombre = inputdlg('Nombre:');
% if isempty(nombre)
%     return
% end
% nombre = nombre{1};

%% ----------------------- CARGO DATOS ------------------------------------

instrucciones = fileread(fullfile('data','instrucciones.txt'));

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

%% ------------------ INSTRUCCIONES --------------------------------------

textoCentrado(instrucciones, 0.04);
Screen('Flip',hd.window);
KbPressWait;

%% ------------------ CORRO LA PRACTICA ----------------------------------

exit = CorrerBloque(practica);

if exit
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    ListenChar(1);
    ShowCursor;
    return
end

%% ------------------ CORRO CADA BLOQUE ----------------------------------

textoCentrado(PREGUNTA_TEXTO, 0.04);
Screen('Flip',hd.window);
KbPressWait;

for i = 1:length(bloques)

    exit = CorrerBloque(bloques{1,i});
    if exit
        break;
    end    
    
    if i == length(bloques)
        textoCentrado(FIN_TEXTO, 0.04);
        Screen('Flip',hd.window);
        WaitSecs(3);
    else
        textoCentrado(PAUSA_TEXTO, 0.04);
        Screen('Flip',hd.window);
        KbPressWait;
    end
        
end


%% -------------------------- END ----------------------------------------

Screen('CloseAll'); % Cierro ventana del Psychtoolbox
ListenChar(1);
ShowCursor;
