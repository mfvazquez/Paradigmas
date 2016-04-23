function exit = PresentarSituacion(texto, textura, mensaje)

    global window;
    global escKey;
    global spaceKey;

    DibujarSituacion(texto, textura, mensaje);    
    Screen('Flip', window);    
    
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