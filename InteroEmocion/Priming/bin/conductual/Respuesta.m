function [exit, log] = Respuesta(textos_opciones, teclas, hd)

    exit = false;

    elegido = 5;
    dibujarOpciones(elegido, textos_opciones, true);
    [~, OnSetTime] = Screen('Flip', hd.window);
    log.respuesta_inicio = OnSetTime;
    log.primer_movimiento = -1;
    continuar = true;
    while continuar
    
        [~, keyCode, ~] = KbPressWait;
        
        if (log.primer_movimiento == -1)
           log.primer_movimiento = GetSecs; 
        end
        
        if keyCode(teclas.RighteKey) && elegido < 9
            elegido = elegido + 1;
            dibujarOpciones(elegido, textos_opciones, true);
            Screen('Flip', hd.window);
        elseif keyCode(teclas.LeftKey) && elegido > 1
            elegido = elegido - 1;
            dibujarOpciones(elegido, textos_opciones, true);
            Screen('Flip', hd.window);
        elseif keyCode(teclas.EnterKey)
            log.respuesta_fin = GetSecs;
            continuar = false;
            log.respuesta = elegido;
        elseif keyCode(teclas.ExitKey)
            continuar = false;
            exit = true;
        end

    end
    
end