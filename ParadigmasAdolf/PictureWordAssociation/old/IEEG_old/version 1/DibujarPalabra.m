function DibujarPalabra(estimulos)

    global hd;
    
    palabra = estimulos{4};
    if isempty(palabra)
        palabra = estimulos{1};
    end
    palabra = upper(palabra);
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    textSize = round(screenYpixels*0.05);
    Screen('TextSize', hd.window, textSize);
    
    rect = [round(screenXpixels*0.5) round(screenYpixels*0.85) round(screenXpixels*0.5) round(screenYpixels * 0.95)];
        
    
    DrawFormattedText(hd.window, palabra, 'center', 'center', hd.black, [], [], [], 1.5, [], rect);


end