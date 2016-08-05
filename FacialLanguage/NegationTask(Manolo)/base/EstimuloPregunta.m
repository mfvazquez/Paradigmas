function [exit, respuesta, log] = EstimuloPregunta(texto, TIEMPOS, log)
   
    global hd
    global ExitKey
    global PREGUNTA
    global TEXT_SIZE_STIM
    global OPCION_IZQ
    global OPCION_DER
    global OPCION_DIST

    
    respuesta.valor = '';
    respuesta.tiempo = NaN;

    TextoCentrado(PREGUNTA.STR, TEXT_SIZE_STIM);
    [~, OnSetTime] = Screen('Flip', hd.window);
    log{1} = OnSetTime;
    [exit, ~] = Esperar(TIEMPOS{1}, ExitKey, []);
    if exit
        return
    end
    
    rect_der = zeros(1,4);
    rect_izq = zeros(1,4);
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    Ycenter = screenYpixels/2;
    
    rect_izq(1) = round(screenXpixels*0.2);
    rect_izq(2) = round(Ycenter + OPCION_DIST * screenYpixels);
    rect_izq(3) = round(screenXpixels*0.3);
    rect_izq(4) = rect_izq(2) + round(OPCION_DIST*screenYpixels/10);
    
    rect_der(1) = round(screenXpixels*0.7);
    rect_der(2) = rect_izq(2);
    rect_der(3) = round(screenXpixels*0.8);
    rect_der(4) = rect_izq(4);
    
    
    TextoCentrado(texto, TEXT_SIZE_STIM);
    DrawFormattedText(hd.window, OPCION_IZQ.STR, 'center','center', hd.white, [], [], [], 1.5, [], rect_izq);
    DrawFormattedText(hd.window, OPCION_DER.STR, 'center','center', hd.white, [], [], [], 1.5, [], rect_der);
    
    [~, OnSetTime] = Screen('Flip', hd.window);
    log{2} = OnSetTime;
    [exit, respuesta] = Esperar(TIEMPOS{2}, ExitKey, {OPCION_IZQ OPCION_DER});

end