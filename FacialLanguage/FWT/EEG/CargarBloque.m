function bloque = CargarBloque(path, name)

    % Creo el mapa para identificar las marcas de los codigos
    fileID = fopen(fullfile('data','codigos.csv'));
    linea = textscan(fileID,'%s %f\n', 'Delimiter',',');
    n = 1;
    while ~isempty(linea{1})
        codigos{n} = linea{1}{1};
        marcas{n} = linea{2};
        n = n + 1;
        linea = textscan(fileID,'%s %f\n', 'Delimiter',',');
    end
    codigos{n} = '-';
    marcas{n} = -1;

    fclose(fileID);

    map = containers.Map(codigos, marcas);

    file = fullfile(path,name);
    fid = fopen(file);

    tline = fgets(fid);
    n = 1;
    while ischar(tline)       
        linea = strsplit(tline, ';');
        bloque.categoria{n} = linea{1};
        bloque.palabra{n} = lower(linea{2});
        bloque.codigo{n} = linea{3};
        bloque.marca{n} = map(linea{3});
        tline = fgets(fid);
        n = n + 1;
    end

    fclose(fid);
   
end