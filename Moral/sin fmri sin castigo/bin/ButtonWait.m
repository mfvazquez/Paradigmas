function exit = ButtonWait(botones)
    exit = false;
    KbName('UnifyKeyNames');
    escKey = KbName('ESCAPE');
    esperar = true;
    FlushEvents;
    while esperar
        tecla = GetChar;
        if any(botones == tecla)
            esperar = false;
        end
        [~, ~, keyCode, ~] = KbCheck();
        if keyCode(escKey)
            exit = true;
            return
        end
    end
    
end