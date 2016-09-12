function [exit, log] = CorrerBloque(bloque, auxiliar, log)

    global AfirmativeKey
	global NegativeKey
    
    botones = {AfirmativeKey NegativeKey};
    respuestas = {'Si' 'No'};

    exit = false;
    
    for i = 1:length(bloque)
   
        palabra = bloque{i,1};
        [exit, log_trial] = CorrerTrial(palabra, auxiliar, botones, respuestas);
        if exit
            return
        end
        
        if nargin == 3
        
            log_trial.palabra = palabra;
            log_trial.codigo = bloque{i,2};
            log_trial.trial2 = bloque{i,3};

            if strcmp(log_trial.respuesta, 'Si') && log_trial.codigo(1) ~= 'n'
                log_trial.accuracy = 1;
            elseif strcmp(log_trial.respuesta, 'Si') && log_trial.codigo(1) == 'n'
                log_trial.accuracy = 0;
            elseif strcmp(log_trial.respuesta, 'No') && log_trial.codigo(1) ~= 'n'
                log_trial.accuracy = 0;
            elseif strcmp(log_trial.respuesta, 'No') && log_trial.codigo(1) == 'n'
                log_trial.accuracy = 1;
            end
            log{i,1} = log_trial;    
        end

    end
    
end