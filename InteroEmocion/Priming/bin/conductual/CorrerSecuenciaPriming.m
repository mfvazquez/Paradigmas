function [log, exit] = CorrerSecuenciaPriming(texturas, instrucciones, hd, teclas, log)

    ExitKey = teclas.exit;
    AfirmativeKey = teclas.afirmativo;
    NegativeKey = teclas.negativo;
    
    botones = {AfirmativeKey NegativeKey};
    
    global TAMANIO_TEXTO
    global TAMANIO_INSTRUCCIONES
    
    %% INSTRUCCIONES
    TextoCentrado(instrucciones, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    KbStrokeWait;
    
    %% FIJACION
    TextoCentrado('+', TAMANIO_TEXTO, hd);
    Screen('Flip', hd.window);
    WaitSecs(0.2);        

    %% VACIO
    Screen('Flip', hd.window);
    WaitSecs(0.8);
          
    for i = 1:length(texturas)
        
        %% IMAGEN
        DibujarTextura(texturas{i}, hd.window);  
        [~, OnSetTime] = Screen('Flip', hd.window);
        
        log_trial.imagen = OnSetTime;
        [exit, respuesta, tiempo] = Esperar(1.5, ExitKey, botones);
        if exit
            return;
        end
        
        
        if isempty(respuesta)
            %% BLANK
            [~, OnSetTime] = Screen('Flip', hd.window);
            log_trial.blank = OnSetTime;
            [exit, respuesta, tiempo] = Esperar(1.5, ExitKey, botones);
            if exit
                return;
            end
        end
        
        log_trial.respuesta = respuesta;
        log_trial.respuesta_tiempo = tiempo;
        
        %% OFFSET
        [~, OnSetTime] = Screen('Flip', hd.window);
        duracion = rand*0.4+0.8;
        
        log_trial.offset_time = OnSetTime;
        log_trial.offset_duracion = duracion;
        [exit, ~, ~] = Esperar(duracion, ExitKey, {});
        
        if ~isempty(log)
            log{i} = log_trial;
        end

    end
    

end