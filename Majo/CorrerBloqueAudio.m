function [exit, log] = CorrerBloqueAudio(hd, estimulos, datos, teclas, log)

    
    hd.pahandle = PsychPortAudio('Open', [], 1, 1, estimulos{1}.freq, 1);
    PsychPortAudio('Volume', hd.pahandle , 10);

    for x = 1:length(estimulos)
        
        recObj = audiorecorder(22050, 16, 1);
        recObj.record;
        
        %% FIJACION
        [exit, log_actual.fijacion] = PresentarTexto(hd, teclas, '+', 0.3);
        if exit
            break
        end
        
        
        %% AUDIO
        log_actual.audio = PresentarAudio(hd, estimulos{x});
        
        
        %% GRABACION        
        [exit, log_actual.grabacion] = PresentarGrabacion(hd, '', datos, recObj);
        
        
        %% FIN DEL TRIAL
        recObj.delete;        
        log{x} = log_actual;
        
        if exit
            break
        end
        
    end
end