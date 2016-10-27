function datos = ExtraerDatos(log, estimulos, abilitados)
 
    datos = [];

    for i = 1:length(log.historia_inicio)
        
        if ~isempty(estimulos) && estimulos(i) ~= abilitados
            continue
        end

        actual.onset_lectura = log.historia_inicio{i};
        actual.duracion_lectura = log.historia_fin{i} - log.historia_inicio{i};
        actual.onset_fijacion = log.historia_fin{i};
        actual.duracion_fijacion = log.respuesta_inicio{i} - log.historia_fin{i};
        actual.onset_opciones = log.respuesta_inicio{i};
        actual.duracion_opciones = log.respuesta_fin{i} - log.respuesta_inicio{i};
        actual.respuestas = log.respuestas{i};   
        actual.estimulo = i;
        
        datos = [datos actual];

    end
        
end