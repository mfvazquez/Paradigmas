function archivos = ArchivosDeCarpeta(direccion)
    archivos_struct = dir(direccion);
    archivos_struct(1) = [];
    archivos_struct(1) = [];
    
    archivos = cell(1,length(archivos_struct));
    for i = 1:length(archivos)
       
        archivos{i} = archivos_struct(i).name;
        
    end
    archivos = natsort(archivos);
    
end