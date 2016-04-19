function textoCentrado(tiempo, texto)

    global window;

    [~, screenYpixels] = Screen('WindowSize', window);
    
    white = [255 255 255];

    textSize = round(screenYpixels*0.05);

    Screen('TextSize', window, textSize);
    DrawFormattedText(window, texto, 'center', 'center', white, [], [], [], 2, [] ,[]);
    Screen('Flip', window);
    WaitSecs(tiempo);

end
