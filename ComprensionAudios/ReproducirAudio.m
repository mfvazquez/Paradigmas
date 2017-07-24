function [log, exit] = ReproducirAudio(hd, audio, freq, exitKey, log)

    reproductor = PsychPortAudio('Open', hd.audiodevice, 1, 1, freq, 2);
    PsychPortAudio('Volume', reproductor , 5);
    PsychPortAudio('FillBuffer', reproductor, audio');    
    
    PsychPortAudio('Start', reproductor, 1, 0, 1);
    log.inicio = blink;
    status = PsychPortAudio('GetStatus',reproductor);  % Me fijo si esta reproduciendo    
    while status.Active
        status = PsychPortAudio('GetStatus',reproductor);
        [keyIsDown, ~, keyCode, ~] = KbCheck;
        if keyIsDown && keyCode(exitKey)
            exit = true;
            break
        end
    end
    log.end = blink;
    
    PsychPortAudio('DeleteBuffer');
    
    PsychPortAudio('Stop', reproductor);
    PsychPortAudio('Close', reproductor); 

end