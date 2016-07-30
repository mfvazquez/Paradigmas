function [exit, log] = Respuesta(textos_opciones)

    global rightKey;
    global leftKey;
    global spaceKey;
    global escKey;
    
    global hd;
    
    exit = false;

    elegido = 5;
    dibujarOpciones(elegido, textos_opciones);
    [~, OnSetTime] = Screen('Flip', hd.window);
    log.respuesta_inicio = OnSetTime;
    log.primer_movimiento = -1;
    continuar = true;
    FlushEvents;
    while continuar

        tecla = GetChar;
        
        if (log.primer_movimiento == -1)
           log.primer_movimiento = GetSecs; 
        end
        
        if tecla == rightKey && elegido < 9
            elegido = elegido + 1;
            dibujarOpciones(elegido, textos_opciones);
            Screen('Flip', hd.window);
        elseif tecla == leftKey && elegido > 1
            elegido = elegido - 1;
            dibujarOpciones(elegido, textos_opciones);
            Screen('Flip', hd.window);
        elseif tecla == spaceKey
            log.respuesta_fin = GetSecs;
            continuar = false;
            log.respuesta = elegido;
        elseif tecla == escKey
            exit = true;
            continuar = false;
        end

    end
    
end