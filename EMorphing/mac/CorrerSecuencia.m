function [exit, log] = CorrerSecuencia(hd, botones, texturas, log)
    
    global TIEMPO_ENTRE_IMAGENES

    for i = 1:length(texturas)
        DibujarTexturaCentrada(texturas{i}, hd.window);
        [~, OnSetTime] = Screen('Flip', hd.window);
        if ~isempty(log)
            log.on_set{i} = OnSetTime;
        end
        
        if i == length(texturas)
            [exit, ~, tiempo_respuesta] = EsperarBotonesApretar(botones.salir, botones.aceptar);
        else
            [exit, ~, tiempo_respuesta, ~] = Esperar(TIEMPO_ENTRE_IMAGENES, botones.salir, botones.aceptar, [], []);
        end
            
        if ~isempty(tiempo_respuesta)
            if  ~isempty(log)
                log.tiempo_respuesta = tiempo_respuesta;
                log.reaction_time = tiempo_respuesta - log.on_set{1};
            end
            return
        end
        if exit
            return
        end
    end

end