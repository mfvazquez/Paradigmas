function DibujarSituacion(texto, textura, mensaje)
    global window;

    PresentarImagen(texto, textura);
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    white = [255 255 255];
    
    Ypos = round(screenYpixels * 0.8);
    YLength = round((screenYpixels - Ypos)/2);
    rect = [0  Ypos+YLength screenXpixels screenYpixels];
    
    textSize = round(screenYpixels*0.03);
    Screen('TextSize', window, textSize);
    DrawFormattedText(window, mensaje, 'center','center', white, [],[],[],2,[],rect);
    
end