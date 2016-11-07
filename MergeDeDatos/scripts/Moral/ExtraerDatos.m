function datos = ExtraerDatos(log, estimulos, abilitados, referencia)
 
    n = 0;
    for i = 1:length(log.historia_inicio)
        
        if ~isempty(estimulos) && estimulos(i) ~= abilitados 
            continue
        end
        n = n+1;
       
        
        datos.onset_lectura{n} = log.historia_inicio{i} - referencia;        
        datos.duracion_lectura{n} = log.historia_fin{i} - log.historia_inicio{i};
        datos.onset_fijacion{n} = log.historia_fin{i} - referencia;
        datos.duracion_fijacion{n} = log.respuesta_inicio{i} - log.historia_fin{i};
        datos.onset_opciones{n} = log.respuesta_inicio{i} - referencia;
        datos.duracion_opciones{n} = log.respuesta_fin{i} - log.respuesta_inicio{i};
        datos.respuestas{n} = log.respuestas{i};   
        datos.estimulo{n} = i;
        
    end
        
end