function log = PresentarAudio(reproductor, audio)

    PsychPortAudio('FillBuffer', reproductor, [audio.canal'; audio.canal']);    % Fill the audio playback buffer with the audio data 'wavedata':
    log.start = PsychPortAudio('Start', reproductor, [] ,[], 1, [] ,[]);
    status = PsychPortAudio('GetStatus',reproductor);  % Me fijo si esta reproduciendo
    
    while status.Active
        status = PsychPortAudio('GetStatus',reproductor);
    end
    
    log.end = GetSecs;
    
    PsychPortAudio('DeleteBuffer');
    PsychPortAudio('Stop', reproductor);
    
end