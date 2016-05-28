function textoCentrado(texto, tamanio)

    global hd;

    [~, screenYpixels] = Screen('WindowSize', hd.window);

    textSize = round(screenYpixels*tamanio);

    Screen('TextSize', hd.window, textSize);
    DrawFormattedText(hd.window, texto, 'center','center', hd.white, [],[],[], 1.5,[]);

end
