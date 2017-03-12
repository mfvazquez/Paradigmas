function DibujarCuadradoNegro()
    global hd
    pdpix=[200 75];
    blink_left=[0 0 pdpix];
    Screen('FillRect', hd.window ,hd.black, blink_left);
end