function dibujarOpciones(elegido, textos, cursor)

    global hd;

    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);
    [xCenter, yCenter] = RectCenter(hd.scrnsize);
    
    xLength = round(screenXpixels * 0.5); % ancho del rectangulo
    yLength = round(screenYpixels * 0.1); % alto del rectangulo
    xPos = xCenter - round(xLength/2); %posicion X del rectangulo
    yPos = yCenter - round(yLength); %posicion Y del rectangulo
    BoxXLength = round(xLength/9); % ancho de cada cajita

   % ---------- TEXTOS -------------------------------------
   
    textYpos = yPos - yLength;
    
    textSize = round(yLength*0.75);
    Screen('TextSize', hd.window, textSize);
    rectText = [0  round(textYpos/2) screenXpixels textYpos];
    DrawFormattedText(hd.window, textos.pregunta, 'center', 'center', hd.white, [],[],[], 2,[],rectText);

    if cursor
    
    % ------------------------ OPCIONES -----------------------------------

        textSize = round(yLength*0.6);
        Screen('TextSize', hd.window, textSize);

        rectText = [xPos  textYpos BoxXLength+xPos textYpos+yLength];
        DrawFormattedText(hd.window, textos.minimo, 'center', 'center', hd.white, [],[],[],[],[],rectText);

        rectText = [xPos+BoxXLength*4  textYpos BoxXLength*5+xPos textYpos+yLength];
        DrawFormattedText(hd.window, textos.medio, 'center', 'center', hd.white, [],[],[],[],[],rectText);

        rectText = [xPos+BoxXLength*8  textYpos BoxXLength*9+xPos textYpos+yLength];
        DrawFormattedText(hd.window, textos.maximo, 'center', 'center', hd.white, [],[],[],[],[],rectText);

        % ------------------------ CURSOR -------------------------------------

        textSize = round(yLength*0.6);
        Screen('TextSize', hd.window, textSize);
        centro = round(yPos + yLength/2);
%         corrimiento = round(textSize * 0.5);
        corrimiento = 0;
        for n = 1:9
            rectSel = [xPos+BoxXLength*(n-1)  yPos BoxXLength*n+xPos yLength+yPos];
            textRec = [xPos+BoxXLength*(n-1)  centro-round(textSize/2)-corrimiento BoxXLength*n+xPos centro+round(textSize/2)];
            if n == elegido
                Screen('FillRect', hd.window, hd.red, rectSel);
            else
                Screen('FillRect', hd.window, hd.white, rectSel);
            end
            DrawFormattedText(hd.window, int2str(n), 'center','center', hd.black, [],[],[],[],[], textRec);
        end
    else
        MENSAJE_CONTINUAR = 'Presione la barra espaciadora cuando termine de leer';
        MensajeContinuar(MENSAJE_CONTINUAR)    
    end
end

