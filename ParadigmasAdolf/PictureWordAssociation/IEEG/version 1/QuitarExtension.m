function archivos_imagenes = QuitarExtension(archivos_imagenes)

for x = 1:length(archivos_imagenes)

    aux = archivos_imagenes{x};
    aux = aux(1:end-4);
    archivos_imagenes{x} = lower(aux);

end
end