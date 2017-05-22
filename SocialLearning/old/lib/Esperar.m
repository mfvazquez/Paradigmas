% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, respuesta, tiempo_respuesta, saltear_bloque] = Esperar(tiempo, boton_salida, botones, botones_salteado, boton_pausa)    
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
        
        if ~isempty(botones_salteado)
            saltear_bloque = BotonesApretados(keyCode, botones_salteado);
            if saltear_bloque
                return;
            end
            
        end
        
        if ~isempty(boton_pausa) && keyCode(boton_pausa)                  
            exit = EsperarPausa(boton_pausa, boton_salida);              
        end
        
    end
end