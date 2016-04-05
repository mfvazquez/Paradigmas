function PresentarPersonaje(personaje, tiempo, window)
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    white = [255 255 255];
    TEXTURA_ALTO = round(screenYpixels * 0.6);
    TEXTURA_ANCHO = round(screenXpixels * 0.3);
    
    textSize = round(screenYpixels*0.04);
    Ypos = round(screenYpixels * 0.75);
    
    rect = [0  Ypos screenXpixels screenYpixels];
    
    Screen('TextSize', window, textSize);
    DrawFormattedText(window, personaje.historia, 'center','center', white, [],[],[],2,[],rect);
    
    
    Xpos = round(screenXpixels/2 - TEXTURA_ANCHO/2);
    Ypos = round(Ypos/2 - TEXTURA_ALTO/2);
    
    rect = [Xpos  Ypos Xpos+TEXTURA_ANCHO Ypos+TEXTURA_ALTO];
    Screen('DrawTexture', window, personaje.textura, [], rect );

    Screen('Flip', window);    
    WaitSecs(tiempo);
end