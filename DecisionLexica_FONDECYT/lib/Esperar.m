% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, respuesta, tiempo_respuesta, saltear_bloque] = Esperar(tiempo, boton_salida, botones, boton_pausa)    
    exit = false;
    tStart = GetSecs;
    respuesta = [];
    tiempo_respuesta = [];
    saltear_bloque = false;    
    while GetSecs - tStart < tiempo
        [~, ~, keyCode, ~] = KbCheck;
        
        if keyCode(boton_salida)
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
        end
        
        if ~isempty(boton_pausa.inicio) && keyCode(boton_pausa.inicio)                  
            exit = EsperarPausa(boton_pausa.fin, boton_salida);              
        end
        
    end
end