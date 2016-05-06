function [log, exit] = Bloque(secuencia, duracion, teclas)

    global hd; 
    global escKey;
    
    exit = false;
    
    log.accuracy = cell(2500,1);
    log.resp_time = cell(2500,1);
    log.resp_rel_time = cell(2500,1);
    log.begin = [];
    log.end = [];
    
    secuencia_largo = floor(length(secuencia)/2) + 1;
    
    log.begin = GetSecs;
    
    actual = 1;
    DibujarSecuencia(secuencia, actual);
    Screen('Flip', hd.window);
    
    continuar = true;
    tstart = GetSecs();
    [~, anteriores, ~] = KbCheck;
    contador = 1;
    while continuar

        [keyCode, anteriores] = KbCheckNewPush(anteriores);
        keyCode = find(keyCode);
        
        if any(keyCode == escKey)
            continuar = false;
            exit = true;
            
        elseif any(ismember(keyCode, teclas))
            
            for i = 1:length(keyCode)
                boton = find(keyCode(i) == teclas) + 1;
                if ~isempty(boton)
                    log.resp_time{contador,1} = GetSecs;
                    if (contador > 1)
                        log.resp_rel_time{contador,1} = log.resp_time{contador,1} - log.resp_time{contador-1,1};
                    end
                    num = secuencia(actual*2-1);
                    num = str2num(num);
                    if num == boton
                        log.accuracy{contador,1} = 1;
                    else
                        log.accuracy{contador,1} = -1;
                    end
                    contador = contador + 1;
                end
            end
            
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
            Screen('Flip', hd.window);
        end
    end
    log.end = GetSecs;
end
