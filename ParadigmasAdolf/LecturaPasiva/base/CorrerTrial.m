function [exit, log_trial] = CorrerTrial(palabra, auxiliar, botones, respuestas, pregunta)

    global hd
    global SEPARACION_PALABRAS
	global TAMANIO_TEXTO
    global ExitKey
    global TAMANIO_TEXTO_PREGUNTA

  %% RESPONSE VERBO
    EscribirPalabras(auxiliar, palabra, TAMANIO_TEXTO, SEPARACION_PALABRAS);
    [~, OnSetTime] = Screen('Flip', hd.window);
    [exit, ~, ~] = Esperar(0.5, ExitKey, {});
    log_trial.verbo_on = OnSetTime;
   
    if exit
        return;
    end
    
    
    %% OFFSET PRIMERO
    EscribirPalabras(auxiliar, '', TAMANIO_TEXTO, SEPARACION_PALABRAS);
    [~, OnSetTime] = Screen('Flip', hd.window);
    duracion = rand*0.2+0.3;
    [exit, ~, ~] = Esperar(duracion, ExitKey, {});
    log_trial.offset_primero = OnSetTime;
    log_trial.offset_primero_duracion = duracion;
    
    if exit
        return;
    end
    
    %% PREGUNTA
    log_trial.respuesta = 0;
    if nargin == 5
        TextoCentrado(pregunta, TAMANIO_TEXTO_PREGUNTA);
        [~, OnSetTime] = Screen('Flip', hd.window);
        log_trial.pregunta = OnSetTime;
        [exit, respuesta, momento] = Esperar(5, ExitKey, botones);
        if respuesta == 0
            [~, OnSetTime] = Screen('Flip', hd.window);
            log_trial.pregunta_blank = OnSetTime;
            [exit, respuesta, momento] = Esperar(0.5, ExitKey, botones);
        end
        
        if respuesta ~= 0
            log_trial.respuesta = respuestas{respuesta};
            log_trial.respuesta_momento = momento;
            log_trial.respuesta_demora = momento - log_trial.pregunta;
        end
        
        if exit
            return
        end
        
        %% OFFSET SEGUNDO
        EscribirPalabras(auxiliar, '', TAMANIO_TEXTO, SEPARACION_PALABRAS);
        [~, OnSetTime] = Screen('Flip', hd.window);
        duracion = rand*0.2+0.3;
        [exit, ~, ~] = Esperar(duracion, ExitKey, {});
        log_trial.offset_segundo = OnSetTime;
        log_trial.offset_segundo_duracion = duracion;

    end
    
end