function [exit, log] = Respuesta(textos_opciones)

%     global escKey;
%     global rightKey;
%     global leftKey;
%     global downKey;
    
    global hd;
    
    exit = false;

    elegido = 5;
    PruebaDibujarOpciones(elegido, textos_opciones);
    [asd, OnSetTime] = Screen('Flip', hd.window);
    log.respuesta_inicio = OnSetTime;
    log.primer_movimiento = -1;
    continuar = true;
    while continuar

        [asd, keyCode, asdasd] = KbPressWait;
        
        if (log.primer_movimiento == -1)
           log.primer_movimiento = GetSecs; 
        end
        
        if keyCode(rightKey) && elegido < 9
            elegido = elegido + 1;
            dibujarOpciones(elegido, textos_opciones);
            Screen('Flip', hd.window);
        elseif keyCode(leftKey) && elegido > 1
            elegido = elegido - 1;
            dibujarOpciones(elegido, textos_opciones);
            Screen('Flip', hd.window);
        elseif keyCode(downKey)
            log.respuesta_fin = GetSecs;
            continuar = false;
            log.respuesta = elegido;
        elseif keyCode(escKey)
            continuar = false;
            exit = true;
        end

    end
    
end