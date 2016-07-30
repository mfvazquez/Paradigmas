function [elegido, continuar, exit] = EsperarRespuesta(elegido)
   
    global rightKey;
    global leftKey;
    global spaceKey;
    global escKey;

    exit = false;
    continuar = true;
    tecla = GetChar;

    if tecla == rightKey && elegido < 9
        elegido = elegido + 1;
    elseif tecla == leftKey && elegido > 1
        elegido = elegido - 1;
    elseif tecla == spaceKey
        continuar = false;
    end
    
    if tecla == escKey
        exit = true;
    end
    
end