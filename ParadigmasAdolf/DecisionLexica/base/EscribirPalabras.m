function EscribirPalabras(palabra_izquierda, palabra_derecha, proporcion_texto, proporcion_separacion)

    global hd
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    textSize = round(screenYpixels*proporcion_texto);
    Screen('TextSize', hd.window, textSize);
    separacion = round(screenXpixels*proporcion_separacion);

    rect_izq = [round((screenXpixels - separacion*3)/2) round((screenYpixels-textSize)/2) round((screenXpixels - separacion)/2) round((screenYpixels+textSize)/2)];
    rect_der = rect_izq;
    rect_der(1) = round((screenXpixels + separacion)/2);
    rect_der(3) = round((screenXpixels + separacion*3)/2);
    
    Screen('TextSize', hd.window, textSize);

    DrawFormattedText(hd.window, palabra_izquierda, 'right', 'center', hd.white, [], [], [], 1.5, [], rect_izq);
    DrawFormattedText(hd.window, palabra_derecha, 'wrapat', 'center', hd.white, length(palabra_derecha), [], [], 1.5, [], rect_der);


end