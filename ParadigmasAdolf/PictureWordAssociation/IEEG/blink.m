function OnSetTime = blink()

    global hd
    global BLINK_DURATION
    
    pdpix=[200 75];
    blink_left=[0 0 pdpix];

    Screen('FillRect', hd.window ,hd.white, blink_left);
    [~, OnSetTime] = Screen('Flip', hd.window, [], 1);
    Screen('FillRect', hd.window , hd.black, blink_left);
    Screen('Flip', hd.window, OnSetTime+BLINK_DURATION);
end