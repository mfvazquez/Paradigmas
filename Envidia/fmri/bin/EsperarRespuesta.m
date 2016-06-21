function [elegido, continuar, exit] = EsperarRespuesta(elegido)
   
    global escKey;
    global rightKey;
    global leftKey;
    global spaceKey;

    exit = false;
    continuar = true;
    [~, keyCode, ~] = KbPressWait;

    if keyCode(rightKey) && elegido < 9
        elegido = elegido + 1;
    elseif keyCode(leftKey) && elegido > 1
        elegido = elegido - 1;
    elseif keyCode(spaceKey)
        continuar = false;
    elseif keyCode(escKey)
        continuar = false;
        exit = true;
    end   

end