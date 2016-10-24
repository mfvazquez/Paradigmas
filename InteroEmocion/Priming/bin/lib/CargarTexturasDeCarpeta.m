function texturas = CargarTexturasDeCarpeta(carpeta)

    archivos_imagenes = ArchivosDeCarpeta(carpeta);
    
    texturas = cell(1,length(archivos_imagenes));
    for i = 1:length(texturas)
        texturas{i} = CargarTextura(fullfile(carpeta,archivos_imagenes{i}));
    end

end