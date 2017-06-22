function grabacion = PresentarGrabacion(grabador, tiempos)
      
    global triggerlevel freq

    PsychPortAudio('Start', grabador);
    tstart = GetSecs;
    
    audio = zeros(1, freq*tiempos.duracion_grabacion);
    continuar = true;
    seguir = true;
    id_start = 1;
    while continuar

        WaitSecs(0.01);

        [audiodata, ~]= PsychPortAudio('GetAudioData', grabador);
        audio(id_start:length(audiodata) + id_start - 1) = audiodata;
        id_start = length(audiodata) + id_start;

        if GetSecs - tstart >= tiempos.duracion_grabacion
            continuar = false;
            seguir = false;
        end

        idx = find(abs(audiodata) >= triggerlevel, 1, 'first' );
        if ~isempty(idx)
            continuar = false;
        end
    end


    while seguir
        if GetSecs - tstart + tiempos.duracion_silencio >= tiempos.duracion_grabacion
            WaitSecs(tiempos.duracion_grabacion - (GetSecs - tstart));
        else
            WaitSecs(tiempos.duracion_silencio);
        end

        [audiodata, ~, ~, tCaptureStart]= PsychPortAudio('GetAudioData', grabador);
        audio(id_start:length(audiodata) + id_start - 1) = audiodata;
        id_start = length(audiodata) + id_start;

        if GetSecs - tstart >= tiempos.duracion_grabacion
            seguir = false;
        end

        idx = find(abs(audiodata) >= triggerlevel, 1, 'first' );
        if isempty(idx)
            seguir = false;
        end

    end

    grabacion.audio = audio(1:id_start-1);
    grabacion.id_hablo = find(abs(audio) >= triggerlevel, 1, 'first');
    grabacion.inicio_t = tstart;
    grabacion.hablo_t = grabacion.id_hablo/freq;
    grabacion.freq = freq;

    PsychPortAudio('Stop', grabador);
end