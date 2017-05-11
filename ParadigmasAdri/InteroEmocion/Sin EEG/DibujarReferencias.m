function DibujarReferencias(hd, texto_botones, TAMANIO_INSTRUCCIONES)

    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);

    ANCHO = screenXpixels * 0.1;
    ALTO = screenYpixels * 0.05;

    tamanio_texto = round(screenYpixels*TAMANIO_INSTRUCCIONES); 
    Screen('TextSize', hd.window, tamanio_texto);
    
    
    Ypos = round(screenYpixels*9/10 - ALTO/2);

    %% PARTE IZQUIERDA
    
    Xpos = round(screenXpixels/6- ANCHO/2);
    rect = [Xpos  Ypos Xpos+ANCHO Ypos+ALTO]; 
    
    
    % TEXTO SOBRE LA TECLA
    DrawFormattedText(hd.window, texto_botones{1,1}, 'center','center', hd.white, [],[],[],2,[],rect);    
    
      
    %% PARTE DERECHA
    
    Xpos = round(screenXpixels*5/6 - ANCHO/2);  
    rect = [Xpos  Ypos Xpos+ANCHO Ypos+ALTO];
    
    % TEXTO SOBRE LA TECLA
    DrawFormattedText(hd.window, texto_botones{1,3}, 'center','center', hd.white, [],[],[],2,[],rect);    
    
    
    %% PARTE DEL MEDIO
    Xpos = round(screenXpixels/2 - ANCHO/2);
    rect = [Xpos  Ypos Xpos+ANCHO Ypos+ALTO];
      
    % TEXTO SOBRE LA TECLA
    DrawFormattedText(hd.window, texto_botones{1,2}, 'center','center', hd.white, [],[],[],2,[],rect);    

end