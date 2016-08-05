function [exit, respuesta, log] = EstimuloCirculo(texto, TIEMPOS, amarillo, log, marcas, entrenamiento)
    
    global hd
    global DOT
    global TEXT_SIZE_STIM
    global ExitKey
    global MARCAS
    global pportobj pportaddr
    
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
        
        [~, OnSetTime] = Screen('Flip', hd.window);
        log{i} = OnSetTime;
        if ~entrenamiento
            io32(pportobj,pportaddr, marcas{i});
            WaitSecs(MARCAS.DURACION);
            io32(pportobj,pportaddr,0);
        end 
        if i >= DOT.STIM(2) && amarillo && isempty(respuesta.valor)
            if ~entrenamiento
                [exit, respuesta] = Esperar(TIEMPOS{i}, ExitKey, {DOT}, MARCAS.AMARILLO);
            else
                [exit, respuesta] = Esperar(TIEMPOS{i}, ExitKey, {DOT}, []);
            end
        else
            [exit, ~] = Esperar(TIEMPOS{i}, ExitKey, [], []);
        end
            
        if exit
            return;
        end

    end    
end