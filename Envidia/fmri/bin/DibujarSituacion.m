function DibujarSituacion(texto, textura, mensaje)
    global hd;

    PresentarImagen(texto, textura);
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    white = [255 255 255];
    
    Ypos = round(screenYpixels * 0.8);
    YLength = round((screenYpixels - Ypos)/2);
    rect = [0  Ypos+YLength screenXpixels screenYpixels];
    
    textSize = round(screenYpixels*0.03);
    Screen('TextSize', hd.window, textSize);
    DrawFormattedText(hd.window, mensaje, 'center','center', white, [],[],[],2,[],rect);
    
end