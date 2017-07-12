function GuardarPantalla(hd)

    global numero_imagen
    
    image =Screen('GetImage', hd.window);
    imwrite(image,[int2str(numero_imagen) '.jpg']);
    numero_imagen = numero_imagen + 1;

end