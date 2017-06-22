function MensajeContinuar(mensaje, color, hd)

    global TAMANIO_TEXTO
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    
    Ypos = round(screenYpixels * 0.75);
    YLength = round((screenYpixels - Ypos)/2);

    rect = [0  Ypos+YLength screenXpixels screenYpixels];
    textSize = round(screenYpixels*TAMANIO_TEXTO*0.5);
    Screen('TextSize', hd.window, textSize);
    DrawFormattedText(hd.window, mensaje, 'center','center', color, [],[],[],2,[],rect);      
    
end