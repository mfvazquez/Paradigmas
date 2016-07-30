function [OnSetTime, exit] = PresentarSituacion(texto, textura, mensaje)

    global hd;
    global spaceKey;
    
    DibujarSituacion(texto, textura, mensaje);
    [~, OnSetTime] = Screen('Flip', hd.window);
    exit = ButtonWait(spaceKey);    
    
end