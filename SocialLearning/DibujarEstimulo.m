function DibujarEstimulo(hd, textura, textos)

    [screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);

    TEXTOS_PROPORCION = [10 10]; % tamaño de los textos respecto a las dimensiones de la ventana
    DISTANCIA_PROPORCION = [20 15]; % tamaño de las distancias entre textos e imagenes respecto a la ventana
    PROPORCION_MARGEN = [5 4]; % tamaño de los margenes de la ventana respecto a su tamaño

    textos_dimensiones = [round(screenXpixels/TEXTOS_PROPORCION(1)) round(screenYpixels/TEXTOS_PROPORCION(2))];
    distancias = [round(screenXpixels/DISTANCIA_PROPORCION(1)) round(screenYpixels/DISTANCIA_PROPORCION(2))];
    margenes = [round(screenXpixels/PROPORCION_MARGEN(1)) round(screenYpixels/PROPORCION_MARGEN(2))];

    % IMAGEN
    Xpos = round((screenXpixels-textura.ancho)/2);
    rect_imagen = [Xpos margenes(2) Xpos+textura.ancho margenes(2)+textura.alto];
    DibujarTextura(textura, hd.window, rect_imagen);


    % CARACTER IZQUIERDO
    Xpos = rect_imagen(1) - distancias(1) - textos_dimensiones(1);
    Ypos = round((rect_imagen(4) + rect_imagen(2) - textos_dimensiones(2)) / 2);
    rect_texto = [Xpos  Ypos Xpos+textos_dimensiones(1) Ypos+textos_dimensiones(2)];
    Texto(textos.izquierda, rect_texto, hd);

    % CARACTER DERECHO
    Xpos = rect_imagen(3) + distancias(1);
    Ypos = round((rect_imagen(4) + rect_imagen(2) - textos_dimensiones(2)) / 2);
    rect_texto = [Xpos  Ypos Xpos+textos_dimensiones(1) Ypos+textos_dimensiones(2)];
    Texto(textos.derecha, rect_texto, hd);

    % NUMERO INFERIOR
    Xpos = rect_imagen(1);
    Ypos = rect_imagen(4) + distancias(2);
    rect_texto = [Xpos  Ypos rect_imagen(3) Ypos+textos_dimensiones(2)];
    Texto(textos.inferior, rect_texto, hd);

end