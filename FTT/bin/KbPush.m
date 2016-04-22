function key = KbPush()

    ListenChar(2);
    KbName('UnifyKeyNames');
    escKey = KbName('ESCAPE');
    
    continuar = true;
    
    [~, ~, keyCode, ~] = KbCheck;
    anteriores = find(keyCode);
    
    while continuar

        [keyIsDown, ~, keyCode, ~] = KbCheck;
        if (keyIsDown)
            
            teclas_activas = find(keyCode);
            apretados = setdiff(teclas_activas, anteriores);
            anteriores = teclas_activas;
            
            
            
            WaitSecs(1);

            if keyCode(escKey)
                continuar = false;
            end   
        end

    end
    
    ListenChar(1);
end