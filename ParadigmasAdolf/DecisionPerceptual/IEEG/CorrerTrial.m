function [exit, log_trial] = CorrerTrial(figura, texturas, botones, respuestas, habilitar_blinks)

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
    
    if habilitar_blinks
        OnSetTime = blink;
    else
        [~, OnSetTime] = Screen('Flip', hd.window);
    end
    DibujarTexturas(texturas.flecha);
    
    [exit, respuesta, momento] = Esperar(0.5, ExitKey, botones);
    if respuesta ~= 0 && habilitar_blinks
        momento = blink;
    end
    log_trial.objeto_on = OnSetTime;
   
    if exit
        return;
    end
    
    %% RESPONSE BLANK
    log_trial.objeto_off = 0;
    if respuesta == 0
%         DibujarTexturas(texturas.flecha);
        [~, OnSetTime] = Screen('Flip', hd.window, [], 1);
        [exit, respuesta, momento] = Esperar(1, ExitKey, botones);
        if respuesta ~= 0 && habilitar_blinks
            momento = blink;
        end
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