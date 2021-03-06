function DibujarOpciones(version, distancia)

    global hd;

    rect_der = zeros(1,4);
    rect_izq = zeros(1,4);
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    Ycenter = screenYpixels/2;

    rect_izq(1) = round(screenXpixels*0.2);
    rect_izq(2) = round(Ycenter + distancia * screenYpixels);
    rect_izq(3) = round(screenXpixels*0.3);
    rect_izq(4) = rect_izq(2) + round(distancia*screenYpixels/10);
    
    rect_der(1) = round(screenXpixels*0.7);
    rect_der(2) = rect_izq(2);
    rect_der(3) = round(screenXpixels*0.8);
    rect_der(4) = rect_izq(4);
    
    DrawFormattedText(hd.window, version.IZQ.STR, 'center','center', hd.white, [], [], [], 1.5, [], rect_izq);
    DrawFormattedText(hd.window, version.DER.STR, 'center','center', hd.white, [], [], [], 1.5, [], rect_der);

end