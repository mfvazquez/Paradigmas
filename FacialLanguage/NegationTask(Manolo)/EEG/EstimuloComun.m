function [exit, respuesta, log] = EstimuloComun(texto, TIEMPO, botones, marca, entrenamiento)
        
    global hd
    global TEXT_SIZE_STIM
    global ExitKey
    global MARCAS
    
    TextoCentrado(texto, TEXT_SIZE_STIM);
    [~, OnSetTime] = Screen('Flip', hd.window);
    log = OnSetTime;
    if ~entrenamiento
        EnviarMarca(marca);
    end 
    
    respuesta.valor = '';
    respuesta.tiempo = NaN;
    
    if ~isempty(botones)
        if ~entrenamiento
            [exit, respuesta] = Esperar(TIEMPO, ExitKey, botones, MARCAS.AMARILLO);
        else
            [exit, respuesta] = Esperar(TIEMPO, ExitKey, botones, []);
        end
    else
        [exit, respuesta] = Esperar(TIEMPO, ExitKey, [], []);
    end
    if exit
        return
    end

end