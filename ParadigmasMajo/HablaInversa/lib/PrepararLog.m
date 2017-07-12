function [carpeta_log, log_file] = PrepararLog(log_dir, nombre, paradigma)

    if (~exist(log_dir,'dir')) 
        mkdir(log_dir);
    end

    log_file = [paradigma '_' nombre '_' date '.mat'];
    
    continuar = true;
    contador = 0;
    while continuar
        contador = contador + 1;

        carpeta_log = [nombre '_v' int2str(contador)];
        carpeta_log = fullfile(log_dir, [carpeta_log '_' paradigma]);
        if (~exist(carpeta_log ,'dir'))
            mkdir(carpeta_log);
            continuar = false;
        end

    end
end