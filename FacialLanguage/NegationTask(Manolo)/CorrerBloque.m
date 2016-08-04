function [exit, log] = CorrerBloque(bloque, entrenamiento, log)

    global hd
    global TEXTO_CONTINUAR
    global ExitKey
    global ContinueKey
    global TEXT_SIZE_INST
    
    exit = false;
    stat.total = 0;
    stat.correctas = 0;
    n = 1;
    for i = randperm(length(bloque))

        if entrenamiento
            TextoCentrado(TEXTO_CONTINUAR, TEXT_SIZE_INST);
            Screen('Flip', hd.window);
            exit = EsperarBoton(ContinueKey, ExitKey);
            if exit
                return;
            end
            [exit, accuracy, stat, ~] = CorrerSecuencia(bloque{i}, entrenamiento, stat, []);
        else    
            [exit, accuracy, stat, log{n}] = CorrerSecuencia(bloque{i}, entrenamiento, stat, log{n});
        end
        
        if exit
            return;
        end
        
        n = n + 1;
    end

end