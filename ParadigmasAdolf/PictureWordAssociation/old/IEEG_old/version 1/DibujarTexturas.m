function DibujarTexturas(textura_izquierda, textura_derecha)

    global hd
    global SEPARACION
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    TEXTURA_ANCHO = round(screenXpixels*SEPARACION);
    TEXTURA_ALTO = round(TEXTURA_ANCHO * 149/254);
    
    Xpos = round((screenXpixels - TEXTURA_ANCHO*3)/2);
    Ypos = round((screenYpixels - TEXTURA_ALTO) / 2);
    rect_imagen = [Xpos  Ypos Xpos+TEXTURA_ANCHO Ypos+TEXTURA_ALTO];
    Screen('DrawTexture', hd.window, textura_izquierda, [], rect_imagen );
    
    if nargin == 2
        Xpos = round((screenXpixels + TEXTURA_ANCHO)/2);
        rect_imagen = [Xpos  Ypos Xpos+TEXTURA_ANCHO Ypos+TEXTURA_ALTO];
        Screen('DrawTexture', hd.window, textura_derecha, [], rect_imagen );
    end
        
end