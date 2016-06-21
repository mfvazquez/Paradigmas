function exit = PresentarSituacion(texto, textura, mensaje)

    global escKey;
    global spaceKey;
    global hd;

    DibujarSituacion(texto, textura, mensaje);    
    Screen('Flip', hd.window);    
    
    exit = false;
    esperar = true;
    while esperar
        [~, keyCode, ~] = KbPressWait;
        if keyCode(spaceKey)
            esperar = false;
        elseif keyCode(escKey)
            esperar = false;
            exit = true;
        end   
    end
    
end