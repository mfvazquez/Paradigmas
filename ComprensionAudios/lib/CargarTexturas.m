function texturas = CargarTexturas(directorio, nombres_texturas, window)

    texturas = cell(length(nombres_texturas),1);
    for x = 1:length(texturas)
        archivo = fullfile(directorio, nombres_texturas{x});
        texturas{x} = CargarTextura(archivo, window);
    end

end