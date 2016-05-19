function exit = CorrerBloque(bloque)

    global hd;
    
    KbName('UnifyKeyNames');
    escKey = KbName('ESCAPE');
    
    exit = false;
    
    for i = 1:length(bloque.palabra)
        
        %% ----------------- FIJACION -----------

        textoCentrado('+', 0.07);
        Screen('Flip',hd.window);
        WaitSecs(0.2);

        %% ----------------- PALABRA ------------

        textoCentrado(bloque.palabra{i}, 0.06);
        Screen('Flip',hd.window);
        WaitSecs(0.3);

        %% ----------------- RESPUESTA ----------
        
        continuar = true;
        [~, tstart] = Screen('Flip',hd.window);
        while (GetSecs - tstart < 2.7 && continuar)
            
            [keyIsDown,secs, keyCode] = KbCheck;
            
            if keyIsDown
                continuar = false;
                if keyCode(escKey)
                    exit = true;
                    return
                end
            end
            
        end
        
    end
        
end