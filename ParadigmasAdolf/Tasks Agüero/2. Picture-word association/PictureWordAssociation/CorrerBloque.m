function [exit, log] = CorrerBloque(bloque, log)

    global hd
    global TAMANIO_INSTRUCCIONES
    global MENSAJE_PRACTICA
    global MENSAJE_BLOQUES

    %% INSTRUCCIONES
   
    for i = 1:length(bloque.instrucciones)
        TextoCentrado(bloque.instrucciones{i}, TAMANIO_INSTRUCCIONES);
        Screen('Flip', hd.window);
        KbStrokeWait;
    end

    
    %% PRACTICA
    TextoCentrado(MENSAJE_PRACTICA, TAMANIO_INSTRUCCIONES);
    Screen('Flip', hd.window);
    KbStrokeWait;
    exit = CorrerSecuencia(bloque.practica_texturas);
    if exit
        return
    end
       

    %% BLOQUES
    TextoCentrado(MENSAJE_BLOQUES, TAMANIO_INSTRUCCIONES);
    Screen('Flip', hd.window);
    KbStrokeWait;
    if ~exit
        [exit, log] = CorrerSecuencia(bloque.bloque_texturas, bloque.estimulos, log);
    end

end