function datos_totales = MergearDatos(dir, pacientes)

    for i = 1:length(pacientes)

        actual = pacientes(i);
        datos.nombre = actual.nombre;
        datos.version = version;
        log_actual = load(fullfile(dir, actual.archivo));
        log_actual = log_actual.log;
        datos.onset_lectura = cell2mat(log_actual.historia_inicio);
        datos.duracion_lectura = cell2mat(log_actual.historia_fin) - cell2mat(log_actual.historia_inicio);
        datos.onset_fijacion = cell2mat(log_actual.historia_fin);
        datos.duracion_fijacion = cell2mat(log_actual.respuesta_inicio) - cell2mat(log_actual.historia_fin);
        datos.onset_opciones = cell2mat(log_actual.respuesta_inicio);
        datos.duracion_opciones = cell2mat(log_actual.respuesta_fin) - cell2mat(log_actual.respuesta_inicio);
        datos.respuestas = cell2mat(log_actual.respuestas);

        datos_totales(i) = datos;

    end
end