function [exit, respuesta, log] = EstimuloComun(texto, TIEMPO, botones, log, entrenamiento)
        
    global hd
    global TEXT_SIZE_STIM
    global ExitKey
    global BLINK_DURATION
    
    TextoCentrado(texto, TEXT_SIZE_STIM);
    if entrenamiento
        [~, OnSetTime] = Screen('Flip', hd.window);
    else
        OnSetTime = blink;
    end
    log = OnSetTime;
    
    respuesta.valor = '';
    respuesta.tiempo = NaN;
    
    [exit, respuesta] = Esperar(TIEMPO, ExitKey, botones);
    if ~isempty(respuesta.valor) && ~entrenamiento
        respuesta.tiempo = blink;
        WaitSecs(BLINK_DURATION*2); %% pantalla en negro despues del blink, multiplico por 2 para incluir al blink en esa duracion
    end
    if exit
        return
    end

end