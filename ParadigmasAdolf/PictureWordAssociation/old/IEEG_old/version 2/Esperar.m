% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, respuesta, tiempo] = Esperar(tiempo, botonSalida, botones)
    exit = false;
    tStart = GetSecs;
    respuesta = 0;
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
                    tiempo = GetSecs;
                    return;
                end
            end
        end
    end
end