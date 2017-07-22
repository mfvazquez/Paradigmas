function [exit, log, saltear] = Respuesta(textos_opciones, teclas, hd)

    exit = false;
    saltear = false;      
    
    elegido = 5;
    dibujarOpciones(elegido, textos_opciones, true, hd);
    DibujarCuadradoNegro();
    [~, OnSetTime] = Screen('Flip', hd.window);
    log.respuesta_inicio = OnSetTime;
    log.primer_movimiento = -1;
    continuar = true;
    
    KbReleaseWait;
    
    [~, anteriores, ~] = KbCheck;
    
    while continuar
    
        [keyCode, anteriores] = KbCheckNewPush(anteriores);
                
        if (log.primer_movimiento == -1)
           log.primer_movimiento = GetSecs; 
        end
        
        if keyCode(teclas.EnterKey)
            log.respuesta_fin = GetSecs;
            continuar = false;
            log.respuesta = elegido;
        elseif keyCode(teclas.RightKey) && elegido < 9
            elegido = elegido + 1;
            dibujarOpciones(elegido, textos_opciones, true, hd);
            DibujarCuadradoNegro();
            Screen('Flip', hd.window);
        elseif keyCode(teclas.LeftKey) && elegido > 1
            elegido = elegido - 1;
            dibujarOpciones(elegido, textos_opciones, true, hd);
            DibujarCuadradoNegro();
            Screen('Flip', hd.window);
        elseif keyCode(teclas.ExitKey)
            exit = true;
            return;
        elseif BotonesApretados([], teclas.botones_salteado)
            saltear = true;
            return;
        end

        
    end
    
end