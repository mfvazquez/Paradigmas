function exit = PresentarSituacion(texto, textura, mensaje)

    global window;
    global escKey;
    global spaceKey;

    PresentarImagen(texto, textura);
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    white = [255 255 255];
    
    Ypos = round(screenYpixels * 0.8);
    YLength = round((screenYpixels - Ypos)/2);
    rect = [0  Ypos+YLength screenXpixels screenYpixels];
    
    textSize = round(screenYpixels*0.03);
    Screen('TextSize', window, textSize);
    DrawFormattedText(window, mensaje, 'center','center', white, [],[],[],2,[],rect);
    
    Screen('Flip', window);    
    
    exit = false;
    esperar = true;
    while esperar
        [~, keyCode, ~] = KbPressWait;
        if keyCode(spaceKey)
            esperar = false;
        elseif keyCode(escKey)
            esperar = false;
            exit = true;
        end   
    end
    
end