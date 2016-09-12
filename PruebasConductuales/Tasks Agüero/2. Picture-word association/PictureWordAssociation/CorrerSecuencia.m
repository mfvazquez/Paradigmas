function exit = CorrerSecuencia(texturas)

    global hd
    global TAMANIO_TEXTO
    global ExitKey
    global AfirmativeKey
    global NegativeKey
    
    botones = {AfirmativeKey NegativeKey};
          
    for i = 1:length(texturas)
    
        %% FIJACION
        TextoCentrado('+', TAMANIO_TEXTO);
        WaitSecs(0.3);        
        
        %% IMAGEN
        DibujarTextura(texturas{i});
        Screen('Flip', hd.window);
        [exit, respuesta, tiempo] = Esperar(2, ExitKey, botones);
        if exit
            return;
        end
        
        
        if respuesta == 0
            %% BLANK
            Screen('Flip', hd.window);
            [exit, respuesta, tiempo] = Esperar(0.5, ExitKey, botones);
            if exit
                return;
            end
        end        
        
        %% OFFSET
        [~, OnSetTime] = Screen('Flip', hd.window);
        duracion = rand*0.2+0.3;
        [exit, ~, ~] = Esperar(duracion, ExitKey, {});
        
    end
    

end