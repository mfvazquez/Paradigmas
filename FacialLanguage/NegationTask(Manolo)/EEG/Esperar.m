% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, respuesta] = Esperar(tiempo, botonSalida, botones, marca)

    exit = false;
    tStart = GetSecs;
    respuesta.valor = '';
    respuesta.tiempo = NaN;
    respuesta.botones = botones;
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
                        if ~isempty(marca)
                            EnviarMarca(marca);
                        end 
                    
                    return;
                end
            end
        end
    end
end