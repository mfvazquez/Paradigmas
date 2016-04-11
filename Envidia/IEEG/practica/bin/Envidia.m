function Envidia()
    clc;
    sca;
    close all;
    clearvars;

    addpath(fullfile('..','lib'));
    
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
    
    envidia_opciones.pregunta = '¿Qué tanta insatisfacción le produce?';
    envidia_opciones.minimo = 'Ninguna';
    envidia_opciones.medio = 'Neutral';
    envidia_opciones.maximo = 'Mucha';
      
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
   
  
    % ------------------- INICIO DEL PARADIGMA ----------------------------
    
    Preguntas(envidia, personajeA, personajeB, envidia_opciones);
       
    % ---------------------- FIN DEL PARADIGMA ---------------------------

    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    ListenChar(1);
    ShowCursor;
    
end