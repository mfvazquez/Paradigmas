function log = Preguntas(bloque, personajeA, personajeB, opciones)

    global hd;
    
    
    TIEMPO_CRUZ_ANTES_PREGUNTA = 5.5;
    TIEMPO_CRUZ_DESPUES_PREGUNTA = 5;

    TIEMPO_INICIAL_CENTRADO = 5;
    TIEMPO_PERSONAJE = 8;

    MENSAJE_CONTINUAR = '';
        
       
    % --------------------- PREPARO LOG -----------------------------------
    
    largo = length(bloque.situaciones);

    log.personaje = cell(1, largo);
    log.estimulo_inicio = cell(1, largo);
    log.estimulo_fin = cell(1, largo);
 
    log.opciones_inicio = cell(1, largo);
    log.opciones_fin = cell(1, largo);    
    log.respuesta = cell(1, largo);       
    log.opciones_PrimerMovimiento = cell(1, largo);
        
    
    % ------------------- + PARA CENTRAR VISTA ----------------------------

    textoCentrado(TIEMPO_INICIAL_CENTRADO, '+');

    % ------------------- PRESENTACION DE LOS PERSONAJES ------------------

    PresentarImagen(personajeA.historia, personajeA.textura);
    Screen('Flip', hd.window);    
    WaitSecs(TIEMPO_PERSONAJE);
    
    PresentarImagen(personajeB.historia, personajeB.textura);
    Screen('Flip', hd.window);    
    WaitSecs(TIEMPO_PERSONAJE);
    
    
    % ------------------- INSTRUCCIONES -----------------------------------

    textoCentrado(bloque.instrucciones, 0.04);
    Screen('Flip', hd.window);
    KbWait;
    
    for i = 1:length(bloque.situaciones)

        % -------------------- ESTIMULO ---------------------------------------

        if (bloque.situaciones{1,i}.personaje == 'A')
            OnSetTime = PresentarSituacion(bloque.situaciones{1,i}.texto, personajeA.textura, MENSAJE_CONTINUAR);
            log.personaje{1,i} = 'A';
        else
            OnSetTime = PresentarSituacion(bloque.situaciones{1,i}.texto, personajeB.textura, MENSAJE_CONTINUAR);
            log.personaje{1,i} = 'B';
        end
        log.estimulo_inicio{1,i} = OnSetTime;
        log.estimulo_fin{1,i} = GetSecs;
        % ------------------- + PARA CENTRAR VISTA ------------------------

        textoCentrado(TIEMPO_CRUZ_ANTES_PREGUNTA, '+');
        
        % -------------------- PREGUNTA CON OPCIONES ----------------------
        
        elegido = 5;
        dibujarOpciones(elegido, opciones, true);
        OnSetTime = blink();
        log.opciones_inicio{1,i} = OnSetTime;
        
        primer_movimiento = -1;
        continuar = true;
        while continuar
            dibujarOpciones(elegido, opciones, true);
            Screen('Flip', hd.window);
            [elegido, continuar] = EsperarRespuesta(elegido);
            if primer_movimiento == -1
                primer_movimiento = GetSecs;
            end
        end
        log.opciones_fin{1,i} = GetSecs;
        log.respuesta{1,i} = elegido;
        log.opciones_PrimerMovimiento{1,i} = primer_movimiento;
        
        % ------------------- + PARA CENTRAR VISTA ---------------------------
    
        textoCentrado(TIEMPO_CRUZ_DESPUES_PREGUNTA, '+');

    end
end