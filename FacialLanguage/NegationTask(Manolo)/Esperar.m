% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, respuesta] = Esperar(tiempo, botonSalida, botones)
    exit = false;
    tStart = GetSecs;
    respuesta.valor = '';
    respuesta.tiempo = NaN;
    while GetSecs - tStart < tiempo
        [~, ~, keyCode, ~] = KbCheck;
        
        if keyCode(botonSalida)
            exit = true;
            return
        end
        
        if ~isempty(botones)
            for i = 1:length(botones)
                if keyCode(botones{i}.KEY)
                    respuesta.valor = botones{i}.KEY_VALUE;
                    respuesta.tiempo = GetSecs;
                    return;
                end
            end
        end
        
        WaitSecs(0.001);
    end
end