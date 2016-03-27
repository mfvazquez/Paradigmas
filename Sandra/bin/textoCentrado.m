function textoCentrado(window, scrnsize, tiempo, texto)

    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    white = [255 255 255];
    black = [0 0 0];

    textSize = round(screenYpixels*0.05);

    Screen('TextSize', window, textSize);
    DrawFormattedText(window, texto, 'center','center', white);
    Screen('Flip', window);
    WaitSecs(tiempo);

end
