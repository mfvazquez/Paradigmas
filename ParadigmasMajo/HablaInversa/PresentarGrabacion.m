function grabacion = PresentarGrabacion(grabador, tiempos, teclas)
      
    global triggerlevel freq

    PsychPortAudio('Start', grabador);
    tstart = GetSecs;

    [~, respuesta, ~] = Esperar(tiempos.duracion_grabacion, teclas.salir, {teclas.saltear}, []);    
    [audiodata, ~]= PsychPortAudio('GetAudioData', grabador);
    PsychPortAudio('Stop', grabador);
    
    if ~isempty(respuesta)
        grabacion.audio = [];
        grabacion.id_hablo = [];
        grabacion.inicio_t = [];
        grabacion.hablo_t = [];
        grabacion.freq = [];
        return
    end
    
    grabacion.audio = audiodata;
    grabacion.id_hablo = find(abs(audiodata) >= triggerlevel, 1, 'first');
    grabacion.inicio_t = tstart;
    grabacion.hablo_t = grabacion.id_hablo/freq;
    grabacion.freq = freq;

end