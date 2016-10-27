function datos = OrganizarDatos(archivos)

    for i = 1:length(archivos)

        actual.archivo = archivos{i};
        [~, actual.nombre] = ObtenerDatos(actual.archivo);
        datos(i) = actual;

    end
end