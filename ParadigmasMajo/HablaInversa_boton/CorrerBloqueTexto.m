function [exit, log] = CorrerBloqueTexto(hd, estimulos, datos, teclas, log)

    global freq TAMANIO_TEXTO
    
    rec = PsychPortAudio('Open', hd.audiodevice, 2, 1, freq, 1);
    PsychPortAudio('GetAudioData', rec, 10);

    for x = 1:length(estimulos)

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
        TextoCentrado('&', TAMANIO_TEXTO ,hd);    
        Screen('Flip', hd.window);    
        log_actual.grabacion = PresentarGrabacion(rec, datos, teclas);
        
        %% FIN DEL TRIAL
        log{x} = log_actual;
        
        if exit
            break
        end
        
    end
    
    PsychPortAudio('Close', rec);

end