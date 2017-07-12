function [exit, log] = CorrerBloque(bloque, entrenamiento, log)

    global hd
    global TEXTO_CONTINUAR
    global ExitKey
    global ContinueKey
    global TEXT_SIZE_INST
    global DOT
    
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
        end
        [exit, stat, log{n}] = CorrerSecuencia(bloque{i}, entrenamiento, stat);
        
        if exit
            return;
        end
                
        n = n + 1;
    end

end