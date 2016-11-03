function [log, exit] = CorrerSecuenciaIntero(bloque, teclas, hd)

    global TAMANIO_INSTRUCCIONES
    exit = false;
    log = [];
    
    TextoCentrado(bloque.instrucciones, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    KbStrokeWait;
    
    TextoCentrado('+', TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    
    
    indice = 0; % indice para contar la cantidad de 'z' apretadas
    
    status.Active = 1;
    inicio = GetSecs;
    if ~isempty(bloque.audio)
        
        audiodevices = PsychPortAudio('GetDevices');
        hd.pahandle = PsychPortAudio('Open',audiodevices(1,3).DeviceIndex,[],1,bloque.freq,1);
        PsychPortAudio('Volume', hd.pahandle , 10);
        
        PsychPortAudio('FillBuffer', hd.pahandle, bloque.audio');    % Fill the audio playback buffer with the audio data 'wavedata':
        inicio = PsychPortAudio('Start', hd.pahandle, 1, 0, 1);
        status = PsychPortAudio('GetStatus',hd.pahandle);  % Me fijo si esta reproduciendo
    end
    log.inicio_audio = inicio;
    
    while status.Active == 1 && exit == false                         

        [KeyIsDown,secs,KeyCode] = KbCheck;

        if KeyCode(teclas.LatidosKey)  % apretó la 'z'

            log_trial.response = secs;
            if indice == 0
                log_trial.relative = 0;
            else    
                log_trial.relative = secs - log.estimulos(1).response;
            end
            
            while KeyIsDown == 1  %Espero que suelte la tecla
                 [KeyIsDown,~,~] = KbCheck;
            end

            indice=indice+1;
            log.estimulos(indice) = log_trial;

        elseif KeyCode(teclas.ExitKey)

            exit = true;             %Salgo del Loop  

        end
    
       if ~isempty(bloque.audio)
            status = PsychPortAudio('GetStatus', hd.pahandle); % Me fijo si esta reproduciendo   
       else
           if GetSecs-inicio < 120
               status.Active = 1;
           else
               status.Active = 0;
           end
       end
        
       
    end    
    if ~isempty(bloque.audio)
        PsychPortAudio('Stop',hd.pahandle);
    end
    log.indice = indice;

end