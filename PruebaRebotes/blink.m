function blink(on)
    global hd;
    
    black = [0 0 0];
    white = [255 255 255];
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    
    pdpix=[round(screenXpixels*0.15) round(screenYpixels*0.08)];
    blink_left=[0 0 pdpix];
    
    
    if on
        Screen('FillRect', hd.window ,white, blink_left);
    else
        Screen('FillRect', hd.window ,black, blink_left);
    end
end