function GuardarLog(log, nombre, version, trigger_time)

    log_dir = fullfile('..', 'log');
    
    if (~exist(log_dir ,'dir')) 
        mkdir(log_dir);
    end
    
    continuar = true;
    contador = 0;
    while continuar
        contador = contador + 1;
        nombre_archivo = [nombre '_' version '_v' int2str(contador) '_' date '.mat'];
        log_file = fullfile(log_dir, nombre_archivo);
        if (~exist(log_file ,'file')) 
            continuar = false;
        end
       
    end
    
    save(log_file, 'log', 'trigger_time');

end