function celda_log = Log2Excel(carpeta_origen, carpeta_destino)

    archivos = dir(carpeta_origen);
    archivos(1) = [];
    archivos(1) = [];

    for i = 1:length(archivos)
        
        archivo_nombre = archivos(i).name;
        variables = load(fullfile(carpeta_origen,archivo_nombre));
        log = variables.log;
        celda_log = cell(length(log), 1);
        for j = 1:length(log)
            celda_log{j} = Log2Cell(log{j});
        end
        
        GuardarExcel(celda_log, archivo_nombre, carpeta_destino);
        
    end

    
    
end