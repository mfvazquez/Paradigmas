function [exit, log_trial] = CorrerTrial(figura, texturas, botones, respuestas)

    global hd
    global ExitKey
    
    log_trial.respuesta = 0;
    log_trial.respuesta_momento = 0;

  %% RESPONSE OBJETO
    
    if strcmp(figura, 'Rect')
        DibujarTexturas(texturas.flecha, texturas.rect);
    elseif strcmp(figura, 'Tri');
        DibujarTexturas(texturas.flecha, texturas.tri);
    end
        
    [~, OnSetTime] = Screen('Flip', hd.window);
    [exit, respuesta, momento] = Esperar(0.5, ExitKey, botones);
    log_trial.objeto_on = OnSetTime;
   
    if exit
        return;
    end
    
    %% RESPONSE BLANK
    log_trial.objeto_off = 0;
    if respuesta == 0
        DibujarTexturas(texturas.flecha);
        [~, OnSetTime] = Screen('Flip', hd.window);
        [exit, respuesta, momento] = Esperar(1, ExitKey, botones);
        log_trial.objeto_off = OnSetTime;
        if exit
            return;
        end
    end

    if respuesta ~= 0
        log_trial.respuesta = respuestas{respuesta};
        log_trial.respuesta_momento = momento;
        log_trial.respuesta_demora = momento - log_trial.objeto_on;
    end
    
    %% OFFSET
    DibujarTexturas(texturas.flecha);
    [~, OnSetTime] = Screen('Flip', hd.window);
    duracion = rand*0.2+0.3;
    [exit, ~, ~] = Esperar(duracion, ExitKey, {});
    log_trial.offset = OnSetTime;
    log_trial.offset_duracion = duracion;
    
    if exit
        return;
    end
    
end