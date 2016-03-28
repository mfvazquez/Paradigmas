% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Ezequiel 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE ENVIRONMENT
%%%%%%%%%%%%%%%%%%%%%%

%% Clear Matlab/Octave window:
clc;
clear all

%% Inicializacion de variables

parallel_port= false; % true: marcas por puerto paralelo habilitadas, false: marcas inhabilitadas
%Para los estimulos el valor de la marca se establece por medio de la fila
%de la matriz B. (ver Mark_code.txt)
%Para las respuestas se envía como marca el valor de la tecla presionada:
%37: flecha izq;
%39: flecha der;

PHOTODIODE=true; %fotodiodo para intra, true: envía marcas, false: no envía marcas
pdpix=[100 50];
white = [1 1 1]*255;
A=[];

%%

PsychJavaTrouble

global hd 

%% Puerto paralelo

if parallel_port
    
    % Init Puerto Paralelo (io32.dll debe estar en la carpeta del proyecto y la
    % input32.dll en c:\windows\system32 y/o c:\windows\system)
    
    
    global pportobj pportaddr
    
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


%%  Load audio

wavfile_center= wavread('Medio_31_center.wav');
wavfile_center=wavfile_center';
wavfile_left=wavread('Medio_31_izq.wav');
wavfile_left=wavfile_left';
wavfile_right=wavread('Medio_31_der.wav');
wavfile_right=wavfile_right';

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
    hd.pahandle = PsychPortAudio('Open',audiodevices(1,end).DeviceIndex,[],1,hd.f_sample,2);
    PsychPortAudio('Volume', hd.pahandle , 1.25);
%     pahandle2 = PsychPortAudio('Open',audiodevices(1,9).DeviceIndex,[],1,f_sample2,2);
%     PsychPortAudio('Volume', pahandle2 , 1.25);
    
    InitializePsychSound(1);
    
%     hd.pahandle = PsychPortAudio('Open',audiodevices(outdevice).DeviceIndex,[],[0],hd.f_sample,2);
%       hd.pahandle = PsychPortAudio('Open',audiodevices(outdevice).DeviceIndex);
%       hd.pahandle = PsychPortAudio('Open',audiodevices(outdevice).DeviceIndex,1,1,hd.f_sample,1);
%     hd.pahandle = PsychPortAudio('Open',audiodevices(1,5).DeviceIndex);
end

%% Setup psychtoolbox display

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

% Get screenNumber of stimulation display. We choose the display with
% the maximum index, which is usually the right one, e.g., the external
% display on a Laptop:
screens         = Screen('Screens');
whichScreen     = max(screens);


% % Make sure keyboard mapping is the same on all supported operating systems
% % Apple MacOS/X, MS-Windows and GNU/Linux:

KbName('UnifyKeyNames');

%Screen settings

[screenXpixels, screenYpixels] = Screen('WindowSize', window);

two_blinks=[0 0 pdpix; screenXpixels-pdpix(1) 0 screenXpixels pdpix(2)];
blink_left=[0 0 pdpix];
blink_right=[screenXpixels-pdpix(1) 0 screenXpixels pdpix(2)];
blink_center= [screenXpixels/2-pdpix(1)/2 0 screenXpixels/2+pdpix(1)/2 pdpix(2)];

%% Disable mouse pointer and matlab keyboard input

ListenChar(2);
HideCursor;


%% Teclas a usar

escapeKey = KbName('ESCAPE');

fKey = KbName('f'); % blink -> beep
jKey = KbName('j'); % beep -> blink

%% Comienzo del programa

PsychPortAudio('FillBuffer',hd.pahandle,wavfile_center);


seguir = true;
while seguir

    [~, keyCode, ~] = KbPressWait;
    
    if keyCode(fKey)
        Screen('FillRect', window ,255, blink_center);
        Screen('Flip', window, 0 , 1);
        PsychPortAudio('Start',hd.pahandle,1,0,1);
        WaitSecs(0.1);
        Screen('FillRect', window , 0, blink_center);
        Screen('Flip', window, 0 , 1);

    elseif keyCode(jKey)
        PsychPortAudio('Start',hd.pahandle,1,0,1);
        Screen('FillRect', window ,255, blink_center);
        Screen('Flip', window, 0 , 1);
        WaitSecs(0.1);
        Screen('FillRect', window , 0, blink_center);
        Screen('Flip', window, 0 , 1);
        
    elseif keyCode(escapeKey)
          seguir = false;
    end
end
    
ShowCursor;
ListenChar(1);

%Salgo del programa
PsychPortAudio('Close',hd.pahandle);
% PsychPortAudio('Close',pahandle2);
Screen('CloseAll'); % Cierro ventana del Psychtoolbox


