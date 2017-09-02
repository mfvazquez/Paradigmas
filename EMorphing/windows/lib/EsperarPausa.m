function exit = EsperarPausa(boton_pausa, boton_salida)

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
    

end