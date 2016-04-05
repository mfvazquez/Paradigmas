function Envidia()
    clc;
    sca;
    close all;
    clearvars;

    addpath(fullfile('..','lib'));

    %PsychJavaTrouble
    global hd; 

    % -------------------- CONSTANTES -------------------------------------

    TIEMPO_INICIAL_CENTRADO = 3;
    TIEMPO_CRUZ_ANTES_PREGUNTA = 1.5;
    TIEMPO_CRUZ_DESPUES_PREGUNTA = 2;
    TIEMPO_PERSONAJE = 8;

    % -------------------- TECLAS A UTILIZAR -------------------------------
    KbName('UnifyKeyNames');
    escKey = KbName('ESCAPE');
    rightKey = KbName('RightArrow');
    leftKey = KbName('LeftArrow');
    spaceKey = KbName('space');
    
    % -------------------- COLORES A UTILIZAR -----------------------------

    white = [255 255 255];
    black = [0 0 0];
    red = [255 0 0];

    
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
    
    % ------------------- + PARA CENTRAR VISTA ----------------------------
    
    textoCentrado(window, TIEMPO_INICIAL_CENTRADO, '+');

    % ------------------- PRESENTACION DE LOS PERSONAJES ------------------
    
    PresentarPersonaje(personajeA, TIEMPO_PERSONAJE, window);
    PresentarPersonaje(personajeB, TIEMPO_PERSONAJE, window);
    
    % ------------------- INSTRUCCIONES -----------------------------------
      
    textoCentradoBoton(window, envidia.instrucciones);


    % ------------------- + PARA CENTRAR VISTA ---------------------------
    
    textoCentrado(window, TIEMPO_CRUZ_ANTES_PREGUNTA, '+');

    % % % % % % ------------------- ESTIMULO ---------------------------------------
    % % % % % 
    % % % % % text = fileread(arch_historia);
    % % % % % textoCentradoBoton(window, scrnsize, text);


    % ------------------- + PARA CENTRAR VISTA ---------------------------
    
    textoCentrado(window, TIEMPO_CRUZ_DESPUES_PREGUNTA, '+');

    % ------------------- OPCIONES ---------------------------------------

%     elegido = 5;
%     dibujarOpciones(window, scrnsize, elegido, textos_opciones);
% 
%     continuar = true;
%     while continuar
% 
%         [~, keyCode, ~] = KbPressWait;
% 
%         if keyCode(rightKey) && elegido < 9
%             elegido = elegido + 1;
%             dibujarOpciones(window, scrnsize, elegido, textos_opciones);
%         elseif keyCode(leftKey) && elegido > 1
%             elegido = elegido - 1;
%             dibujarOpciones(window, scrnsize, elegido, textos_opciones);
%         elseif keyCode(escKey)
%             continuar = false;
%         end   
% 
%     end


    % ---------------------- FIN DEL PARADIGMA ---------------------------

    Screen('CloseAll'); % Cierro ventana del Psychtoolbox
    ListenChar(1);
    ShowCursor;
end