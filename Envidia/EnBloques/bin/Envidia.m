function Envidia()
    clc;
    sca;
    close all;
    clearvars;

    addpath(fullfile('..','lib'));
    
    nombre = inputdlg('Nombre:');
    nombre = nombre{1};

    
    situaciones_path = fullfile('..','data','envidia', 'situaciones');
    carpetas = dir(situaciones_path);
    carpetas = {carpetas.name};
    carpetas(1) = [];
    carpetas(1) = [];
    
    versiones = cell(1,length(carpetas));
    for i = 1:length(carpetas)
        versiones{1,i} = ['Version ' carpetas{i}];
    end
    
    choice = menu('Version:',versiones);
    version = carpetas{choice};
    
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
      
    % ----------------------- CARGO DATOS ---------------------------------

    envidia = CargarDatos(fullfile('..','data','envidia'), version);
    schan = CargarDatos(fullfile('..','data','schadenfreude'), version);

    % ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
    ListenChar(2);
    HideCursor;
    [window, scrnsize] = init_psych(hd);
    
    personajeA.historia = fileread(fullfile('..','data','HistoriaA.txt'));
    imagen = imread(fullfile('..','data','PersonajeA.jpg'));
    personajeA.textura = Screen('MakeTexture', window, imagen);
    
    personajeB.historia = fileread(fullfile('..','data','HistoriaB.txt'));
    imagen = imread(fullfile('..','data','PersonajeB.jpg'));
    personajeB.textura = Screen('MakeTexture', window, imagen);

    
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
        nombre_archivo = [nombre '_' version '_v' int2str(contador) '_' date '.mat'];
        log_file = fullfile(log_dir, nombre_archivo);
        if (~exist(log_file ,'file')) 
            continuar = false;
        end
       
    end
    
    save(log_file, 'log_envidia', 'log_schan');

end