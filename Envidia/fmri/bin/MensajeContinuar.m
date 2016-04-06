function MensajeContinuar(mensaje)
    global window;
    
    white = [255 255 255];
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    Ypos = round(screenYpixels * 0.75);
    YLength = round((screenYpixels - Ypos)/2);

    rect = [0  Ypos+YLength screenXpixels screenYpixels];
    textSize = round(screenYpixels*0.03);
    Screen('TextSize', window, textSize);
    DrawFormattedText(window, mensaje, 'center','center', white, [],[],[],2,[],rect);      
    
end