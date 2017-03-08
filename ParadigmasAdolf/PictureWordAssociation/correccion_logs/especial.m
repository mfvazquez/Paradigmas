archivo = 'PictureWordAssociation_NestorAgüero_15-Sep-2016_v1.mat';
log_actual = load(archivo);
log_actual = log_actual.log;
log = log_actual;

trial = log_actual{2}{1};
trial.estimulo = 'dormir';
trial.codigo = 'Acc_baja_corr';
trial.respuesta_correcta = 'Si';
log_actual{2}{1} = trial;

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

    if isfield(trial, 'respuesta')
        trial.accuracy = 0;
        if strcmp(trial.respuesta_correcta, trial.respuesta)
            trial.accuracy = 1;
        end
    end

    log{2}{y} = trial;

end

save(fullfile('corregidos', archivo), 'log');

