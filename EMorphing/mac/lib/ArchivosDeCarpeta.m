function archivos = ArchivosDeCarpeta(direccion)
    archivos_struct = dir(direccion);
    
    i = 1;
    while i <= length(archivos_struct)
        if strcmp(archivos_struct(i).name, '.') || strcmp(archivos_struct(i).name, '..')
            archivos_struct(i) = [];
            continue
        end
        i = i+1;
    end
    
    archivos = cell(1,length(archivos_struct));
    for i = 1:length(archivos)
        archivos{i} = archivos_struct(i).name;
    end
    
    archivos = natsort(archivos);
    
end