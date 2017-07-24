function [log, exit] = BloquePreguntas(hd, preguntas, botones, log)

    global TAMANIO_TEXTO
    
    TextoCentrado('A continuación conteste 20 preguntas', TAMANIO_TEXTO, hd);
    Screen('Flip',hd.window);
    WaitSecs(2);
    
    for x = 1:length(preguntas)

        TextoCentrado(preguntas{x}.texto_completo, TAMANIO_TEXTO, hd);
        log{x}.pregunta_onset = blink;
        botones_respuestas = botones.opciones(1:length(preguntas{x}.respuestas));
        
        [exit, respuesta, tiempo_respuesta] = EsperarBotonesApretar(botones.salir, botones_respuestas);
        log{x}.tiempo_respuesta = blink;
        log{x}.respuesta = respuesta;
        log{x}.datos_trial = preguntas{x};
        log{x}.reaction_time = log{x}.tiempo_respuesta - log{x}.pregunta_onset;
        if exit
            return
        end
        
        %% PANTALLA EN BLANCO
        Screen('Flip',hd.window);
        Esperar(0.5,botones.salir, []);
        
    end
        
end