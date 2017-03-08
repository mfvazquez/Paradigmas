logs_viejos = ArchivosDeCarpeta('logs');

for x = 1:length(logs_viejos)
    archivo = logs_viejos{x};
    log_actual = load(fullfile('logs',archivo));
    log_actual = log_actual.log;
    log = log_actual;
    
    for y = 1:length(log_actual{2})
    
        trial = log_actual{2}{y};
        
        trial_correcto = y - 3;
        if trial_correcto < 1
            trial_correcto = trial_correcto + length(log_actual{2});
        end

        trial_correcto = log_actual{2}{trial_correcto};       
        trial.estimulo = trial_correcto.estimulo;
        trial.codigo = trial_correcto.codigo;
        trial.respuesta_correcta = trial_correcto.respuesta_correcta;
        
        trial.accuracy = 0;
        if strcmp(trial.respuesta_correcta, trial.respuesta)
            trial.accuracy = 1;
        end
        
        trial.accuracy
        
        log{2}{y} = trial;
        
    end
    
    save(fullfile('corregidos', archivo), 'log');
    
end