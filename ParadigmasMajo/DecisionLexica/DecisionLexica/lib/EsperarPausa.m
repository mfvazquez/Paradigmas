function exit = EsperarPausa(boton_pausa, boton_salida)

    global MARCA_PAUSA_INICIO EEG
    global MARCA_PAUSA_FIN

    if EEG
        EnviarMarca(MARCA_PAUSA_INICIO)   
    end
    
    [~, keyCode, ~] = KbReleaseWait;
    while ~isempty(find(keyCode,1))
            [~, keyCode, ~] = KbReleaseWait;
    end
        
    exit = EsperarBoton(boton_pausa, boton_salida);    
    if exit
        return
    end
    
    [~, keyCode, ~] = KbReleaseWait;
    while ~isempty(find(keyCode,1))
            [~, keyCode, ~] = KbReleaseWait;
    end         
    
    if EEG
        EnviarMarca(MARCA_PAUSA_FIN)  
    end0
end