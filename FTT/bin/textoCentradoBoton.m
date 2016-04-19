function textoCentrado(texto)

    global window;
    
    white = [255 255 255];
    
    [~, screenYpixels] = Screen('WindowSize', window);
    textSize = round(screenYpixels*0.04);

    Screen('TextSize', window, textSize);
    DrawFormattedText(window, texto, 'center','center', white, [],[],[], 2,[],[]);
end
