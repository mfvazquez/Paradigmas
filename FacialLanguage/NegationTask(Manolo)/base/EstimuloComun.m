function [exit, respuesta, log] = EstimuloComun(texto, TIEMPO, botones, log)
        
    global hd
    global TEXT_SIZE_STIM
    global ExitKey
        
    TextoCentrado(texto, TEXT_SIZE_STIM);
    [~, OnSetTime] = Screen('Flip', hd.window);
    log = OnSetTime;
    
    respuesta.valor = '';
    respuesta.tiempo = NaN;
    
    if ~isempty(botones)
        [exit, respuesta] = Esperar(TIEMPO, ExitKey, botones);
    else
        [exit, respuesta] = Esperar(TIEMPO, ExitKey, []);
    end
    if exit
        return
    end

end