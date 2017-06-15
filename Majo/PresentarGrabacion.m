function [exit, grabacion] = PresentarGrabacion(hd, texto, tiempos, recObj)
      
    global TAMANIO_TEXTO triggerlevel

    exit = false;
    
    grabacion.id_hablo = [];
    
    grabacion.frecuencia = recObj.SampleRate;
    
    TextoCentrado(texto, TAMANIO_TEXTO ,hd);    
    [~, grabacion.inicio_t] = Screen('Flip', hd.window);  
    id_start = recObj.TotalSamples;
    
    id_inicio = id_start;
    seguir_grabando = true;
    continuar = true;
    while continuar

        canal = recObj.getaudiodata;
        id_final = length(canal);
        canal = canal(id_inicio:id_final);

        idx = find(abs(canal) >= triggerlevel, 1 );

        if ~isempty(idx)
            grabacion.id_hablo = idx + id_inicio - 1 - id_start;
            continuar = false;        
        end
        
        id_inicio = id_final;

        if GetSecs - grabacion.inicio_t >= tiempos.duracion_grabacion
            seguir_grabando = false;
            continuar = false;
        end
    end
    

    %% TERMINA DE GRABAR
    while seguir_grabando
        if GetSecs - grabacion.inicio_t + tiempos.duracion_silencio >= tiempos.duracion_grabacion
            WaitSecs(tiempos.duracion_grabacion - (GetSecs - grabacion.inicio_t));
        else
            WaitSecs(tiempos.duracion_silencio);
        end
            
        canal = recObj.getaudiodata;
        id_final = length(canal);
        canal = canal(id_inicio:id_final);

        idx = find(abs(canal) >= triggerlevel, 1 );

        id_inicio = id_final;
        
        if isempty(idx) || GetSecs - grabacion.inicio_t >= tiempos.duracion_grabacion
            seguir_grabando = false;
        end
    end

    recObj.pause;
    
    canal = recObj.getaudiodata;
    grabacion.canal = canal(id_start:end);
    grabacion.tiempo = (1:length(grabacion.canal))./recObj.SampleRate;
    if ~isempty(grabacion.id_hablo)
        grabacion.hablo_t = (grabacion.id_hablo/recObj.SampleRate);    
    end
end