function blink(PsyParams, time)
    window = PsyParams.window;
    black = PsyParams.black;
    white = PsyParams.white;
    
    pdpix=[100 50];
    blink_left=[0 0 pdpix];
    
    Screen('FillRect', window ,white, blink_left);
    [VBLTimestamp OnSetTime] = Screen('Flip', window, [], 1)
    Screen('FillRect', window ,black, blink_left);
    Screen('Flip', window, OnSetTime+time);
end