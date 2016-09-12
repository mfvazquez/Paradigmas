function [exit, log] = CorrerBloque(bloque, auxiliar, pregunta, log)

    global AfirmativeKey
	global NegativeKey
    
    botones = {AfirmativeKey NegativeKey};
    respuestas = {'Si' 'No'};

    exit = false;
    
    for i = 1:length(bloque)
   
        palabra = bloque{i,1};
        if strcmp(bloque{i, end}, '-')
            [exit, log_trial] = CorrerTrial(palabra, auxiliar, botones, respuestas);
        else
            [exit, log_trial] = CorrerTrial(palabra, auxiliar, botones, respuestas, pregunta);
        end
            
        if exit
            return
        end
        
        if nargin == 4
        
        log_trial.palabra = palabra;
        log_trial.codigo = bloque{i,2};
        log_trial.trial2 = bloque{i,3};

            log_trial.respuesta_correcta = bloque{i,end};
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