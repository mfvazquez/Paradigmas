function textura = CargarTextura(direccion)

    global hd

    imagen = imread(direccion);
    textura = Screen('MakeTexture', hd.window, imagen);

end