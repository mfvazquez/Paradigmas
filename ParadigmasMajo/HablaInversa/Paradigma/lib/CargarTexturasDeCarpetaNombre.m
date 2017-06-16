function texturas = CargarTexturasDeCarpetaNombre(carpeta, window)

    archivos_imagenes = ArchivosDeCarpeta(carpeta);
    
    for i = 1:length(archivos_imagenes)
        texturas.(archivos_imagenes{i}(1:end-4)) = CargarTextura(fullfile(carpeta,archivos_imagenes{i}), window);
    end

end