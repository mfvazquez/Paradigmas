function version = ObtenerVersion(archivo)

    componentes = strsplit(archivo,'_');
    version = componentes{end-1};


end