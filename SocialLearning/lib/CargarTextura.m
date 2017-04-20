function textura = CargarTextura(direccion, window)

    imagen = imread(direccion);
    textura.puntero = Screen('MakeTexture', window, imagen);
    textura.alto = size(imagen, 1);
    textura.ancho = size(imagen, 2);

end