function datos = ExtraerDatosDeLog(log, estimulos, perfiles, seleccionado)

    datos = {};

    for i = 1:length(log.estimulo_inicio)
        
        if ~isempty(perfiles) && perfiles(i) ~= seleccionado
            continue
        end
        
        total.onset_lectura = log.estimulo_inicio{i};
        total.duraciones_lectura = log.estimulo_fin{i} - log.estimulo_inicio{i};
        total.onset_fijacion = log.estimulo_fin{i};
        total.duracion_fijacion = log.opciones_inicio{i} - log.estimulo_fin{i};
        total.onset_opciones = log.opciones_inicio{i};
        total.duracion_opciones = log.opciones_fin{i} - log.opciones_inicio{i};
        total.respuesta = log.respuesta{i};
        
        actual.total = total;
        
        if strcmp(estimulos{i}, 'merecimiento')
            actual.merecimiento = total;
        elseif strcmp(estimulos{i}, 'neutral')
            actual.neutral = total;
        elseif strcmp(estimulos{i}, 'legal')
            actual.legal = total;
        elseif strcmp(estimulos{i}, 'moral')
            actual.moral = total;
        end
                
        datos = [datos actual];
        
    end
    

end