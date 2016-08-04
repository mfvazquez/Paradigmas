function bloque = CargarBloque(direccion, archivo)
    archivo = fullfile(direccion,archivo);
    bloque = textread(archivo, '%s', 'whitespace',char(10));
    for i = 1:length(bloque)
        bloque{i} = strsplit(bloque{i},',');
    end
end