function log = Preguntas(bloque, personajeA, personajeB, opciones)

    global window;
    global scrnsize;
    global escKey;
    global rightKey;
    global leftKey;
    global spaceKey;

    TIEMPO_CRUZ_ANTES_PREGUNTA = 5.5;
    TIEMPO_CRUZ_DESPUES_PREGUNTA = 5;

    TIEMPO_INICIAL_CENTRADO = 5;
    TIEMPO_PERSONAJE = 8;

    MENSAJE_CONTINUAR = 'Presione cualquier boton cuando termine de leer';
        
    % --------------------- PREPARO LOG -----------------------------------
    
    largo = length(bloque.situaciones);
        
    log.opciones = zeros(1, largo);
    log.respuesta_tiempo = zeros(1, largo);    
    log.respuesta = zeros(1, largo);
    log.personaje = cell(1, largo);
    log.estimulo = zeros(1, largo);
    
    % ------------------- + PARA CENTRAR VISTA ----------------------------

    textoCentrado(TIEMPO_INICIAL_CENTRADO, '+');

    % ------------------- PRESENTACION DE LOS PERSONAJES ------------------

    PresentarImagen(personajeA.historia, personajeA.textura);
    Screen('Flip', window);    
    WaitSecs(TIEMPO_PERSONAJE);
    
    PresentarImagen(personajeB.historia, personajeB.textura);
    Screen('Flip', window);    
    WaitSecs(TIEMPO_PERSONAJE);
    
    
    % ------------------- INSTRUCCIONES -----------------------------------

    textoCentradoBoton(bloque.instrucciones);

    for i = 1:length(bloque.situaciones)

        % -------------------- ESTIMULO ---------------------------------------

        if (bloque.situaciones{1,i}.personaje == 'A')
            OnSetTime = PresentarSituacion(bloque.situaciones{1,i}.texto, personajeA.textura, MENSAJE_CONTINUAR);
            log.personaje{1,i} = 'A';
        else
            OnSetTime = PresentarSituacion(bloque.situaciones{1,i}.texto, personajeB.textura, MENSAJE_CONTINUAR);
            log.personaje{1,i} = 'B';
        end
        log.estimulo(1,i) = OnSetTime;

        % ------------------- + PARA CENTRAR VISTA ------------------------

        textoCentrado(TIEMPO_CRUZ_ANTES_PREGUNTA, '+');
        
        % -------------------- PREGUNTA CON OPCIONES ----------------------
        
        elegido = 5;
        dibujarOpciones(elegido, opciones, true);
        OnSetTime = blink();
        log.opciones(1,i) = OnSetTime;
        
        continuar = true;
        while continuar
            dibujarOpciones(elegido, opciones, true);
            Screen('Flip', window);
            [elegido, continuar] = EsperarRespuesta(elegido);
        end
        dibujarOpciones(elegido, opciones, true);
        OnSetTime = blink();
        log.respuesta_tiempo(1,i) = OnSetTime;
        log.respuesta(1,i) = elegido;
        
        % ------------------- + PARA CENTRAR VISTA ---------------------------
    
        textoCentrado(TIEMPO_CRUZ_DESPUES_PREGUNTA, '+');

    end
end