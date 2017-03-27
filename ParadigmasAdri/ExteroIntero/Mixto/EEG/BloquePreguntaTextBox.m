function [texto, exit] = BloquePreguntaTextBox(hd, pregunta, teclas)

    global TAMANIO_TEXTO

    continuar = true;
    texto = '';
    while continuar

        [secs, keyCode, deltaSecs] = KbPressWait;
    
        if keyCode(teclas.Enter)
            continuar = false;
        else
            texto = [texto char(find(keyCode==1))];
        end
    
        TextoCentrado(texto, TAMANIO_TEXTO, hd);
        Screen('Flip',hd.window);
        
        
    end

end