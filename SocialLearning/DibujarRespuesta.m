function DibujarRespuesta(hd, texturas, textos)

global PROPORCION_MARGEN

[screenXpixels, screenYpixels] = Screen('WindowSize', hd.window);

TEXTOS_PROPORCION = [15 15]; % tamaño de los textos respecto a las dimensiones de la ventana

textos_dimensiones = [round(screenXpixels/TEXTOS_PROPORCION(1)) round(screenYpixels/TEXTOS_PROPORCION(2))];
margenes = [round(screenXpixels/PROPORCION_MARGEN(1)) round(screenYpixels/PROPORCION_MARGEN(2))];

% IMAGEN IZQUIERDA
Xpos = margenes(1);
Ypos = screenYpixels - margenes(2) - texturas.izquierda.alto;
rect_imagen = [Xpos Ypos Xpos+texturas.izquierda.ancho Ypos+texturas.izquierda.alto];
DibujarTextura(texturas.izquierda, hd.window, rect_imagen);

% TEXTO IZQUIERDA
Ypos = margenes(2);
rect_texto = [rect_imagen(1) Ypos rect_imagen(3) Ypos+textos_dimensiones(2)];
Texto(textos.izquierda, rect_texto, hd);

% IMAGEN DERECHA
Xpos = screenXpixels - margenes(1) - texturas.derecha.ancho;
Ypos = screenYpixels - margenes(2) - texturas.derecha.alto;
rect_imagen = [Xpos Ypos Xpos+texturas.derecha.ancho Ypos+texturas.derecha.alto];
DibujarTextura(texturas.derecha, hd.window, rect_imagen);

%TEXTO DERECHA
Ypos = margenes(2);
rect_texto = [rect_imagen(1) Ypos rect_imagen(3) Ypos+textos_dimensiones(2)];
Texto(textos.derecha, rect_texto, hd);


end