function PresentarImagen(texto, textura)

    global hd;

    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    
    TEXTURA_ALTO = round(screenYpixels * 0.6);
    TEXTURA_ANCHO = round(TEXTURA_ALTO*300/450);
    Xpos = round(TEXTURA_ANCHO/5);
    Ypos = round(screenYpixels * 0.05);
    
    rect = [Xpos  Ypos Xpos+TEXTURA_ANCHO Ypos+TEXTURA_ALTO];
    Screen('DrawTexture', hd.window, textura, [], rect );
    
    textSize = round(screenYpixels*0.04);
    Screen('TextSize', hd.window, textSize);
    
    Xpos = Xpos*2+ TEXTURA_ANCHO;

    rect = [Xpos  Ypos screenXpixels Ypos+TEXTURA_ALTO];
    DrawFormattedText(hd.window, texto, 'center','center', hd.white, [],[],[],2,[],rect);
    
end