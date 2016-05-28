function [exit, log] = CorrerBloque(instrucciones, bloque, botones, log)

    global hd;
   
    exit = false;
    
    experimental = true;
    if isempty(log)
        experimental = false;
    end
    
    %% ------------------ INSTRUCCIONES --------------------------------------

    textoCentrado(instrucciones, 0.04);
    Screen('Flip',hd.window);
    KbPressWait;
    
    %% ------------------- INICIO DEL BLOQUE -----------------------
    
    log.inicio = GetSecs;
    for i = 1:length(bloque.palabra)
        %% ----------------- FIJACION -------------------------------
        
        duracion = randi([700 1000], 1)/1000;
        textoCentrado('+', 0.05);
        [~, OnSetTime] = Screen('Flip',hd.window);
        if experimental
            log.fijacion_time{1,i} = OnSetTime;
        end
        WaitSecs(duracion);

        %% ----------------- PALABRA ------------

        textoCentrado(bloque.palabra{i}, 0.05);
        [~, OnSetTime] = Screen('Flip',hd.window);
        if experimental
            log.stim_time{i} = OnSetTime;
        end
        WaitSecs(0.3);

        %% ----------------- RESPUESTA ----------
        
        continuar = true;
        [~, tstart] = Screen('Flip',hd.window);
        while (GetSecs - tstart < 2 && continuar)
            
            [~, ~, keyCode] = KbCheck;
            if keyCode(botones.Si)
                continuar = false;
                if experimental
                    log.resp_time{i} = GetSecs;
                    log.reaction_time{i} = log.resp_time{i} - log.stim_time{i}; 

                    if strcmp(bloque.categoria{i}, '-')
                        log.accuracy{i} = 0;
                    else
                        log.accuracy{i} = 1;
                    end
                end    
            elseif keyCode(botones.No)
                continuar = false;
                if experimental
                    log.resp_time{i} = GetSecs;
                    log.reaction_time{i} = log.resp_time{i} - log.stim_time{i}; 

                    if strcmp(bloque.categoria{i}, '-')
                        log.accuracy{i} = 1;
                    else
                        log.accuracy{i} = 0;
                    end
                end
            elseif keyCode(botones.Salir)
                continuar = false;
                exit = true;
                log.fin = GetSecs;
                return
            end
            
        end
        
        %% ------------- ESPERA ---------------------------------------
        duracion = randi([700 1000], 1)/1000;
        WaitSecs(duracion);
        
    end
    log.fin = GetSecs;
        
end