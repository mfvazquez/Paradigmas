function OnSetTime = blink()
    global window;
    
    black = [0 0 0];
    white = [255 255 255];
    TIME = 0.02;
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    pdpix=[round(screenXpixels*0.15) round(screenYpixels*0.08)];
    blink_left=[0 0 pdpix];
    
    Screen('FillRect', window ,white, blink_left);
    [~, OnSetTime] = Screen('Flip', window, [], 1);
    Screen('FillRect', window ,black, blink_left);
    Screen('Flip', window, OnSetTime+TIME);
end