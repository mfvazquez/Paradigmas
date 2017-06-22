function [exit, log] = CorrerBloqueAudio(hd, estimulos, datos, teclas, log)

    global freq

    master = PsychPortAudio('Open', hd.audiodevice, 3+8, 1, freq, 2);
    PsychPortAudio('Start', master, 0, 0, 1);
    reproductor = PsychPortAudio('OpenSlave', master, 1, 2, []);
    rec = PsychPortAudio('OpenSlave', master, 2, 1, []);
    
    PsychPortAudio('GetAudioData', rec, 10); % reservo 10 segundos de grabacion 
    PsychPortAudio('Volume', reproductor , 1);

    for x = 1:length(estimulos)        
        %% FIJACION
        [exit, log_actual.fijacion] = PresentarTexto(hd, teclas, '+', 0.3);
        if exit
            break
        end
        
        
        %% AUDIO  24ms
        Screen('Flip', hd.window);  
        log_actual.audio = PresentarAudio(reproductor, estimulos{x});
        
        
        %% GRABACION   5ms
        log_actual.grabacion = PresentarGrabacion(rec, datos, teclas);        
        log_actual.reaction_time = log_actual.grabacion.hablo_t+log_actual.grabacion.inicio_t-log_actual.audio.end;
        
        
        %% FIN DEL TRIAL     
        log{x} = log_actual;
        
        if exit
            break
        end
        
    end

    PsychPortAudio('Stop', reproductor);
    PsychPortAudio('Stop', master);
    PsychPortAudio('Close', reproductor);    
    PsychPortAudio('Close', rec);
    PsychPortAudio('Close', master);

end