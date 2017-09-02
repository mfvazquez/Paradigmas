function [exit, log] = CorrerBloque(hd, texturas, botones, bloque, texto_opciones, log)

    global TAMANIO_TEXTO

    exit = false;
    for x = 1:length(bloque)
        sujeto = bloque{x,1};
        emocion = bloque{x,2};
        
        log{x}.emocion = emocion;
        log{x}.sujeto = sujeto;
                
        trial_actual = texturas{sujeto}.(emocion);
        [exit, log{x}] = CorrerSecuencia(hd, botones, trial_actual, log{x});
        if exit
            return
        end
                
        TextoCentrado(texto_opciones, TAMANIO_TEXTO, hd);
        [~, OnSetTime] = Screen('Flip', hd.window);
        [exit, respuesta, tiempo_respuesta] = EsperarBotonesApretar(botones.salir, botones.opciones);
        
        log{x}.opciones_on_set = OnSetTime;
        log{x}.respuesta_tiempo = tiempo_respuesta;
        log{x}.reaction_time = tiempo_respuesta - OnSetTime;
        log{x}.opcion_elegida = respuesta;
        log{x}.texto_opciones = texto_opciones;        
        
    end

end