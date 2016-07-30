function textoCentrado(texto, tamanio)

    global hd;

    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);

    textSize = round(screenYpixels*tamanio);
   
%     TEXTURA_ALTO = round(screenYpixels * 0.6);
%     TEXTURA_ANCHO = round(TEXTURA_ALTO*300/450);
%     Xpos = round(screenXpixels/2 - TEXTURA_ANCHO/2);
%     Ypos = round(screenYpixels * 0.05);
%     
%     rect = [Xpos  Ypos Xpos+TEXTURA_ANCHO Ypos+TEXTURA_ALTO];
    
    Screen('TextSize', hd.window, textSize);
%     DrawFormattedText(hd.window, texto, 'center','center', hd.white, [],[],[], 1.25,[],rect);
    DrawFormattedText(hd.window, texto, 'center','center', hd.white, [],[],[], 1.35);

end
