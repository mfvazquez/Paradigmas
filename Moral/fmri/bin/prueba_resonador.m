% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Marcas en puerto paralelo - libreria io23.dll input32.dll / Psychtoolbox 3
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE ENVIRONMENT
%%%%%%%%%%%%%%%%%%%%%%

%% Clear Matlab/Octave window:
clc;
clear all

%%

% Init Puerto Paralelo (io32.dll debe estar en la carpeta del proyecto y la 
% input32.dll en c:\windows\system32 y/o c:\windows\system)

 global parallel_port;
 parallel_port= true;

if parallel_port
    
    pportaddr = 'C020';
    % pportaddr = '378';
    
    if exist('pportaddr','var') && ~isempty(pportaddr)
        
        fprintf('Connecting to parallel port 0x%s.\n', pportaddr);
        pportaddr = hex2dec(pportaddr);
        pportobj = io32;
        io32status = io32(pportobj);
        io32(pportobj,pportaddr,0)
        
        if io32status ~= 0
            error('io32 failure: could not initialise parallel port.\n');
        end
        
    end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                        Comienzo del SCRIPT                              %
%                                                                         %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sincronizaci�n con el resonador

%start_signal= %AC� VA EL C�DIGO HEXA PARA EL PULSO DEL RESONADOR.
start_signal= 237;
continuar = true;
while (continuar)
       input_data=io32(pportobj,pportaddr)
       if 233 ~= input_data
           continuar = false;
       end
% % % %        if strcmp(input_data, start_signal) %Una vez que ocurra la se�al del resonador, arranca
% % % %            wait_start=0;
% % % %        end
end