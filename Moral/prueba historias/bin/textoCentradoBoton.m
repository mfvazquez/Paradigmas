function textoCentradoBoton(texto)

    global hd;
    
    [asdasd, screenYpixels] = Screen('WindowSize', hd.window);
    
    textSize = round(screenYpixels*0.035);

    Screen('TextSize', hd.window, textSize);
    DrawFormattedText(hd.window, texto, 'center','center', hd.white, [],[],[], 2,[],[]);
    Screen('Flip', hd.window);
    

end
