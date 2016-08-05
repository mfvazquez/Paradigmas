% Espera hasta que transcurra un tiempo o hasta que se apriete uno de los
% botones.
% % % function [exit, respuesta] = Esperar(tiempo, botonSalida, botones, marca)
function [exit, respuesta] = Esperar(tiempo, botonSalida, botones)

% % % % %     global MARCAS
% % % % %     global pportobj pportaddr

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
                    respuesta.valor = botones{i}.STR;
                    respuesta.tiempo = GetSecs;
% % % % %                         if ~isempty(marca)
% % % % %                             io32(pportobj,pportaddr, marca);
% % % % %                             WaitSecs(MARCAS.DURACION);
% % % % %                             io32(pportobj,pportaddr,0);
% % % % %                         end 
                    
                    return;
                end
            end
        end
    end
end