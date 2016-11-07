function [log, exit] = CorrerSecuenciaIntero(bloque, teclas, hd, tiempo_limite)

    global TAMANIO_INSTRUCCIONES
    exit = false;
    log = [];
    
    
    for x = 1:length(bloque.instrucciones)
        TextoCentrado(bloque.instrucciones{x}, TAMANIO_INSTRUCCIONES, hd);
        Screen('Flip', hd.window);
        KbStrokeWait;
    end
        
    TextoCentrado('+', TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    
    
    indice = 0; % indice para contar la cantidad de 'z' apretadas
    
    status.Active = 1;
    inicio = GetSecs;
    if ~isempty(bloque.audio)
        
        audiodevices = PsychPortAudio('GetDevices');
        num_dispositivo = BuscarDeviceOutput(audiodevices)
        hd.pahandle = PsychPortAudio('Open',audiodevices(num_dispositivo).DeviceIndex,[],1,bloque.freq,1);
        PsychPortAudio('Volume', hd.pahandle , 10);
        
        PsychPortAudio('FillBuffer', hd.pahandle, bloque.audio');    % Fill the audio playback buffer with the audio data 'wavedata':
        PsychPortAudio('Start', hd.pahandle, 1, 0, 1);
        status = PsychPortAudio('GetStatus',hd.pahandle);  % Me fijo si esta reproduciendo
    end
    log.inicio = inicio;

    while status.Active == 1 && exit == false                       

        [KeyIsDown,secs,KeyCode] = KbCheck;

        if KeyCode(teclas.LatidosKey)  % apretó la 'z'

            log_trial.response = secs;
            log_trial.relative = secs - inicio;

            
            while KeyIsDown == 1  %Espero que suelte la tecla
                 [KeyIsDown,~,~] = KbCheck;
            end

            indice=indice+1;
            log.estimulos(indice) = log_trial;

        elseif KeyCode(teclas.ExitKey)
            exit = true;             %Salgo del Loop  
            break;

        elseif BotonesApretados(KeyCode, teclas.botones_salteado)
            break;            
        end
    
       if ~isempty(bloque.audio)
            status = PsychPortAudio('GetStatus', hd.pahandle); % Me fijo si esta reproduciendo   
       else
           if GetSecs-inicio < tiempo_limite
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