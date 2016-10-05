%Chequeo continuidad

    KeyCode(13) = 0;
    KeyCode(80) = 0;
    continuidad  = 0;
    
    while continuidad == 0                          % Se queda en este loop hasta que presione Enter;
        [KeyIsDown,secs,KeyCode] = KbCheck;
        WaitSecs(0.001);
        if KeyCode(80) == 1  % Salgo del programa con la letra p
            
            PsychPortAudio('Close',hd.pahandle);
            PsychPortAudio('Close',hd.pahandle2);
            Screen('CloseAll'); % Cierro ventana del Psychtoolbox
            fclose(log_txt);
            
        elseif KeyCode(13) == 1
            continuidad=1;
        end
    end


