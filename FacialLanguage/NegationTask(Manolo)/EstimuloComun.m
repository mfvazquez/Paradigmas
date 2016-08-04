function [exit, respuesta] = EstimuloComun(texto, TIEMPO, botones)
        
    global hd
    global TEXT_SIZE_STIM
    global ExitKey
        
    TextoCentrado(texto, TEXT_SIZE_STIM);
    Screen('Flip', hd.window);
    
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