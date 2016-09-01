function OnSetTime = blink()
    global hd;
    [~, OnSetTime] = Screen('Flip', hd.window);
end