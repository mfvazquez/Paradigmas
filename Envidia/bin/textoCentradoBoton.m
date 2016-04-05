function textoCentradoBoton(window, texto)

    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    white = [255 255 255];

    textSize = round(screenYpixels*0.04);

    Screen('TextSize', window, textSize);
    DrawFormattedText(window, texto, 'center','center', white, [],[],[], 2,[],[]);
    Screen('Flip', window);
    KbWait;

end
