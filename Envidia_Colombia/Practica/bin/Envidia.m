function Envidia()
   
    clc;
    sca;
    close all;
    clearvars;

    addpath(fullfile('..','lib'));

    LARGO_LINEA = 40;
    LARGO_INSTRUCCIONES = 40;
    
        % ------------------- CONSTANTES GLOBALES -----------------------------

    global hd; 
    global rightKey;
    global leftKey;
    global spaceKey;
    global auxKey;
    global botones;
    global escKey;
    
    global TAMANIO_TEXTO;
    global TAMANIO_MENSAJE_CONTINUAR;
    global TAMANIO_PREGUNTA;
    
    global MENSAJE_CONTINUAR;
    
    TAMANIO_PREGUNTA = 0.05;    
    TAMANIO_TEXTO = 0.04;
    TAMANIO_MENSAJE_CONTINUAR = 0.03;
    
    KbName('UnifyKeyNames');
    escKey = KbName('ESCAPE');
    rightKey = KbName('RightArrow');
    leftKey = KbName('LeftArrow');
    spaceKey = KbName('space');
    auxKey = [];
    
    botones = [leftKey rightKey auxKey spaceKey];
    

    % -------------------- CONSTANTES -------------------------------------
    
    envidia_opciones.pregunta = '¿Qué tanta insatisfacción le produce?';
    envidia_opciones.minimo   = 'Ninguna';
    envidia_opciones.medio = 'Neutral';
    envidia_opciones.maximo = 'Mucha';
    
    schan_opciones.pregunta = '¿Qué tanta satisfacción le produce?';
    schan_opciones.minimo = 'Ninguna';
    schan_opciones.medio = 'Neutral';
    schan_opciones.maximo = 'Mucha';
    
    
    nombre = inputdlg('Nombre:');
    nombre = nombre{1};
    
    choice = menu('Genero:',{'Femenino A' 'Femenino B' 'Masculino A' 'Masculino B'});
    
    MENSAJE_CONTINUAR = 'Presione la barra espaciadora para continuar';
    
    MENSAJE_FINAL = 'La prueba ha terminado.\nGuardando Datos...';
    MENSAJE_FINAL = AgregarFinLinea(MENSAJE_FINAL, LARGO_LINEA);
    
    TAMANIO = 0.035;
    
    % ------------------- INICIALIZO PSYCHOTOOLBOX ------------------------
    ListenChar(2);
    HideCursor;
    hd = init_psych();
    
    
%%    ----------------------- CARGO DATOS ---------------------------------

    % --------------------- MENSAJE DE ESPERA -----------------------------
    
    textoCentrado('Cargando Datos...', TAMANIO);
    Screen('Flip', hd.window);
    
    if choice == 1 || choice == 2 
        genero = 'femenino';
    else
        genero = 'masculino';
    end
                
    personajeA.historia = fileread(fullfile('..','data',genero,'HistoriaA.txt'));
    personajeA.historia = AgregarFinLinea(personajeA.historia, LARGO_LINEA);

    imagen = imread(fullfile('..','data',genero,'PersonajeA.jpg'));
    personajeA.textura = Screen('MakeTexture', hd.window, imagen);

    personajeB.historia = fileread(fullfile('..','data',genero,'HistoriaB.txt'));
    personajeB.historia = AgregarFinLinea(personajeB.historia, LARGO_LINEA);

    imagen = imread(fullfile('..','data',genero,'PersonajeB.jpg'));
    personajeB.textura = Screen('MakeTexture', hd.window, imagen);

    tipo = 'A';
    % INVIERTO FOTOS DE PERSONAJES
    if choice == 2 || choice == 4
       tipo = 'B';
       aux = personajeA.textura;
       personajeA.textura = personajeB.textura;
       personajeB.textura = aux;
    end
    
    
    envidia = CargarDatos(fullfile('..','data',genero,'envidia'));
    envidia = DividirTextos(envidia, LARGO_LINEA, LARGO_INSTRUCCIONES);
    schan = CargarDatos(fullfile('..','data',genero,'schadenfreude'));
    schan = DividirTextos(schan, LARGO_LINEA, LARGO_INSTRUCCIONES);
    
    
        % --------------------- PREPARO LOG -----------------------------------
    log_envidia = PrepararLog(envidia);
    log_schan = PrepararLog(schan);


    %% ------------------- PRESENTACION DE LOS PERSONAJES ------------------

    DibujarSituacion(personajeA.historia, personajeA.textura, MENSAJE_CONTINUAR);
    Screen('Flip', hd.window);    
    exit = ButtonWait(spaceKey);
    if exit
        Salir;
        return;
    end
    

    DibujarSituacion(personajeB.historia, personajeB.textura, MENSAJE_CONTINUAR);
    Screen('Flip', hd.window);    
    exit = ButtonWait(spaceKey);
    if exit
        Salir;
        return;
    end

    
    % ------------------- INICIO DEL PARADIGMA ----------------------------
    

   [log_envidia, exit] = Preguntas(envidia, personajeA, personajeB, envidia_opciones, true, log_envidia);
    if ~exit
        [log_schan, ~] = Preguntas(schan, personajeA, personajeB, schan_opciones, false, log_schan);
    end
    
    % ---------------------- FIN DEL PARADIGMA ---------------------------
    
    textoCentrado(MENSAJE_FINAL, TAMANIO);
    Screen('Flip', hd.window);
    
    log_dir = fullfile('..', 'log');
    
    if (~exist(log_dir ,'dir')) 
        mkdir(log_dir);
    end
    
    continuar = true;
    contador = 0;
    while continuar
        contador = contador + 1;
        nombre_archivo = [nombre '_Envidia&Schan' '_v' int2str(contador) '_' genero tipo '_' date '.mat'];
        log_file = fullfile(log_dir, nombre_archivo);
        if (~exist(log_file ,'file')) 
            continuar = false;
        end
       
    end
    
    save(log_file, 'log_envidia', 'log_schan');

    Salir;
    
end