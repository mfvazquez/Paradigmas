function textoCentrado(texto)

    global window;

    [~, screenYpixels] = Screen('WindowSize', window);
    
    white = [255 255 255];

    textSize = round(screenYpixels*0.05);

    Screen('TextSize', window, textSize);
    DrawFormattedText(window, texto, 'center','center', white);
    Screen('Flip', window);

end
