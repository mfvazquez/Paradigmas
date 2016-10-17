function decodificado = Decodificar(codificado, map, directorio)

    decodificado = cell(length(codificado),1);

    for y = 1:length(codificado)

        decodificado{y} = map(codificado{y});
        
    end

end