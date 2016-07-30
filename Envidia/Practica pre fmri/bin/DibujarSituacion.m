function DibujarSituacion(texto, textura, mensaje)
    global hd;

    [rect_texto, rect_imagen] = PresentarImagen(texto, textura);
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    
    white = [255 255 255];
    
    Ypos = round(screenYpixels * 0.8);
    YLength = round((screenYpixels - Ypos)/2);
    rect = [0  Ypos+YLength screenXpixels screenYpixels];
    
    textSize = round(screenYpixels*0.05);
    Screen('TextSize', hd.window, textSize);
    
    rect = rect + [0 round(screenYpixels/5)  0 0];
    
    rect_texto(2) = rect_imagen(4) - round(textSize*1.5);
    rect_texto(4) = rect_imagen(4) - round(textSize*0.5);
    
    DrawFormattedText(hd.window, mensaje, 'center','center', white, [],[],[],1.1,[],rect_texto);
    
end