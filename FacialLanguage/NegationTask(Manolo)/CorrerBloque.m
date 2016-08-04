function exit = CorrerBloque(bloque, entrenamiento)

    global hd
    global TEXTO_CONTINUAR
    global ExitKey
    global ContinueKey
    global TEXT_SIZE_INST
    
    exit = false;
    stat.total = 0;
    stat.correctas = 0;
    for i = randperm(length(bloque))

        if entrenamiento
            TextoCentrado(TEXTO_CONTINUAR, TEXT_SIZE_INST);
            Screen('Flip', hd.window);
            exit = EsperarBoton(ContinueKey, ExitKey);
            if exit
                return;
            end
        end
        
        [exit, accuracy, stat] = CorrerSecuencia(bloque{i}, entrenamiento, stat);
        if exit
            return;
        end
        
    end

end