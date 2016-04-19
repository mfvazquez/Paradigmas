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
    
    continuar = true;
    tstart = GetSecs();
    primer_tecla = true;
    while continuar

        [keyIsDown, ~, keyCode, ~] = KbCheck;
        if (keyIsDown && (primer_tecla || anterior ~= keyCode()))
            primer_tecla = false;
            anterior = keyCode;
            if ~keyCode(escKey)
                    actual = actual + 1;
                    if actual > secuencia_largo
                        actual = 1;
                    end

                    DibujarSecuencia(secuencia, actual);
                    Screen('Flip', hd.window);
            else
                continuar = false;
            end
        end

        telapsed = GetSecs();
        if (telapsed - tstart > duracion)
            continuar = false;
        end
    end


end
