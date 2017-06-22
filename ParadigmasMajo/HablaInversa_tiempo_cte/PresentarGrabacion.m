function grabacion = PresentarGrabacion(grabador, tiempos)
      
    global triggerlevel freq

    PsychPortAudio('Start', grabador);
    tstart = GetSecs;
    
    WaitSecs(tiempos.duracion_grabacion);
    [audiodata, ~]= PsychPortAudio('GetAudioData', grabador);
    PsychPortAudio('Stop', grabador);
    
    grabacion.audio = audiodata;
    grabacion.id_hablo = find(abs(audiodata) >= triggerlevel, 1, 'first');
    grabacion.inicio_t = tstart;
    grabacion.hablo_t = grabacion.id_hablo/freq;
    grabacion.freq = freq;

end