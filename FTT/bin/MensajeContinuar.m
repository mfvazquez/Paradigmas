function MensajeContinuar(mensaje)
    global hd;
      
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    
    Ypos = round(screenYpixels * 0.75);
    YLength = round((screenYpixels - Ypos)/2);

    rect = [0  Ypos+YLength screenXpixels screenYpixels];
    textSize = round(hd.textSize*0.75);
    Screen('TextSize', hd.window, textSize);
    DrawFormattedText(hd.window, mensaje, 'center','center', hd.white, [],[],[],2,[],rect);      
    
end