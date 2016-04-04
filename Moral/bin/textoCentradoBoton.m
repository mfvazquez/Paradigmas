function textoCentradoBoton(window, scrnsize, texto)

    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    white = [255 255 255];
    black = [0 0 0];

    textSize = round(screenYpixels*0.035);

    Screen('TextSize', window, textSize);
    DrawFormattedText(window, texto, 'center','center', white, [],[],[], 2,[],[]);
    Screen('Flip', window);
    KbWait;

end
