function Bloque(secuencia, duracion)

    global hd; 
    global escKey;
    global fKey;
    global gKey;
    global hKey;
    global jKey;

    secuencia_largo = floor(length(secuencia)/2) + 1;
    
    actual = 1;
    DibujarSecuencia(secuencia, actual);
    Screen('Flip', hd.window);
    
    duracion = 3;
    actual = 1;
    continuar = true;
    tstart = GetSecs();
    [~, ~, keyCode, ~] = KbCheck;
    while continuar

        keyCode = KbCheckNewPush(keyCode);
        find(keyCode)
        
        if keyCode(fKey)
            actual = actual + 1
            if actual > secuencia_largo
                actual = 1
            end

            DibujarSecuencia(secuencia, actual);
            Screen('Flip', hd.window);
        elseif keyCode(escKey)
            continuar = false;
        end


        telapsed = GetSecs();
        if (telapsed - tstart > duracion)
            continuar = false;
        end
    end


end
