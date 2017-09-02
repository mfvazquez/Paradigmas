% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, respuesta, tiempo_respuesta] = EsperarBotonesApretar(botonSalida, botones)
    exit = false;
    tStart = GetSecs;
    respuesta = [];
    tiempo_respuesta = [];
    while true
        [secs, keyCode, ~] =  KbPressWait;
        
        if keyCode(botonSalida)
            exit = true;
            return
        end
        
        for i = 1:length(botones)
            if keyCode(botones(i))
                respuesta = i;
                tiempo_respuesta = secs;
                return;
            end
        end
        
    end
end