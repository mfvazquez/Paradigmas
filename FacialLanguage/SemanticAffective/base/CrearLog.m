function log = CrearLog(bloques)
    log = cell(1,length(bloques));
    for k = 1:length(log)
        log{k} = cell(1,length(bloques{k}));
        for i = 1:length(log{k})
            aux.prime = [];
            aux.target = [];
            aux.accuracy = [];
            aux.secuencia = [];
            aux.respuesta = [];
            log{k}{i} = aux;
        end
    end
end