function bloque = CargarBloque(path, name)

    file = fullfile(path,name);
    fid = fopen(file);

    tline = fgets(fid);
    n = 1;
    while ischar(tline)
        linea = strsplit(tline, ';');
        bloque.categoria{n} = linea{1};
        bloque.palabra{n} = linea{2}(1:end-2);
        tline = fgets(fid);
        n = n + 1;
    end

    fclose(fid);
    
end