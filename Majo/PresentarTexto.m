function [exit, log] = PresentarTexto(hd, teclas, texto, tiempo)

    global TAMANIO_TEXTO
    TextoCentrado(texto, TAMANIO_TEXTO ,hd);    
    [~, log.on_set] = Screen('Flip', hd.window);    
    [exit, ~] = Esperar(tiempo, teclas.salir,[], [], []);
    log.off_set = GetSecs;
    
end