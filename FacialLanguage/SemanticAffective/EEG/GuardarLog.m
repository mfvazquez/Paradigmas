function GuardarLog(log, nombre, log_folder, paradigma, nombre_variable)

    if (~exist(log_folder,'dir')) 
        mkdir(log_folder);
    end

    continuar = true;
    contador = 0;
    while continuar
        contador = contador + 1;
        nombre_archivo = [paradigma '_' nombre_variable '_' nombre '_' date '_' version '_v' int2str(contador)];

        log_file = fullfile(log_folder, [nombre_archivo '.mat']);
        if (~exist(log_file ,'file'))
            continuar = false;
        end

    end

    save(log_file, 'log');
    
end