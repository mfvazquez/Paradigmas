    fKey = KbName('f');
    gKey = KbName('g');
    hKey = KbName('h');
    jKey = KbName('j');


    ListenChar(2);
    

    actual = 1;
    continuar = true;
    [~, ~, anteriores, ~] = KbCheck;
    while continuar

        [keyCode, anteriores] = KbCheckNewPush(anteriores);
        
        
        if keyCode(fKey)
            find(keyCode)

%             DibujarSecuencia(secuencia, actual);
%             Screen('Flip', hd.window);
        elseif keyCode(jKey)
            continuar = false;
        end


    end
    
    
    ListenChar(1);