function [log, exit] = Preguntas(bloque, personajeA, personajeB, opciones, esperar_resonador, log)

    global hd; 
    global rightKey;
    global leftKey;
    global spaceKey;
    global auxKey;
    global botones;
    global triggerKey;
    global TAMANIO_TEXTO;
    global MENSAJE_CONTINUAR;
    
    exit = false;
    
    TIEMPO_CRUZ_ANTES_PREGUNTA = 6;
    TIEMPO_CRUZ_DESPUES_PREGUNTA = 1;

    TIEMPO_INICIAL_CENTRADO = 5;
%     TIEMPO_PERSONAJE = 8;

    % ------------------- + PARA CENTRAR VISTA ----------------------------

    textoCentrado('+', TAMANIO_TEXTO);
    Screen('Flip', hd.window);
    WaitSecs(TIEMPO_INICIAL_CENTRADO); 
    
    % ------------------- INSTRUCCIONES -----------------------------------

    textoCentrado(bloque.instrucciones, TAMANIO_TEXTO);
    Screen('Flip', hd.window);
    exit = ButtonWait(spaceKey);
    if exit
        return;
    end
    
   for i = 1:length(bloque.situaciones)

        % -------------------- ESTIMULO ---------------------------------------

        if (bloque.situaciones{1,i}.personaje == 'A')
            [OnSetTime, exit] = PresentarSituacion(bloque.situaciones{1,i}.texto, personajeA.textura, MENSAJE_CONTINUAR);
            log.personaje{1,i} = 'A';
            if exit 
                return;
            end
        else
            [OnSetTime, exit] = PresentarSituacion(bloque.situaciones{1,i}.texto, personajeB.textura, MENSAJE_CONTINUAR);
            log.personaje{1,i} = 'B';
            if exit 
                return;
            end
        end
        log.estimulo_inicio{1,i} = OnSetTime;
        log.estimulo_fin{1,i} = GetSecs;
        % ------------------- + PARA CENTRAR VISTA ------------------------
        
        textoCentrado('+', TAMANIO_TEXTO);
        Screen('Flip', hd.window);
        WaitSecs(TIEMPO_CRUZ_ANTES_PREGUNTA);
        
        % -------------------- PREGUNTA CON OPCIONES ----------------------
        
        elegido = 5;
        dibujarOpciones(elegido, opciones, true);
        OnSetTime = blink();
        log.opciones_inicio{1,i} = OnSetTime;
        
        primer_movimiento = -1;
        continuar = true;
        FlushEvents;
        while continuar
            dibujarOpciones(elegido, opciones, true);
            Screen('Flip', hd.window);
            [elegido, continuar, exit] = EsperarRespuesta(elegido);
            if exit 
                return;
            end
            if primer_movimiento == -1
                primer_movimiento = GetSecs;
            end
        end
        log.opciones_fin{1,i} = GetSecs;
        log.respuesta{1,i} = elegido;
        log.opciones_PrimerMovimiento{1,i} = primer_movimiento;
        
        % ------------------- + PARA CENTRAR VISTA ---------------------------
    
        textoCentrado('+', TAMANIO_TEXTO);
        Screen('Flip', hd.window);
        WaitSecs(TIEMPO_CRUZ_DESPUES_PREGUNTA);

    end
end