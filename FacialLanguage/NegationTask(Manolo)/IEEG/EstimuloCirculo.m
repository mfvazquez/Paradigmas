function [exit, respuesta, log] = EstimuloCirculo(texto, TIEMPOS, amarillo, log, entrenamiento)
    
    global hd
    global DOT
    global TEXT_SIZE_STIM
    global ExitKey
    global BLINK_DURATION
    
    dot_pos = zeros(1,4);
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    dot_size = round(DOT.SIZE*screenYpixels);    
    dot_pos(1) = round(screenXpixels*DOT.POS(1) - dot_size/2);
    dot_pos(2) = round(screenYpixels*DOT.POS(2) - dot_size/2);
    dot_pos(3) = dot_pos(1) + round(DOT.SIZE*screenYpixels);
    dot_pos(4) = dot_pos(2) + round(DOT.SIZE*screenYpixels);
    
    respuesta.valor = '';
    respuesta.tiempo = NaN;
    
    for i = 1:length(TIEMPOS)
        
        TextoCentrado(texto, TEXT_SIZE_STIM);
        if i == DOT.STIM(2)
            if amarillo
                Screen(hd.window,'FillOval',DOT.AMARILLO, dot_pos);
            else
                Screen(hd.window,'FillOval',DOT.AZUL, dot_pos);
            end
        end
        
        if entrenamiento
            [~, OnSetTime] = Screen('Flip', hd.window);
        else
            OnSetTime = blink;
        end
        log{i} = OnSetTime;
        
        if i >= DOT.STIM(2) && amarillo && isempty(respuesta.valor)
            [exit, respuesta] = Esperar(TIEMPOS{i}, ExitKey, {DOT});
            if ~isempty(respuesta.valor) && ~entrenamiento
                respuesta.tiempo = blink;
                WaitSecs(BLINK_DURATION*2); %% pantalla en negro despues del blink, multiplico por 2 para incluir al blink en esa duracion
            end
        else
            [exit, ~] = Esperar(TIEMPOS{i}, ExitKey, []);
        end
            
        if exit
            return;
        end

    end    
end