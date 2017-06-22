% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
function [exit, respuesta, tiempo_respuesta] = Esperar(tiempo, boton_salida, botones, boton_pausa)    
    exit = false;
    tStart = GetSecs;
    respuesta = [];
    tiempo_respuesta = [];
    duracion_pausa = 0;
    while (GetSecs - duracion_pausa) - tStart < tiempo
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
            tiempo_pausa_inicio = GetSecs;
            exit = EsperarPausa(boton_pausa.fin, boton_salida);
            duracion_pausa = duracion_pausa + GetSecs - tiempo_pausa_inicio;
            display(duracion_pausa)
        end
        
    end
end