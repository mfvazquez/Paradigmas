function exit = ButtonWait(botones)
    
    exit = false;
    global escKey;
    
    esperar = true;
    FlushEvents;
    while esperar
        tecla = GetChar;
        if any(botones == tecla)
            esperar = false;
        end
        
        if tecla == escKey
            exit = true;
            esperar = false;
        end
        
    end
    
end
