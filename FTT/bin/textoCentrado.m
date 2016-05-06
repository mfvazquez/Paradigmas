function textoCentrado(texto)

    global hd;
    
    [~, screenYpixels] = Screen('WindowSize', hd.window);

    hd.textSize = round(screenYpixels*0.04);

    Screen('TextSize', hd.window, hd.textSize);
    DrawFormattedText(hd.window, texto, 'center','center', hd.white, [],[],[], 2,[],[]);
end
