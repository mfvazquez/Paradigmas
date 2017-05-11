function DibujarOpcionesVertical(elegido, opciones, titulo, hd)

    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);

    MARGEN_X = round(screenXpixels/10);
    MARGEN_Y = round(screenYpixels / (length(opciones)+2));
    
    textSize = round(MARGEN_Y*0.25);
    Screen('TextSize', hd.window, textSize);
    
    rect = [0 0 screenXpixels MARGEN_Y];
    DrawFormattedText(hd.window, titulo, 'center','center', hd.white, [],[],[],[],[], rect);
    
    dot_point = [round((screenXpixels-MARGEN_X)/2)  round(MARGEN_Y/2)];
    rect = [round(screenXpixels/2) 0 screenXpixels-MARGEN_X MARGEN_Y];
    for y = 1:length(opciones)
       
        rect = rect + [0 MARGEN_Y 0 MARGEN_Y];
        dot_point = dot_point + [0 MARGEN_Y];
        DrawFormattedText(hd.window, opciones{y}, 'justifytomax','center', hd.white, [],[],[],[],[], rect);
        Screen('DrawDots', hd.window, dot_point,  round(MARGEN_Y/2) , hd.white, [], 1);
        if y == elegido
            Screen('DrawDots', hd.window, dot_point,  round(MARGEN_Y/4) , hd.red, [], 1);
        end        
        
    end
    

end