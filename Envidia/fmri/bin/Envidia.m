function Envidia()
   
%% AGRANDAR LETRA DE AMBOS, BOTON DE CONTINUAR PARA LA PRESENTACION DE PERSONAJES, SIN PERSONAJES EN SCHAN. QUE SE PUEDA INTERCAMBIAR LAS FOTOS CON UN BOTON. 
  %% QUE PRIMERO ESTEN LAS INSTRUCCIONES Y DESPUES ESPERE AL RESONADOR  
    clc;
    sca;
    close all;
    clearvars;

    addpath(fullfile('..','lib'));

    LARGO_LINEA = 26;
    LARGO_INSTRUCCIONES = 37;
    
        % ------------------- CONSTANTES GLOBALES -----------------------------

    global hd; 
    global rightKey;
    global leftKey;
    global spaceKey;
    global auxKey;
    global botones;
    global triggerKey;
    global escKey;
    global continueKey;
    
    continueKey = 'c';
    
    escKey = 'x';
    
%     KbName('UnifyKeyNames');
%     escKey = KbName('ESCAPE');
    
    
    leftKey = '1';
    rightKey =  '2';
    auxKey = '3';
    spaceKey = '4';
    triggerKey = '5';

    botones = [leftKey rightKey auxKey spaceKey];
    

    % -------------------- CONSTANTES -------------------------------------
    
    envidia_opciones.pregunta = '¿Qué tanta insatisfacción le produce?';
    envidia_opciones.minimo   = 'Ninguna';
    envidia_opciones.medio = '';
    envidia_opciones.maximo = 'Mucha';
    
    schan_opciones.pregunta = '¿Qué tanta satisfacción le produce?';
    schan_opciones.minimo = 'Ninguna';
    schan_opciones.medio = '';
    schan_opciones.maximo = 'Mucha';
    
    
    nombre = inputdlg('Nombre:');
    nombre = nombre{1};
    
    choice = menu('Genero:',{'Femenino A' 'Femenino B' 'Masculino A' 'Masculino B'});
    
    MENSAJE_CONTINUAR = 'Presione el boton rojo para continuar';
    
    MENSAJE_FINAL = 'La prueba ha terminado, ahora por favor espere unos minutos mientras termina el registro. Trate de no pensar en nada.';
    MENSAJE_FINAL = AgregarFinLinea(MENSAJE_FINAL, LARGO_LINEA);
    
    TAMANIO = 0.07;
    
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


    %% ------------------- ESPERO A QUE ESTE EL RESONADOR LISTO ------------
    Screen('Flip', hd.window);
    ButtonWait(continueKey);
    trigger_time = GetSecs;
    
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
    
    save(log_file, 'log_envidia', 'log_schan', 'trigger_time');

    WaitSecs(5);
    Screen('Flip', hd.window);

    ButtonWait(escKey);
    Salir;
    
end