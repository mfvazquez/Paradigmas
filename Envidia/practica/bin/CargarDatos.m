function bloque = CargarDatos(path)

    bloque.instrucciones = fileread(fullfile(path,'instrucciones.txt'));

    situaciones_path = fullfile(path,'situaciones');
    archivos = dir(situaciones_path);
    archivos = {archivos.name};
    archivos(1) = [];
    archivos(1) = [];
    archivos = natsort(archivos);

    bloque.situaciones = cell(1, length(archivos));
    for i = 1:length(archivos)
        archivo = archivos{i};
        situacion.personaje = archivo(end-4);
        situacion.texto = fileread(fullfile(situaciones_path, archivo));
        bloque.situaciones{1,i} = situacion;
    end

end