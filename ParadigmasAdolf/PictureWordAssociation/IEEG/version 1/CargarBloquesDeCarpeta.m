function bloques = CargarBloquesDeCarpeta(carpeta)

    archivos = ArchivosDeCarpeta(carpeta);
    bloques = cell(1,length(archivos));
    for i = 1:length(archivos)
        archivo_direccion = fullfile(carpeta, archivos{i});
        bloques{i} = CargarBloque(archivo_direccion);
    end

end