function textoCentrado(texto)

    global hd;
    
    [~, screenYpixels] = Screen('WindowSize', hd.window);

    textSize = round(screenYpixels*0.04);

    textSize = round(hd.textSize*1.25);
    Screen('TextSize', hd.window, textSize);
    DrawFormattedText(hd.window, texto, 'center','center', hd.white, [],[],[], 2,[],[]);
end