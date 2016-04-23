function PresentarImagen(texto, textura)

    global window;

    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    white = [255 255 255];
    
    TEXTURA_ALTO = round(screenYpixels * 0.6);
    TEXTURA_ANCHO = round(TEXTURA_ALTO*300/450);
    Xpos = round(screenXpixels/2 - TEXTURA_ANCHO/2);
    Ypos = round(screenYpixels * 0.05);
    
    rect = [Xpos  Ypos Xpos+TEXTURA_ANCHO Ypos+TEXTURA_ALTO];
    Screen('DrawTexture', window, textura, [], rect );
    
    textSize = round(screenYpixels*0.04);
    Screen('TextSize', window, textSize);
    
    Ypos = round(screenYpixels * 0.6);
    
    rect = [0  Ypos screenXpixels screenYpixels];
    DrawFormattedText(window, texto, 'center','center', white, [],[],[],2,[],rect);
    
end