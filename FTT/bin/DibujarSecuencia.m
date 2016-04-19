function DibujarSecuencia(secuencia, actual)

    global hd;
    
    [Xpixels, Ypixels] = Screen('WindowSize', hd.window);
    
    textSize = round(hd.textSize*2);
    Screen('TextSize', hd.window, textSize);

    dotSizePix = round(hd.textSize*0.5);
    
    YBoxLength = round(Ypixels * 0.1);
    Ypos = round((Ypixels - YBoxLength * 2)/2);
    
    Xlength = round(Xpixels/2);
    Xpos = round((Xpixels - Xlength)/2);
    BoxXLength = round(Xlength/length(secuencia));
    
    corrimiento = round(textSize * 0.5);
    
    for i = 1:length(secuencia)
    
        SecRect = [ Xpos+BoxXLength*(i-1) Ypos-corrimiento Xpos+BoxXLength*i Ypos+YBoxLength-corrimiento ];
        DrawFormattedText(hd.window, secuencia(i), 'center','center', hd.white, [],[],[],[],[], SecRect);
        
        if i == actual
            Screen('DrawDots', hd.window, [SecRect(1) SecRect(2)], dotSizePix, hd.white, [], 2);    
        end
    end
    
end