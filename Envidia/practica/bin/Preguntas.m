function Preguntas(bloque, personajeA, personajeB, opciones)

    global window;
    global scrnsize;
    global escKey;
    global rightKey;
    global leftKey;
    global spaceKey;

    
    global pportobj;
    global pportaddr;
    
    TIEMPO_CRUZ_ANTES_PREGUNTA = 1.5;
    TIEMPO_CRUZ_DESPUES_PREGUNTA = 2;

    TIEMPO_INICIAL_CENTRADO = 3;
    TIEMPO_PERSONAJE = 8;

    MENSAJE_CONTINUAR = 'Presione la barra espaciadora cuando termine de leer';
        
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
            exit = PresentarSituacion(bloque.situaciones{1,i}.texto, personajeA.textura, MENSAJE_CONTINUAR);
        else
            exit = PresentarSituacion(bloque.situaciones{1,i}.texto, personajeB.textura, MENSAJE_CONTINUAR);
        end
        if exit
            break;
        end
        % ------------------- + PARA CENTRAR VISTA ------------------------

        textoCentrado(TIEMPO_CRUZ_ANTES_PREGUNTA, '+');

        % -------------------- PREGUNTA -----------------------------------
        

        dibujarOpciones([], opciones, false);
        Screen('Flip', window);  
        continuar = true;
        while continuar
            [~, continuar, exit] = EsperarRespuesta(0);
        end
        if exit
            break;
        end
        
        % -------------------- PANTALLA NEGRA -----------------------------
        
        Screen('Flip', window);
        WaitSecs(2);
        
        % -------------------- PREGUNTA CON OPCIONES ----------------------
        
        elegido = 5;
        continuar = true;
        dibujarOpciones(elegido, opciones, true);
        Screen('Flip', window);
        
        while continuar
            dibujarOpciones(elegido, opciones, true);
            Screen('Flip', window);
            [elegido, continuar, exit] = EsperarRespuesta(elegido);
        end
        dibujarOpciones(elegido, opciones, true);
        Screen('Flip', window);
        
        if exit
            break;
        end

        % ------------------- + PARA CENTRAR VISTA ---------------------------
    
        textoCentrado(TIEMPO_CRUZ_DESPUES_PREGUNTA, '+');

    end
end