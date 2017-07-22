function EmocionesInstrucciones(instrucciones, TAMANIO_INSTRUCCIONES, texto_botones, hd)
   
    TextoCentrado(instrucciones, TAMANIO_INSTRUCCIONES, hd);  
    
    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);

    ANCHO = screenXpixels * 0.1;
    ALTO = screenYpixels * 0.05;

    tamanio_texto = round(screenYpixels*TAMANIO_INSTRUCCIONES); 
    tamanio_tecla = round(ALTO);
    
    diferencia_texto = [0 tamanio_texto+tamanio_tecla 0 tamanio_texto+tamanio_tecla];
    
    %% PARTE IZQUIERDA
    
    Xpos = round(screenXpixels/4- ANCHO/2);
    Ypos = round(screenYpixels*5/8 - ALTO/2);
    
    rect = [Xpos  Ypos Xpos+ANCHO Ypos+ALTO]; 
    
    % TECLA
    Screen('TextSize', hd.window, tamanio_tecla);
    DrawFormattedText(hd.window, texto_botones{2,1}, 'center','center', hd.white, [],[],[],2,[],rect);      
    
    % TEXTO SOBRE LA TECLA
    rect = rect - diferencia_texto;
    Screen('TextSize', hd.window, tamanio_texto);
    DrawFormattedText(hd.window, texto_botones{1,1}, 'center','center', hd.white, [],[],[],2,[],rect);    
    
      
    %% PARTE DERECHA
    
    Xpos = round(screenXpixels*3/4 - ANCHO/2);
    Ypos = round(screenYpixels*5/8 - ALTO/2);
    
    rect = [Xpos  Ypos Xpos+ANCHO Ypos+ALTO];
    
    % TECLA0
    Screen('TextSize', hd.window, tamanio_tecla);
    DrawFormattedText(hd.window, texto_botones{2,3}, 'center','center', hd.white, [],[],[],2,[],rect);      
    
    % TEXTO SOBRE LA TECLA
    rect = rect - diferencia_texto;
    Screen('TextSize', hd.window, tamanio_texto);
    DrawFormattedText(hd.window, texto_botones{1,3}, 'center','center', hd.white, [],[],[],2,[],rect);    
    
    
    %% PARTE DEL MEDIO
    Xpos = round(screenXpixels/2 - ANCHO/2);
    Ypos = round(screenYpixels*5/8 - ALTO/2);
    
    rect = [Xpos  Ypos Xpos+ANCHO Ypos+ALTO];
    
    % TECLA0
    Screen('TextSize', hd.window, tamanio_tecla);
    DrawFormattedText(hd.window, texto_botones{2,2}, 'center','center', hd.white, [],[],[],2,[],rect);      
    
    % TEXTO SOBRE LA TECLA
    rect = rect - diferencia_texto;
    Screen('TextSize', hd.window, tamanio_texto);
    DrawFormattedText(hd.window, texto_botones{1,2}, 'center','center', hd.white, [],[],[],2,[],rect);    
    
end