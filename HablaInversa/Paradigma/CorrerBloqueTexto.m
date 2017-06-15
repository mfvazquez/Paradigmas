function [exit, log] = CorrerBloqueTexto(hd, estimulos, datos, teclas, log)

    for x = 1:length(estimulos)

        recObj = audiorecorder(22050, 16, 1);
        recObj.record;
        
        %% FIJACION
        [exit, log_actual.fijacion] = PresentarTexto(hd, teclas, '+', 0.3);
        if exit
            break
        end
        
        
        %% TEXTO
        [exit, log_actual.texto] = PresentarTexto(hd, teclas, estimulos{x}, datos.duracion_texto);
        if exit
            break
        end
        
        %% BLANCO
        [exit, log_actual.blanco] = PresentarTexto(hd, teclas, '', datos.duracion_blanco);
        if exit
            break
        end
        
        
        %% GRABACION        
        [exit, log_actual.grabacion] = PresentarGrabacion(hd, '&', datos, recObj);
        
        %% FIN DEL TRIAL
        recObj.delete;        
        log{x} = log_actual;
        
        if exit
            break
        end
        
    end

end