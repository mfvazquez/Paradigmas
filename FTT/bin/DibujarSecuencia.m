function DibujarSecuencia(secuencia, actual)

    global hd;
    
    [Xpixels, Ypixels] = Screen('WindowSize', hd.window);
        
    YBoxLength = round(Ypixels * 0.1);
    Ypos = round((Ypixels - YBoxLength * 2)/2);
    
    textSize = round(YBoxLength*0.8);
    Screen('TextSize', hd.window, textSize);

    dotSizePix = round(YBoxLength*0.2);

    
    
    DistanciaPunto = round(YBoxLength*2);
    
    Xlength = round(Xpixels/2);
    Xpos = round((Xpixels - Xlength)/2);
    BoxXLength = round(Xlength/length(secuencia));
    
    corrimiento = round(textSize * 0.5);
    
    for i = 1:length(secuencia)
    
        SecRect = [ Xpos+BoxXLength*(i-1) Ypos-corrimiento Xpos+BoxXLength*i Ypos+YBoxLength-corrimiento ];
        DrawFormattedText(hd.window, secuencia(i), 'center','center', hd.white, [],[],[],[],[], SecRect);
        
        if i == (2*actual-1)
            SelRect = SecRect + [0 DistanciaPunto 0 0];
            centro = [round((SelRect(1) + SelRect(3))/2) round((SelRect(2) + SelRect(4))/2)];
            Screen('DrawDots', hd.window, centro, dotSizePix, hd.white, [], 2);    
        end
    end
    
end