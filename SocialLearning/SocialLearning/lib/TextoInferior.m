function TextoInferior(texto, tamanio, hd, color)

    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);

    textSize = round(screenYpixels*tamanio);
   
    Screen('TextSize', hd.window, textSize);
    if nargin == 3
        color = hd.white;
    end

    rect = [0 round(screenYpixels*3/4) screenXpixels screenYpixels-10];
    
    DrawFormattedText(hd.window, texto, 'center','center', color, [], [], [], 1.25, [], rect);

    
end