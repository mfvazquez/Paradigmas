function [rect_texto, rect_imagen] = PresentarImagen(texto, textura)

    global hd;

    global TAMANIO_TEXTO;
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    
    TEXTURA_ALTO = round(screenYpixels * 0.6);
    TEXTURA_ANCHO = round(TEXTURA_ALTO*300/450);
    Xpos = round(TEXTURA_ANCHO/5);
    Ypos = round((screenYpixels - TEXTURA_ALTO)/2);
    
    rect_imagen = [Xpos  Ypos Xpos+TEXTURA_ANCHO Ypos+TEXTURA_ALTO];
    Screen('DrawTexture', hd.window, textura, [], rect_imagen );
    
    textSize = round(screenYpixels*TAMANIO_TEXTO);
    Screen('TextSize', hd.window, textSize);
    
    Xpos = Xpos*2+ TEXTURA_ANCHO;

    rect_texto = [Xpos  Ypos screenXpixels Ypos+round(TEXTURA_ALTO*0.8)];
    DrawFormattedText(hd.window, texto, 'center','center', hd.white, [],[],[],1.5,[],rect_texto);
    rect_texto(4) = Ypos+TEXTURA_ALTO;
    
end