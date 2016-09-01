function exit = ButtonWait(botones)
    exit = false;
    global escKey;
    
    esperar = true;
    FlushEvents;
    while esperar
        [~, keyCode, ~] = KbPressWait;
        if any(keyCode(botones))
            esperar = false;
        end
        
        if keyCode(escKey)
            exit = true;
            esperar = false;
        end
        
    end
    
end
