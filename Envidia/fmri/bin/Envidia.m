function Envidia()
    clc;
    sca;
    close all;
    clearvars;

    addpath(fullfile('..','lib'));
    
    nombre = inputdlg('Nombre:');
    nombre = nombre{1};

    %PsychJavaTrouble

    LARGO_LINEA = 36;
    LARGO_INSTRUCCIONES = 50;
    
    % ------------------- CONSTANTES GLOBALES -----------------------------

    global hd; 
    global rightKey;
    global leftKey;
    global spaceKey;
    global auxKey;

    rightKey =  '2';
    leftKey = '1';
    spaceKey = '4';
    auxKey = '3';
    triggerKey = '5';
    

    % -------------------- CONSTANTES -------------------------------------
    
    envidia_opciones.pregunta = '¿Qué tanta insatisfacción le produce?';
    envidia_opciones.minimo   = 'Ninguna';
    envidia_opciones.medio = 'Neutral';
    envidia_opciones.maximo = 'Mucha';
    
    schan_opciones.pregunta = '¿Qué tanta satisfacción le produce?';
    schan_opciones.minimo = 'Ninguna';
    schan_opciones.medio = 'Neutral';
    schan_opciones.maximo = 'Mucha';
    
    % ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
    ListenChar(2);
    HideCursor;
    hd = init_psych();
    
    
%%    ----------------------- CARGO DATOS ---------------------------------

    % --------------------- MENSAJE DE ESPERA -----------------------------
    
    textoCentrado('Cargando Datos...', 0.04);
    Screen('Flip', hd.window);
    

    personajeA.historia = fileread(fullfile('..','data','HistoriaA.txt'));
    personajeA.historia = AgregarFinLinea(personajeA.historia, LARGO_LINEA);
    
    imagen = imread(fullfile('..','data','PersonajeA.jpg'));
    personajeA.textura = Screen('MakeTexture', hd.window, imagen);
    
    personajeB.historia = fileread(fullfile('..','data','HistoriaB.txt'));
    personajeB.historia = AgregarFinLinea(personajeB.historia, LARGO_LINEA);
    
    imagen = imread(fullfile('..','data','PersonajeB.jpg'));
    personajeB.textura = Screen('MakeTexture', hd.window, imagen);
    envidia = CargarDatos(fullfile('..','data','envidia'));
    envidia = DividirTextos(envidia, LARGO_LINEA, LARGO_INSTRUCCIONES);
    schan = CargarDatos(fullfile('..','data','schadenfreude'));
    schan = DividirTextos(schan, LARGO_LINEA, LARGO_INSTRUCCIONES);

    %% -------------------- ESPERO AL RESONADOR ---------------------------
    textoCentrado('Esperando al resonador...', 0.04);
    Screen('Flip', hd.window);
    
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