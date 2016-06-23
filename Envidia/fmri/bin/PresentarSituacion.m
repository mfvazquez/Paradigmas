function OnSetTime = PresentarSituacion(texto, textura, mensaje)

    global hd;
    global rightKey;
    global leftKey;
    global spaceKey;
    global auxKey;
    
    DibujarSituacion(texto, textura, mensaje);
    [~, OnSetTime] = Screen('Flip', hd.window);
    
    esperar = true;
    while esperar
        tecla = GetChar;
        if tecla == spaceKey || tecla == rightKey || tecla == leftKey || tecla == auxKey
            esperar = false;
        end   
    end
    
end