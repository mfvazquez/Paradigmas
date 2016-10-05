% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECG + EEG + Prueba de habilidades Versión 0.0 
% Marcas en puerto paralelo - libreria io23.dll input32.dll / Psychtoolbox 3
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE ENVIRONMENT
%%%%%%%%%%%%%%%%%%%%%%

%% Clear Matlab/Octave window:
clc;
clear all

%% Input del nombre del paxiente
% 
Name=input('\nIngrese su nombre:','s')
Edad=input('\nIngrese su edad: ','s')
Peso=input('\nIngrese su peso: ','s')
Altura=input('\nIngrese su altura: ','s')

% Name='Prueba';
% Edad=66;
% Peso=66;
% Altura=123;
% 

%% Inicializacion de variables

tiempos=0;
tiempo_actual=0;
tiempos_2=0;
tiempo_actual_2=0;
tiempos_3=0;
tiempo_actual_3=0;
tiempos_4=0;
tiempo_actual_4=0;
tiempos_5=0;
tiempo_actual_5=0;
tiempos_6=0;
tiempo_actual_6=0;
tiempos_7=0;
tiempo_actual_7=0;

numero=0;
numero2=0;
numero3=0;
numero4=0;
numero5=0;
numero6=0;
numero6_1=0;
numero7=0;
numero8=0;
numero9=0;
numero10=0;


%%

PsychJavaTrouble

global hd 

%%

% Init Puerto Paralelo (io32.dll debe estar en la carpeta del proyecto y la 
% input32.dll en c:\windows\system32 y/o c:\windows\system)

 global parallel_port;
 parallel_port= false;

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
%% Abre el archivo de LOG

log_txt=fopen(sprintf('%s.csv',Name),'wt');


fprintf(log_txt,'Nombre: ;');
fprintf(log_txt,sprintf('%s',Name));
fprintf(log_txt,';');
fprintf(log_txt,'Edad ;');
fprintf(log_txt,sprintf('%s',Edad));
fprintf(log_txt,';');
fprintf(log_txt,'Peso ;');
fprintf(log_txt,sprintf('%s',Peso));
fprintf(log_txt,';');
fprintf(log_txt,'Altura ;');
fprintf(log_txt,sprintf('%s',Altura));

fprintf(log_txt,'\n');



%%  Load audio

if ~isfield(hd,'instraudio')

    hd.instraudio = wavread('Audio/tapping_.wav')';

end

% Init psychtoolbox sound

if ~isfield(hd,'pahandle')
    
    hd.f_sample = 44100;
    f_sample2=11000;
    fprintf('Initialising audio.\n');
    
    InitializePsychSound
    
    if PsychPortAudio('GetOpenDeviceCount') == 1
        PsychPortAudio('Close',0);
    end
    
    %Mac
    if ismac
        audiodevices = PsychPortAudio('GetDevices');
        outdevice = strcmp('Built-in Output',{audiodevices.DeviceName});
        hd.outdevice = 1;
    elseif ispc
        audiodevices = PsychPortAudio('GetDevices',3);
        if ~isempty(audiodevices)
            %DMX audio
            outdevice = strcmp('DMX 6Fire USB ASIO Driver',{audiodevices.DeviceName});
            hd.outdevice = 2;
        else
            %Windows default audio
            audiodevices = PsychPortAudio('GetDevices',2);
            outdevice = strcmp('Microsoft Sound Mapper - Output',{audiodevices.DeviceName});
            hd.outdevice = 3;
        end
    else
        error('Unsupported OS platform!');
    end
  
    audiodevices = PsychPortAudio('GetDevices');
    hd.pahandle = PsychPortAudio('Open',audiodevices(1,3).DeviceIndex,[],1,hd.f_sample,1);
    PsychPortAudio('Volume', hd.pahandle , 10);
    hd.pahandle2 = PsychPortAudio('Open',audiodevices(1,3).DeviceIndex,[],1,f_sample2,1);
    PsychPortAudio('Volume', hd.pahandle2 , 10);
    
    InitializePsychSound(1);
    
%     hd.pahandle = PsychPortAudio('Open',audiodevices(outdevice).DeviceIndex,[],[0],hd.f_sample,2);
%       hd.pahandle = PsychPortAudio('Open',audiodevices(outdevice).DeviceIndex);
%       hd.pahandle = PsychPortAudio('Open',audiodevices(outdevice).DeviceIndex,1,1,hd.f_sample,1);
%     hd.pahandle = PsychPortAudio('Open',audiodevices(1,5).DeviceIndex);
end



%%  Abro las diapositivas

load_images;
%% Setup psychtoolbox display


% fromH= 200; %barra larga horizaontal
% fromV=800;
% toH= 1100;
% toV=800;



% fromH= 200; %barra larga horizaontal
% fromV=500;
% toH= 1100;
% toV=500;
% 
% fromH2= fromH; %barra verticales
% fromV2=fromV-20;
% toH2= fromH;
% toV2=fromV+20;
% 
% 
% delta_barrita=(toH-fromH)/8;
% 
% deltay_linea1=-200;
% deltay_linea2=-150;
% deltay_linea3=-100;
% deltay_linea4=-50;
% deltay_linea5=0;
% deltay_linea6=50;
% deltay_linea7=150;


hd.bgcolor = [0 0 0] ;
hd.dispscreen = 0;
hd.itemsize = 100;
hd.wsize = (hd.itemsize/2)+30;

hd.textsize = 30;
hd.textfont = 'Helvetica';
hd.textcolor = [255 255 255];%[255 255 255]
hd.ontime = 150/1000;
hd.offtime = 850/1000;

blacktime=500/1000;
debounce=100/1000;

Screen('Preference', 'ConserveVRAM', 64);  %agregado
Screen('Preference', 'Verbosity', 0);
Screen('Preference', 'SkipSyncTests',1);
Screen('Preference', 'VisualDebugLevel',0);
Screen('Preference', 'ConserveVRAM', 64);

Screen('Preference', 'VBLTimestampingMode', 1);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 2);
Screen('Preference', 'TextAlphaBlending',1);


% Open Psychtoolbox main window

[window,scrnsize] = Screen('OpenWindow', hd.dispscreen, hd.bgcolor);
hd.window = window;
hd.centerx = scrnsize(3)/2;
hd.centery = scrnsize(4)/2;
hd.bottom = scrnsize(4);
hd.right = scrnsize(3);

% Adjust requested SOA so that it is an exact multiple of the base refresh
% interval of the monitor at the current refresh rate.

refreshInterval = Screen('GetFlipInterval',hd.window);
hd.ontime = ceil(hd.ontime/refreshInterval) * refreshInterval;
hd.offtime = ceil(hd.offtime/refreshInterval) * refreshInterval;
fprintf('\nUsing ON time of %dms with OFF time of %dms.\n', round(hd.ontime*1000), round(hd.offtime*1000));
Screen('TextSize',hd.window,hd.textsize);
Screen('TextFont',hd.window,hd.textfont);

  
% Disable mouse pointer and matlab keyboard input

HideCursor;
ListenChar(0);

% % Make sure keyboard mapping is the same on all supported operating systems
% % Apple MacOS/X, MS-Windows and GNU/Linux:

KbName('UnifyKeyNames');

Priority(MaxPriority(0));

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                        Comienzo del SCRIPT                              %
%                                                                         %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Bienvenida

if parallel_port
    io32(pportobj,pportaddr,255)     %envio data para identificar el script
    waitsecs(0.01);
    io32(pportobj,pportaddr,0)
end

textureIndex=Screen('MakeTexture', hd.window, Bienvenida);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);  

KeyCode(13) = 0;
 
while KeyCode(13) == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
end    

WaitSecs(blacktime);

%% Bloque 1:

fprintf(log_txt,'\n');
fprintf(log_txt,'Bloque 1\n');
fprintf(log_txt,'Evento;');
fprintf(log_txt,'TiempoRelativo;');
fprintf(log_txt,'TiempoAbsoluto\n');

% Screen('Flip',hd.window);  

textureIndex=Screen('MakeTexture', hd.window, ConsignaB1);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0       % Se queda en este loop hasta que presione Enter;
    
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

    end
end    


WaitSecs(blacktime);

% Bloque de Prueba

s = sprintf('Bloque de Práctica');
TextBounds = Screen('TextBounds', hd.window, s);

textureIndex=Screen('MakeTexture', hd.window, ConsignaP1);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

    end
end    

% Comienza la reproducción del audio

 Screen('DrawText', hd.window, '+', hd.right/2 , hd.bottom/2 , [255 255 255]);
 Screen('Flip', hd.window) 

PsychPortAudio('FillBuffer',hd.pahandle2,hd.instraudio);
PsychPortAudio('Start',hd.pahandle2,1,0,1);

tiempos(1) = GetSecs; %Guardo el tiempo de inicio

salir = 0;
 
status = PsychPortAudio('GetStatus',hd.pahandle2);  % Me fijo si esta reproduciendo
 
while status.Active == 1 & salir == 0                         
    
    KeyCode(90)=0; 
    [KeyIsDown,secs,KeyCode] = KbCheck;
    
    if KeyCode(75) == 1  % apretó la 'z'
                  
        salir = 1;             %Salgo del Loop  
    
    end
   
   status = PsychPortAudio('GetStatus',hd.pahandle2); % Me fijo si esta reproduciendo   
    
   WaitSecs(0.1);
end    

PsychPortAudio('Stop',hd.pahandle2)

WaitSecs(blacktime);

textureIndex=Screen('MakeTexture', hd.window, ComienzoBloque1);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

    end
end



% Comienza la reproducción del audio bloque I

 Screen('DrawText', hd.window, '+', hd.right/2 , hd.bottom/2 , [255 255 255]);
 Screen('Flip', hd.window)  

PsychPortAudio('FillBuffer',hd.pahandle2,hd.instraudio);
PsychPortAudio('Start',hd.pahandle2,1,0,1);

tiempos(1) = GetSecs; %Guardo el tiempo de inicio

if parallel_port
    io32(pportobj,pportaddr,1)     %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end

fprintf(log_txt,'Inicio;');
fprintf(log_txt,'0');
fprintf(log_txt,';');
fprintf(log_txt,'%d',tiempos(1));
fprintf(log_txt,'\n');

salir = 0;
indice= 2; % indice para contar la cantidad de 'z' apretadas
 
 % Se queda en este loop hasta que presione 'q', mientras cuenta las letras
 % 'z'

status = PsychPortAudio('GetStatus',hd.pahandle2);  % Me fijo si esta reproduciendo
 
while status.Active == 1 & salir == 0                         
    
    KeyCode(90)=0; 
    [KeyIsDown,secs,KeyCode] = KbCheck;
    
    if KeyCode(90) == 1  % apretó la 'z'
        
        tiempos(indice)=GetSecs;
        tiempo_actual(indice)=tiempos(indice)-tiempos(1);
        
        if parallel_port
            io32(pportobj,pportaddr,101)     %Envio data por puerto paralelo
            WaitSecs(0.01);
            io32(pportobj,pportaddr,0)
        end
        
        fprintf(log_txt,'%d',indice);
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempo_actual(indice));
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempos(indice));
        fprintf(log_txt,'\n');
  
        
         while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
         end
        
              
        indice=indice+1;
        
    elseif KeyCode(75) == 1
        
        salir = 1;             %Salgo del Loop  
    
    end
   
   status = PsychPortAudio('GetStatus',hd.pahandle2) % Me fijo si esta reproduciendo   
  
   
 end    

PsychPortAudio('Stop',hd.pahandle2)


save(sprintf('Datos/%s_bloque1.mat',Name),'tiempos', 'tiempo_actual');

WaitSecs(blacktime);

%% Pregunta 1

textureIndex=Screen('MakeTexture', hd.window, Preguntas);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

    end
end    

textureIndex=Screen('MakeTexture', hd.window, Pregunta1);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero=find(KeyCode>0)-48;

        if  numero > 0 & numero < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 1: ;');
fprintf(log_txt,'%d',numero);

WaitSecs(blacktime);

%% Pregunta 2

textureIndex=Screen('MakeTexture', hd.window, Pregunta2);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero2=find(KeyCode>0)-48;

        if  numero2> 0 & numero2 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 2: ;');
fprintf(log_txt,'%d',numero2);
fprintf(log_txt,'\n');


save(sprintf('Datos/%s_respuestas1y2.mat',Name),'numero', 'numero2');

WaitSecs(blacktime);

%% Bloque 2:

fprintf(log_txt,'\n');
fprintf(log_txt,'Bloque 2 \n');
fprintf(log_txt,'Evento;');
fprintf(log_txt,'TiempoRelativo;');
fprintf(log_txt,'TiempoAbsoluto\n');

textureIndex=Screen('MakeTexture', hd.window, ConsignaB2);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

    end
end    
 

clear hd.instraudio
hd.instraudio = wavread('Audio/sampleecg.wav')';

Screen('DrawText', hd.window, '+', hd.right/2 , hd.bottom/2 , [255 255 255]);
Screen('Flip', hd.window)   

PsychPortAudio('FillBuffer',hd.pahandle,hd.instraudio);
PsychPortAudio('Start',hd.pahandle,1,0,1);

tiempos_2(1) = GetSecs; %Guardo el tiempo de inicio

if parallel_port
    io32(pportobj,pportaddr,2) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end

fprintf(log_txt,'Inicio;');
fprintf(log_txt,'0');
fprintf(log_txt,';');
fprintf(log_txt,'%d',tiempos_2(1));
fprintf(log_txt,'\n');

salir = 0;
indice= 2; % indice para contar la cantidad de 'z' apretadas
 
 % Se queda en este loop hasta que presione 'q', mientras cuenta las letras
 % 'z'

status = PsychPortAudio('GetStatus',hd.pahandle);  % Me fijo si esta reproduciendo
 
while status.Active == 1 & salir == 0                         
    
    KeyCode(90)=0; 
    [KeyIsDown,secs,KeyCode] = KbCheck;
    
    if KeyCode(90) == 1  % apretó la 'z'
        
        tiempos_2(indice)=GetSecs;
        tiempo_actual_2(indice)=tiempos_2(indice)-tiempos_2(1);
               
        if parallel_port
            io32(pportobj,pportaddr,102)     %Envio data por puerto paralelo
            WaitSecs(0.01);
            io32(pportobj,pportaddr,0)
        end
        
        fprintf(log_txt,'%d',indice);
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempo_actual_2(indice));
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempos_2(indice));
        fprintf(log_txt,'\n');
       
        while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
        end
        
        indice=indice+1;
        
    elseif KeyCode(75) == 1
        
        salir = 1;             %Salgo del Loop  
    
    end
   
   status = PsychPortAudio('GetStatus',hd.pahandle); % Me fijo si esta reproduciendo   
      
      
 end    

PsychPortAudio('Stop',hd.pahandle);


save(sprintf('Datos/%s_bloque2.mat',Name),'tiempos_2', 'tiempo_actual_2');
WaitSecs(blacktime);


%% Pregunta 3

textureIndex=Screen('MakeTexture', hd.window, Preguntas);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyCode(13) = 0;
KeyCode(80) = 0;

while KeyCode(13) == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
end    

if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

end
   

WaitSecs(blacktime);
  

textureIndex=Screen('MakeTexture', hd.window, Pregunta3);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero3=find(KeyCode>0)-48;

        if  numero3 > 0 & numero3 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 3: ;');
fprintf(log_txt,'%d',numero3);

WaitSecs(blacktime);

%% Pregunta 4

textureIndex=Screen('MakeTexture', hd.window, Pregunta4);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero4=find(KeyCode>0)-48;

        if  numero4> 0 & numero4 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 4: ;');
fprintf(log_txt,'%d',numero4);
fprintf(log_txt,'\n');

save(sprintf('Datos/%s_respuestas3y4.mat',Name),'numero3', 'numero4');

WaitSecs(blacktime);

%% Pausa 1

textureIndex=Screen('MakeTexture', hd.window, FinalE1);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyCode(67) = 0;   % Letra C - Continuo
KeyCode(80) = 0;   % Letra P - Salgo del programa
Continuar   = 0;

while Continuar == 0                          % Se queda en este loop hasta que presione Enter;
   
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);
    
    elseif KeyCode(67)==1
        
        Continuar = 1;
    
    end        

end

WaitSecs(blacktime);

%% Bloque 3

fprintf(log_txt,'\n');
fprintf(log_txt,'Bloque 3 \n');
fprintf(log_txt,'Evento;');
fprintf(log_txt,'TiempoRelativo;');
fprintf(log_txt,'TiempoAbsoluto\n');


textureIndex=Screen('MakeTexture', hd.window, ConsignaB3);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
        PsychPortAudio('Close',hd.pahandle);
        PsychPortAudio('Close',hd.pahandle2);
        Screen('CloseAll'); % Cierro ventana del Psychtoolbox
        fclose(log_txt);

    end
end    

WaitSecs(blacktime);

Screen('DrawText', hd.window, '+', hd.right/2 , hd.bottom/2 , [255 255 255]);
Screen('Flip', hd.window)   


tiempos_3(1)=GetSecs;

if parallel_port
    io32(pportobj,pportaddr,3) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end

salir = 0;
dos_minutos=0; % reinicio el contador de 2 minutos
indice= 2; % indice para contar la cantidad de 'z' apretadas
 
 % Se queda en este loop hasta que presione 'q' o se llegue a 12o minutos
 % mientras cuenta las letras 'z'
 
  KeyCode(90)=0; 
  KeyIsDown   = 0;
  continuar = 0;
     
     while KeyIsDown == 0  & continuar == 0
     
        [KeyIsDown,secs,KeyCode] = KbCheck;
        current_time=GetSecs;
        if KeyCode(90) == 1  % apretó la 'z'
            tiempos_3(indice)=GetSecs
            tiempo_actual_3(1)=0; %Inicio del log conductual
            
            if parallel_port
                io32(pportobj,pportaddr,103)     %Envio data por puerto paralelo
                WaitSecs(0.01);
                io32(pportobj,pportaddr,0)
            end
            
            while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
            end
                
            
            fprintf(log_txt,'%d',indice);
            fprintf(log_txt,';');
            fprintf(log_txt,'%d',tiempo_actual_3(1));
            fprintf(log_txt,';');
            fprintf(log_txt,'%d',tiempos_3(1));
            fprintf(log_txt,'\n');

            indice=indice+1
            continuar=1;
        end
        
        tiempos_3(indice)=GetSecs
        tiempo_actual_3(1)=0; %Inicio del log conductual
            
    end
 


fprintf(log_txt,'Inicio;');
fprintf(log_txt,'0');
fprintf(log_txt,';');
fprintf(log_txt,'%d',tiempos_3(1));
fprintf(log_txt,'\n');

 
while  dos_minutos < 120  & salir == 0                         
    
    KeyCode(90)=0; 
    [KeyIsDown,secs,KeyCode] = KbCheck;
    
    current_time=GetSecs;
    
    if KeyCode(90) == 1  % apretó la 'z'
        
        tiempos_3(indice)=GetSecs;
        tiempo_actual_3(indice-1)=tiempos_3(indice)-tiempos_3(2); % tiempo_3(2) contiene el tiempo de la primer respuesta

        if parallel_port
            io32(pportobj,pportaddr,103)     %Envio data por puerto paralelo
            WaitSecs(0.01);
            io32(pportobj,pportaddr,0)
        end
        
        while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
        end
        
        
        
        fprintf(log_txt,'%d',indice);
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempo_actual_3(indice-1));
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempos_3(indice));
        fprintf(log_txt,'\n');
       
        
        indice=indice+1;
        
    elseif KeyCode(75) == 1
        
        salir = 1;             %Salgo del Loop  
    
    end
   
   dos_minutos = ceil(current_time-tiempos_3(2))-1;
   
   
    
end    

save(sprintf('Datos/%s_bloque3.mat',Name),'tiempos_3', 'tiempo_actual_3');
 
WaitSecs(blacktime);


%% Pregunta 5

textureIndex=Screen('MakeTexture', hd.window, Preguntas);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

    end
end    

textureIndex=Screen('MakeTexture', hd.window, Pregunta5);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero=find(KeyCode>0)-48;

        if  numero > 0 & numero < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 5: ;');
fprintf(log_txt,'%d',numero);

WaitSecs(blacktime);

%% Pregunta 6

textureIndex=Screen('MakeTexture', hd.window, Pregunta6);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero2=find(KeyCode>0)-48;

        if  numero2> 0 & numero2 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 6: ;');
fprintf(log_txt,'%d',numero2);
fprintf(log_txt,'\n');


save(sprintf('Datos/%s_respuestas5y6.mat',Name),'numero', 'numero2');

WaitSecs(blacktime);

%% Bloque 4

fprintf(log_txt,'\n');
fprintf(log_txt,'Bloque 4 \n');
fprintf(log_txt,'Evento;');
fprintf(log_txt,'TiempoRelativo;');
fprintf(log_txt,'TiempoAbsoluto\n');
 
textureIndex=Screen('MakeTexture', hd.window, ConsignaB4);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

    end
end    


WaitSecs(blacktime);

Screen('DrawText', hd.window, '+', hd.right/2 , hd.bottom/2 , [255 255 255]);
Screen('Flip', hd.window)  


tiempos_4(1)=GetSecs;

if parallel_port
    io32(pportobj,pportaddr,4) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end


salir = 0;
dos_minutos=0;  % reinicio el contador de 2 minutos
indice= 2; % indice para contar la cantidad de 'z' apretadas
 

KeyCode(90)=0; 
KeyIsDown   = 0;
continuar = 0;
     
     while KeyIsDown == 0  & continuar == 0
              
        [KeyIsDown,secs,KeyCode] = KbCheck;
        current_time=GetSecs;
        if KeyCode(90) == 1  % apretó la 'z'
           
            tiempos_4(indice) = GetSecs; %Guardo el tiempo de inicio
            tiempo_actual_4(1)=0;

            if parallel_port
                io32(pportobj,pportaddr,104)     %Envio data por puerto paralelo
                WaitSecs(0.01);
                io32(pportobj,pportaddr,0)
            end
            
            
            while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
            end

            
            fprintf(log_txt,'%d',indice);
            fprintf(log_txt,';');
            fprintf(log_txt,'%d',tiempo_actual_4(1));
            fprintf(log_txt,';');
            fprintf(log_txt,'%d',tiempos_4(1));
            fprintf(log_txt,'\n');

        
            indice=indice+1;
            continuar=1;
        end
        tiempos_4(indice) = GetSecs; %Guardo el tiempo de inicio
        tiempo_actual_4(1)=0;

     end

fprintf(log_txt,'Inicio;');
fprintf(log_txt,'0');
fprintf(log_txt,';');
fprintf(log_txt,'%d',tiempos_4(1));
fprintf(log_txt,'\n');
    

% Se queda en este loop hasta que presione 'q' o se llegue a los 120 minutos
 % mientras cuenta las letras 'z'
 
while  dos_minutos < 120  & salir == 0                         
    
    KeyCode(90)=0; 
    [KeyIsDown,secs,KeyCode] = KbCheck;
    
    current_time=GetSecs;
    
    if KeyCode(90) == 1  % apretó la 'z'
        
        tiempos_4(indice)=GetSecs;
        tiempo_actual_4(indice-1)=tiempos_4(indice)-tiempos_4(2);
                       
        if parallel_port
            io32(pportobj,pportaddr,104)     %Envio data por puerto paralelo
            WaitSecs(0.01);
            io32(pportobj,pportaddr,0)
        end
        
        while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
        end


        
        fprintf(log_txt,'%d',indice);
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempo_actual_4(indice-1));
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempos_4(indice));
        fprintf(log_txt,'\n');
        
        indice=indice+1;
        
    elseif KeyCode(75) == 1
        
        salir = 1;             %Salgo del Loop  
    
    end
   
   dos_minutos = ceil(current_time-tiempos_4(2))-1;
   
     
end    

save(sprintf('Datos/%s_bloque4.mat',Name),'tiempos_4', 'tiempo_actual_4');

WaitSecs(blacktime);

%% Pregunta 7

textureIndex=Screen('MakeTexture', hd.window, Preguntas);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyCode(13) = 0;
KeyCode(80) = 0;

while KeyCode(13) == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
end    

if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

end
   

WaitSecs(blacktime);
  

textureIndex=Screen('MakeTexture', hd.window, Pregunta7);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero3=find(KeyCode>0)-48;

        if  numero3 > 0 & numero3 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 7: ;');
fprintf(log_txt,'%d',numero3);

WaitSecs(blacktime);

%% Pregunta 8

textureIndex=Screen('MakeTexture', hd.window, Pregunta8);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero4=find(KeyCode>0)-48;

        if  numero4> 0 & numero4 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 8: ;');
fprintf(log_txt,'%d',numero4);
fprintf(log_txt,'\n');

save(sprintf('Datos/%s_respuestas7y8.mat',Name),'numero3', 'numero4');

WaitSecs(blacktime);


%% Pausa 2

textureIndex=Screen('MakeTexture', hd.window, FinalE2);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyCode(67) = 0;   % Letra C - Continuo
KeyCode(80) = 0;   % Letra P - Salgo del programa
Continuar   = 0;

while Continuar == 0                          % Se queda en este loop hasta que presione Enter;
   
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);
    
    elseif KeyCode(67)==1
        
        Continuar = 1;
    
    end        

end

WaitSecs(blacktime);

%% Bloque habilidades

Hab;
%% Bloque 5

fprintf(log_txt,'\n');
fprintf(log_txt,'Bloque 5 \n');
fprintf(log_txt,'Evento;');
fprintf(log_txt,'TiempoRelativo;');
fprintf(log_txt,'TiempoAbsoluto\n');

textureIndex=Screen('MakeTexture', hd.window, ConsignaB5);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

    end
end    


WaitSecs(blacktime);

Screen('DrawText', hd.window, '+', hd.right/2 , hd.bottom/2 , [255 255 255]);
Screen('Flip', hd.window)   


tiempos_6(1)=GetSecs;

if parallel_port
    io32(pportobj,pportaddr,6) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end

salir = 0;
dos_minutos=0; % reinicio el contador de 2 minutos
indice= 2; % indice para contar la cantidad de 'z' apretadas
 

  KeyCode(90)=0; 
  KeyIsDown   = 0;
  continuar = 0;
     
     while KeyIsDown == 0  & continuar == 0
     
        [KeyIsDown,secs,KeyCode] = KbCheck;
        current_time=GetSecs;
        if KeyCode(90) == 1  % apretó la 'z'
            
            tiempos_6(indice)=GetSecs;
            tiempo_actual_6(1)=0;
            
            if parallel_port
                io32(pportobj,pportaddr,106)     %Envio data por puerto paralelo
                WaitSecs(0.01);
                io32(pportobj,pportaddr,0)
            end
            
            
            while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
            end
       
            
            
            fprintf(log_txt,'%d',indice);
            fprintf(log_txt,';');
            fprintf(log_txt,'%d',tiempo_actual_6(1));
            fprintf(log_txt,';');
            fprintf(log_txt,'%d',tiempos_6(indice));
            fprintf(log_txt,'\n');

       
            indice=indice+1;
            continuar=1;
        end

        tiempos_6(indice)=GetSecs;
        tiempo_actual_6(1)=0;
        
    end

fprintf(log_txt,'Inicio;');
fprintf(log_txt,'0');
fprintf(log_txt,';');
fprintf(log_txt,'%d',tiempos_6(1));
fprintf(log_txt,'\n');

 % Se queda en este loop hasta que presione 'q' o se llegue a 12o minutos
 % mientras cuenta las letras 'z'
 
 
while  dos_minutos < 120  & salir == 0                         
    
    KeyCode(90)=0; 
    [KeyIsDown,secs,KeyCode] = KbCheck;
    
    current_time=GetSecs;
    
    if KeyCode(90) == 1  % apretó la 'z'
        
        tiempos_6(indice)=GetSecs;
        tiempo_actual_6(indice-1)=tiempos_6(indice)-tiempos_6(2);
        
        if parallel_port
            io32(pportobj,pportaddr,106)     %Envio data por puerto paralelo
            WaitSecs(0.01);
            io32(pportobj,pportaddr,0)
        end
        
        while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
        end
        

        
        fprintf(log_txt,'%d',indice);
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempo_actual_6(indice-1));
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempos_6(indice));
        fprintf(log_txt,'\n');
       
        
        indice=indice+1;
        
    elseif KeyCode(75) == 1
        
        salir = 1;             %Salgo del Loop  
    
    end
   
   dos_minutos = ceil(current_time-tiempos_6(2))-1;
   
     
end    

 save(sprintf('Datos/%s_bloque5.mat',Name),'tiempos_6', 'tiempo_actual_6');

WaitSecs(blacktime);

%% Preguntas

textureIndex=Screen('MakeTexture', hd.window, Preguntas);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyCode(13) = 0;
KeyCode(80) = 0;

while KeyCode(13) == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
end    

if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

end
   

WaitSecs(blacktime);
 

textureIndex=Screen('MakeTexture', hd.window, Pregunta9);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);


KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero7=find(KeyCode>0)-48;

        if  numero7 > 0 & numero7 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 9: ;');
fprintf(log_txt,'%d',numero7);

WaitSecs(blacktime);

textureIndex=Screen('MakeTexture', hd.window, Pregunta10);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero8=find(KeyCode>0)-48;

        if  numero8> 0 & numero8 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 10: ;');
fprintf(log_txt,'%d',numero8);
fprintf(log_txt,'\n');

save(sprintf('Datos/%s_respuestas9y10.mat',Name),'numero7', 'numero8');


WaitSecs(blacktime);


%% Bloque 6

fprintf(log_txt,'\n');
fprintf(log_txt,'Bloque 6 \n');
fprintf(log_txt,'Evento;');
fprintf(log_txt,'TiempoRelativo;');
fprintf(log_txt,'TiempoAbsoluto\n');

textureIndex=Screen('MakeTexture', hd.window, ConsignaB6);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyCode(13) = 0;
KeyCode(80) = 0;
KeyIsDown   = 0;

while KeyIsDown == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
    if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

    end
end    
 

WaitSecs(blacktime);

Screen('DrawText', hd.window, '+', hd.right/2 , hd.bottom/2 , [255 255 255]);
Screen('Flip', hd.window)  


tiempo_7(1)=GetSecs;

if parallel_port
    io32(pportobj,pportaddr,7) %Envio data por puerto paralelo
    WaitSecs(0.01);
    io32(pportobj,pportaddr,0)
end

salir = 0;
dos_minutos=0;  % reinicio el contador de 2 minutos
indice= 2; % indice para contar la cantidad de 'z' apretadas


  KeyCode(90)=0; 
  KeyIsDown   = 0;
  continuar = 0;
     
     while KeyIsDown == 0  & continuar == 0
     
        [KeyIsDown,secs,KeyCode] = KbCheck;
        current_time=GetSecs;
        if KeyCode(90) == 1  % apretó la 'z'
            tiempos_7(indice) = GetSecs; %Guardo el tiempo de inicio 
            tiempo_actual_7(1)=0;
            
            while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
            end

            if parallel_port
                io32(pportobj,pportaddr,107)     %Envio data por puerto paralelo
                WaitSecs(0.01);
                io32(pportobj,pportaddr,0)
            end
            
            fprintf(log_txt,'%d',indice);
            fprintf(log_txt,';');
            fprintf(log_txt,'%d',tiempo_actual_7(1));
            fprintf(log_txt,';');
            fprintf(log_txt,'%d',tiempos_7(indice));
            fprintf(log_txt,'\n');


            indice=indice+1;
            continuar=1;
        end

        tiempos_7(indice) = GetSecs; %Guardo el tiempo de inicio
        tiempo_actual_7(1)=0;
        
     end
    
      
fprintf(log_txt,'Inicio;');
fprintf(log_txt,'0');
fprintf(log_txt,';');
fprintf(log_txt,'%d',tiempos_7(1));
fprintf(log_txt,'\n');   
     
 % Se queda en este loop hasta que presione 'q' o se llegue a los 120 minutos
 % mientras cuenta las letras 'z'

 
while  dos_minutos < 120  & salir == 0                         
    
    KeyCode(90)=0; 
    [KeyIsDown,secs,KeyCode] = KbCheck;
    
    current_time=GetSecs;
    
    if KeyCode(90) == 1  % apretó la 'z'
        
        tiempos_7(indice)=GetSecs;
        tiempo_actual_7(indice-1)=tiempos_7(indice)-tiempos_7(2);

        if parallel_port
            io32(pportobj,pportaddr,107)     %Envio data por puerto paralelo
            WaitSecs(0.01);
            io32(pportobj,pportaddr,0)
        end
        
        while KeyIsDown == 1  %Espero que suelte la tecla
       
             [KeyIsDown,secs,KeyCode] = KbCheck;
       
        end


        
        
        fprintf(log_txt,'%d',indice);
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempo_actual_7(indice-1));
        fprintf(log_txt,';');
        fprintf(log_txt,'%d',tiempos_7(indice));
        fprintf(log_txt,'\n');
       
        
        indice=indice+1;
        
    elseif KeyCode(75) == 1
        
        salir = 1;             %Salgo del Loop  
    
    end
   
   dos_minutos = ceil(current_time-tiempos_7(2))-1;
   
     
end    

save(sprintf('Datos/%s_bloque6.mat',Name),'tiempos_7', 'tiempo_actual_7');

WaitSecs(blacktime);

%% Preguntas

textureIndex=Screen('MakeTexture', hd.window, Preguntas);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyCode(13) = 0;
KeyCode(80) = 0;

while KeyCode(13) == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
end    

if KeyCode(80) == 1  % Salgo del programa con la letra p
    
    PsychPortAudio('Close',hd.pahandle);
    PsychPortAudio('Close',hd.pahandle2);
    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    fclose(log_txt);

end
   

WaitSecs(blacktime);
 
textureIndex=Screen('MakeTexture', hd.window, Pregunta11);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero9=find(KeyCode>0)-48;

        if  numero9 > 0 & numero9 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 11: ;');
fprintf(log_txt,'%d',numero9);

WaitSecs(blacktime);

textureIndex=Screen('MakeTexture', hd.window, Pregunta12);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyIsDown = 0;
salir=0; 

while salir == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001); 

    if KeyIsDown == 1  

        numero10=find(KeyCode>0)-48;

        if  numero10> 0 & numero10 < 10
            
            salir=1;
    
        end
    end
    
end    

fprintf(log_txt,'\n');
fprintf(log_txt,'Respuesta 12: ;');
fprintf(log_txt,'%d',numero10);

save(sprintf('Datos/%s_respuestas11y12.mat',Name),'numero9', 'numero10');

WaitSecs(blacktime);


%% Despedida

textureIndex=Screen('MakeTexture', hd.window, Despedida);
Screen('DrawTexture', hd.window, textureIndex);
Screen('Flip',hd.window);

KeyCode(13) = 0;
 
while KeyCode(13) == 0                          % Se queda en este loop hasta que presione Enter;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    WaitSecs(0.001);
end    

 
%% Salir

PsychPortAudio('Close',hd.pahandle);
PsychPortAudio('Close',hd.pahandle2);


% Cierro ventana del Psychtoolbox
fclose(log_txt);    
Screen('CloseAll'); % Cierro ventana del Psychtoolbox


