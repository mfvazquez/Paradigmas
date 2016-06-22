function textoCentrado(texto)

    global hd;

    [~, screenYpixels] = Screen('WindowSize', hd.window);
    
    white = [255 255 255];

    textSize = round(screenYpixels*0.05);

    Screen('TextSize', hd.window, textSize);
    DrawFormattedText(hd.window, texto, 'center','center', white, [], [], [], 1.5, [], []);
end
