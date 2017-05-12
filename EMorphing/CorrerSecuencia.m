function [exit, log] = CorrerSecuencia(hd, botones, texturas, log)
    
    for i = 1:length(texturas)
        DibujarTexturaCentrada(texturas{i}, hd.window);
        [~, OnSetTime] = Screen('Flip', hd.window);
        log.on_set{i} = OnSetTime;
        if i == length(texturas)
            [exit, ~, tiempo_respuesta] = EsperarBotonesApretar(botones.salir, botones.aceptar);
        else
            [exit, ~, tiempo_respuesta, ~] = Esperar(0.5, botones.salir, botones.aceptar, [], []);
        end
            
        if ~isempty(tiempo_respuesta)
            log.tiempo_respuesta = tiempo_respuesta;
            log.reaction_time = tiempo_respuesta - log.on_set{1};
            return
        end
        if exit
            return
        end
    end

end