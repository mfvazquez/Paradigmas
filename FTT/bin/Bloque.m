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
    
    actual = 1;
    continuar = true;
    tstart = GetSecs();
    while continuar

        [~, keyCode, ~] = KbPressWait;
        
        if any(keyCode)
            actual = actual + 1;
            if actual > secuencia_largo;
                actual = 1;
            end

            DibujarSecuencia(secuencia, actual);
            Screen('Flip', hd.window);
        end


        telapsed = GetSecs();
        if (telapsed - tstart > duracion)
            continuar = false;
        end
    end

end
