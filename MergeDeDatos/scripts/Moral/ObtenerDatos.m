function [version, nombre] = ObtenerDatos(nombre_archivo)
    
    componentes_archivo = strsplit(nombre_archivo,'_');
    version = componentes_archivo{2};
    nombre = componentes_archivo{1};
end