function grabacion = PresentarGrabacion(grabador, tiempos, teclas)
      
    global freq
    
    tstart = GetSecs;
    [~, respuesta, tiempo_respuesta] = Esperar(tiempos.duracion_grabacion, teclas.salir, {teclas.grabar}, []);
    if isempty(respuesta)
        grabacion = [];
    end

    PsychPortAudio('Start', grabador);
        
    WaitSecs(tiempos.duracion_grabacion);
    [audiodata, ~]= PsychPortAudio('GetAudioData', grabador);
    PsychPortAudio('Stop', grabador);
    
    grabacion.audio = audiodata;
    grabacion.id_hablo = 1;
    grabacion.inicio_t = tstart;
    grabacion.hablo_t = tiempo_respuesta;
    grabacion.freq = freq;

end