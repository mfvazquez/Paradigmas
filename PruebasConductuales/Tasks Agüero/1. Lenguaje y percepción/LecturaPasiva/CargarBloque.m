function bloque = CargarBloque(archivo)
    fid = fopen(archivo);    
    datos = textscan(fid,'%s');
    datos = datos{1};
    fclose(fid);
    
    linea = strsplit(datos{1}, ',');
    dimension(1) = length(datos);
    [~ , dimension(2)] = size(linea);
    
    bloque = cell(dimension);
    
    for i = 1:dimension(1)
        linea = strsplit(datos{i}, ',');
        
        for j = 1:dimension(2)
            bloque{i,j} = linea{j};
        end
        
    end
    
end