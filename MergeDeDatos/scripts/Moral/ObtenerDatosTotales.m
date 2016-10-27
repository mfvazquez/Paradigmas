function datos_totales = ObtenerDatosTotales(pacientes, dir)

    ACCIDENTAL = 0;
    INTENCIONAL = 1;

    for i = 1:length(pacientes)
        actual = pacientes(i);
        datos.nombre = actual.nombre;

        log_actual = load(fullfile(dir, actual.archivo));
        log_actual = log_actual.log;
        datos.version = log_actual.version;
        datos.estimulos_version = EstimulosVersion(datos.version);
        
        datos.accidental = ExtraerDatos(log_actual, datos.estimulos_version, ACCIDENTAL);
        datos.intencional = ExtraerDatos(log_actual, datos.estimulos_version, INTENCIONAL);
        datos.totales = ExtraerDatos(log_actual, [], []);

        datos_totales(i) = datos;

    end

end