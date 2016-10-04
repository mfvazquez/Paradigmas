function [exit, log_trial] = CorrerTrial(palabra, auxiliar, botones, respuestas, habilitar_blinks)

    global hd
    global SEPARACION_PALABRAS
	global TAMANIO_TEXTO
    global ExitKey

    
    log_trial.respuesta = 0;
    log_trial.respuesta_momento = 0;

  %% RESPONSE VERBO
    EscribirPalabras(auxiliar, palabra, TAMANIO_TEXTO, SEPARACION_PALABRAS);

    if habilitar_blinks
        OnSetTime = blink;
    else
        [~, OnSetTime] = Screen('Flip', hd.window);    
    end
    EscribirPalabras(auxiliar, '', TAMANIO_TEXTO, SEPARACION_PALABRAS);
    
    [exit, respuesta, momento] = Esperar(0.5, ExitKey, botones);
    if respuesta ~= 0 && habilitar_blinks
        momento = blink;
    end
    log_trial.verbo_on = OnSetTime;
   
    if exit
        return;
    end
    
    %% RESPONSE BLANK
    log_trial.verbo_off = 0;
    if respuesta == 0
%         EscribirPalabras(auxiliar, '', TAMANIO_TEXTO, SEPARACION_PALABRAS);
        [~, OnSetTime] = Screen('Flip', hd.window, [], 1);
        [exit, respuesta, momento] = Esperar(1, ExitKey, botones);
        if respuesta ~= 0 && habilitar_blinks
            momento = blink;
        end
        log_trial.verbo_off = OnSetTime;
        if exit
            return;
        end
    end
    
    if respuesta ~= 0
        log_trial.respuesta = respuestas{respuesta};
        log_trial.respuesta_momento = momento;
        log_trial.respuesta_demora = momento - log_trial.verbo_on;
    end
    
    %% OFFSET
    EscribirPalabras(auxiliar, '', TAMANIO_TEXTO, SEPARACION_PALABRAS);
    [~, OnSetTime] = Screen('Flip', hd.window);
    duracion = rand*0.2+0.3;
    [exit, ~, ~] = Esperar(duracion, ExitKey, {});
    log_trial.offset = OnSetTime;
    log_trial.offset_duracion = duracion;
    
    if exit
        return;
    end
    
end