function [log, exit, saltear] = ElegirOpcionVertical(hd, opciones, titulo, teclas, tiempo)

    elegido = floor((length(opciones) + 1)/2);
    exit = false;
    saltear = false;
    
    DibujarOpcionesVertical(elegido, opciones, titulo, hd);
    [~, tstart] = Screen('Flip',hd.window);
    
    log.opciones_inicio = tstart;
    
    [~, anteriores, ~] = KbCheck;
    continuar = true;
    while GetSecs - tstart <= tiempo && continuar
        
        [keyCode, anteriores] = KbCheckNewPush(anteriores);
        
        if keyCode(teclas.EnterKey)
            log.respuesta_fin = GetSecs;
            continuar = false;
            log.respuesta = opciones{elegido};
        elseif keyCode(teclas.UpKey) && elegido > 1
            elegido = elegido - 1;
            DibujarOpcionesVertical(elegido, opciones, titulo, hd);
            Screen('Flip', hd.window);
        elseif keyCode(teclas.DownKey) && elegido < length(opciones)
            elegido = elegido + 1;
            DibujarOpcionesVertical(elegido, opciones, titulo, hd);
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