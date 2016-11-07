function datos = AgregarDatos(log, referencia, i, datos)

    datos.onset_lectura{end+1} = log.estimulo_inicio{i} - referencia;
    datos.duraciones_lectura{end+1} = log.estimulo_fin{i} - log.estimulo_inicio{i};
    datos.onset_fijacion{end+1} = log.estimulo_fin{i} - referencia;
    datos.duracion_fijacion{end+1} = log.opciones_inicio{i} - log.estimulo_fin{i};
    datos.onset_opciones{end+1} = log.opciones_inicio{i} - referencia;
    datos.duracion_opciones{end+1} = log.opciones_fin{i} - log.opciones_inicio{i};
    datos.respuesta{end+1} = log.respuesta{i};

end