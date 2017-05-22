function [categorias ubicaciones] = ObtenerCategorias(carpeta)
    carpetas = ArchivosDeCarpeta(carpeta);
    categorias = {};
    ubicaciones = {};
    for x = 1:length(carpetas)
        subcarpetas = ArchivosDeCarpeta(fullfile(carpeta, carpetas{x}));
        for y = 1:length(subcarpetas)
            ubicaciones = {ubicaciones{:} fullfile(carpeta, carpetas{x}, subcarpetas{y})};
            categorias = {categorias{:} [carpetas{x} subcarpetas{y}]}; 
        end
    end
end