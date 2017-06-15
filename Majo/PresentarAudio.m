function log = PresentarAudio(hd, audio)

    Screen('Flip', hd.window);    

    PsychPortAudio('FillBuffer', hd.pahandle, audio.canal');    % Fill the audio playback buffer with the audio data 'wavedata':
    log.start = PsychPortAudio('Start', hd.pahandle);
    status = PsychPortAudio('GetStatus',hd.pahandle);  % Me fijo si esta reproduciendo
    
    while status.Active
        status = PsychPortAudio('GetStatus',hd.pahandle);
    end
    
    log.end = GetSecs;
    
    PsychPortAudio('DeleteBuffer');
    
end