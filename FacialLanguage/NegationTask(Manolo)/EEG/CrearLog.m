function log = CrearLog(bloques)
    log = cell(1,length(bloques));
    for x = 1:length(log)
        log{x} = cell(1,length(bloques{x}));
    end
end