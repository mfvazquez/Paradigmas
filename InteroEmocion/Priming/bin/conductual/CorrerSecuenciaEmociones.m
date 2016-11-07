function [log, exit] = CorrerSecuenciaEmociones(texturas, codigos, instrucciones, hd, teclas, log, botones_salteado)

    ExitKey = teclas.ExitKey;
    AfirmativeKey = teclas.afirmativo;
    NegativeKey = teclas.negativo;
    
    botones = {AfirmativeKey NegativeKey};
    botones_salteado = teclas.botones_salteado;
    
    global TAMANIO_TEXTO
    global TAMANIO_INSTRUCCIONES
    
    %% INSTRUCCIONES
    TextoCentrado(instrucciones, TAMANIO_INSTRUCCIONES, hd);
    Screen('Flip', hd.window);
    KbStrokeWait;
    
    %% FIJACION
    TextoCentrado('+', TAMANIO_TEXTO, hd);
    Screen('Flip', hd.window);
    [exit, ~, ~, saltear_bloque] = Esperar(0.2, ExitKey, {}, botones_salteado);
    if exit || saltear_bloque
        return;
    end

    %% VACIO
    Screen('Flip', hd.window);
    WaitSecs(0.8);
          
    for i = 1:length(texturas)
        
        %% IMAGEN
        DibujarTextura(texturas{i}, hd.window);  
        [~, OnSetTime] = Screen('Flip', hd.window);
        
        log_trial.imagen = OnSetTime;
        [exit, respuesta, tiempo, saltear_bloque] = Esperar(1.5, ExitKey, botones, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        
        if isempty(respuesta)
            %% BLANK
            [~, OnSetTime] = Screen('Flip', hd.window);
            log_trial.blank = OnSetTime;
            [exit, respuesta, tiempo, saltear_bloque] = Esperar(1.5, ExitKey, botones, botones_salteado);
            if exit || saltear_bloque
                return;
            end
        end
        
        if respuesta == 1
            log_trial.respuesta = 'si';
        elseif respuesta == 2
            log_trial.respuesta = 'no';
        end
        
        if ~isempty(codigos)
            log_trial.codigo = codigos{i};
            respuesta_correcta = 1;
            if codigos{i}(1) == 'N'
                respuesta_correcta = 2;
            end

            if respuesta_correcta == respuesta
                log_trial.accuracy = 1;
            else
                log_trial.accuracy = 0;
            end
        end
        
        log_trial.respuesta_tiempo = tiempo;
        
        
        
        %% OFFSET
        [~, OnSetTime] = Screen('Flip', hd.window);
        duracion = rand*0.4+0.8;
        
        log_trial.offset_time = OnSetTime;
        log_trial.offset_duracion = duracion;
        [exit, ~, ~, saltear_bloque] = Esperar(duracion, ExitKey, {}, botones_salteado);
        if exit || saltear_bloque
            return;
        end
        
        if ~isempty(log)
            log{i} = log_trial;
        end

    end
    

end