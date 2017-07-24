function bloques = CargarBloques(carpeta)

    carpetas_bloques = ArchivosDeCarpeta(carpeta);
    
    bloques = cell(length(carpetas_bloques),1);
    
    for x = 1:length(carpetas_bloques)
        carpeta_actual = fullfile(carpeta,carpetas_bloques{x});
        bloques{x} = CargarBloqueIndividual(carpeta_actual);    
    end


end