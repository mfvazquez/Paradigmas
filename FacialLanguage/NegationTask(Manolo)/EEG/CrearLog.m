function log = CrearLog(bloques, T_ESTIMULOS)
    log = cell(1,length(bloques));
    for k = 1:length(log)
        log{k} = cell(1,length(bloques{k}));
        for i = 1:length(log{k})
            aux.estimulo = cell(1,length(T_ESTIMULOS));
            aux.respuesta.tiempo = [];
            aux.respuesta.accuracy = [];
            aux.amarillo.absoluto = [];
            aux.amarillo.relativo = [];
            aux.secuencia = [];
            log{k}{i} = aux;
            for j = 1:length(log{k}{i}.estimulo)
                log{k}{i}.estimulo{j} = cell(1,length(T_ESTIMULOS{j}));
            end
        end
    end
end