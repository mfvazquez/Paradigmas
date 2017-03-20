% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, respuesta, tiempo_respuesta, saltear_bloque] = Esperar(tiempo, botonSalida, botones, botones_salteado)
    exit = false;
    tStart = GetSecs;
    respuesta = [];
    tiempo_respuesta = [];
    saltear_bloque = false;
    while GetSecs - tStart < tiempo
        [~, ~, keyCode, ~] = KbCheck;
        
        if keyCode(botonSalida)
            exit = true;
            return
        end
        
        if ~isempty(botones)
            for i = 1:length(botones)
                if keyCode(botones{i})
                    respuesta = i;
                    tiempo_respuesta = GetSecs;
                    return;
                end
            end
            
            saltear_bloque = BotonesApretados(keyCode, botones_salteado);
            if saltear_bloque
                return;
            end
            
        end
    end
end