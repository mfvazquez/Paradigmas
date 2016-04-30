function Envidia()
    clc;
    sca;
    close all;
    clearvars;

    addpath(fullfile('..','lib'));
    
    nombre = inputdlg('Nombre:');
    nombre = nombre{1};

    %PsychJavaTrouble

    % ------------------- CONSTANTES GLOBALES -----------------------------

    global hd; 
    global window;
    global scrnsize;
    global pportobj;
    global pportaddr;
    
    % -------------------- CONSTANTES -------------------------------------
    
    envidia_opciones.pregunta = '¿Qué tanta insatisfacción le produce?';
    envidia_opciones.minimo = 'Ninguna';
    envidia_opciones.medio = 'Neutral';
    envidia_opciones.maximo = 'Mucha';
    
    schan_opciones.pregunta = '¿Qué tanta satisfacción le produce?';
    schan_opciones.minimo = 'Ninguna';
    schan_opciones.medio = 'Neutral';
    schan_opciones.maximo = 'Mucha';
    
    % ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
    ListenChar(2);
    HideCursor;
    [window, scrnsize] = init_psych(hd);
    
    % ----------------------- CARGO DATOS ---------------------------------

    personajeA.historia = fileread(fullfile('..','data','HistoriaA.txt'));
    imagen = imread(fullfile('..','data','PersonajeA.jpg'));
    personajeA.textura = Screen('MakeTexture', window, imagen);
    
    personajeB.historia = fileread(fullfile('..','data','HistoriaB.txt'));
    imagen = imread(fullfile('..','data','PersonajeB.jpg'));
    personajeB.textura = Screen('MakeTexture', window, imagen);
    
    envidia = CargarDatos(fullfile('..','data','envidia'));
    schan = CargarDatos(fullfile('..','data','schadenfreude'));
  
    % ------------------- INICIALIZO PUERTO PARALELO ----------------------

    % Init Puerto Paralelo (io32.dll debe estar en la carpeta del proyecto y la 
    % input32.dll en c:\windows\system32 y/o c:\windows\system)

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

    % ------------------- ESPERA AL RESONADOR -----------------------------
    
    textoCentrado(0, 'Esperando al resonador...');
    % Sincronización con el resonador
    start_signal= 4;

    wait_start = true;
    while (wait_start)
           input_data=io32(pportobj,pportaddr);
           input_data=bitand(input_data, 4);
           if input_data == start_signal %Una vez que ocurra la señal del resonador, arranca
               wait_start=false;
           end
    end
    
    % ------------------- INICIO DEL PARADIGMA ----------------------------
    
    log_envidia = Preguntas(envidia, personajeA, personajeB, envidia_opciones);
    log_schan = Preguntas(schan, personajeA, personajeB, schan_opciones);
    
    % ---------------------- FIN DEL PARADIGMA ---------------------------

    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    ListenChar(1);
    ShowCursor;
    
    log_dir = fullfile('..', 'log');
    
    if (~exist(log_dir ,'dir')) 
        mkdir(log_dir);
    end
    
    continuar = true;
    contador = 0;
    while continuar
        contador = contador + 1;
        nombre_archivo = [nombre '_v' int2str(contador) '_' date '.mat'];
        log_file = fullfile(log_dir, nombre_archivo);
        if (~exist(log_file ,'file')) 
            continuar = false;
        end
       
    end
    
    save(log_file, 'log_envidia', 'log_schan');

end