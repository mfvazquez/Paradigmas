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
    global escKey;
    global rightKey;
    global leftKey;
    global spaceKey;
    
    % -------------------- CONSTANTES -------------------------------------
    
    envidia_opciones.pregunta = '�Qu� tanta insatisfacci�n le produce?';
    envidia_opciones.minimo = 'Ninguna';
    envidia_opciones.medio = 'Neutral';
    envidia_opciones.maximo = 'Mucha';
    
    schan_opciones.pregunta = '�Qu� tanta satisfacci�n le produce?';
    schan_opciones.minimo = 'Ninguna';
    schan_opciones.medio = 'Neutral';
    schan_opciones.maximo = 'Mucha';
    
    % -------------------- TECLAS A UTILIZAR -------------------------------
    KbName('UnifyKeyNames');
    escKey = KbName('ESCAPE');
    rightKey = KbName('RightArrow');
    leftKey = KbName('LeftArrow');
    spaceKey = KbName('space');
    
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