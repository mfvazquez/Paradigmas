function [exit, OnSetTime] = PresentarSituacion(texto, textura, mensaje)

    global window;
    global escKey;
    global spaceKey;

    DibujarSituacion(texto, textura, mensaje);
    [~, OnSetTime] = Screen('Flip', window); 
    
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