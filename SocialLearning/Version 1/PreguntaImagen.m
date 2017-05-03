function [log, exit] = PreguntaImagen(hd, textura, opciones, textos, teclas)

    DibujarPreguntaImagen(hd, textura, opciones, textos);
    [~, OnSetTime] = Screen('Flip',hd.window);
    [exit, respuesta, tiempo_respuesta] = EsperarBotonesApretar(teclas.salir, {teclas.izquierda teclas.derecha});
    if exit 
        return
    end    
    if respuesta == 1
        log.respuesta_elegida = textos.izquierda;
    elseif respuesta == 2
        log.respuesta_elegida = textos.derecha;
    end

    log.estimulo_onset = OnSetTime;
    log.respuesta_tiempo = tiempo_respuesta;
    log.reaction_time = tiempo_respuesta - OnSetTime;
    

    
end