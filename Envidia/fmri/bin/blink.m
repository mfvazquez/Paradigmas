function OnSetTime = blink()
    global window;
    [~, OnSetTime] = Screen('Flip', window);
end