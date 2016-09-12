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
            log_trial.categoria = bloque{i,2};
            log_trial.tag = bloque{i,3};
            log_trial.respuesta_correcta = bloque{i,4};

            if log_trial.respuesta ~= 0
                if strcmp(log_trial.respuesta, log_trial.respuesta_correcta)
                    log_trial.accuracy = 1;
                else
                    log_trial.accuracy = 0;
                end
            end
            log{i,1} = log_trial;
        end

    end
    
end