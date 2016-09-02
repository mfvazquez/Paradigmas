function [exit, accuracy, stat, log] = CorrerSecuencia(secuencia, entrenamiento, stat, log)

    global hd
    global ExitKey
    global DOT
    global PREGUNTA
    global TIEMPOS
    
    accuracy = 0;
    exit = false;

    % SIN PREGUNTA
    largo = length(secuencia) - 2;
    if secuencia{end-1} == '-'
        largo = largo - 1;
    end
    
    % DEFINO EL COLOR DEL CIRCULO
    amarillo = false;
    if secuencia{end} == 'l'
        amarillo = true;
    end

    respuesta_dot.valor = '';
    respuesta_dot.tiempo = NaN;
    
    
    %% FIJACION
    [exit, ~, log.estimulo{1}{1}] = EstimuloComun(secuencia{1}, TIEMPOS.ESTIMULOS{1}, [], log.estimulo{1}{1});
    if exit
        return
    end
    
    %% ESTIMULO 1

    [exit, ~, log.estimulo{2}{1}] = EstimuloComun(secuencia{2}, TIEMPOS.ESTIMULOS{2}, [], log.estimulo{2}{1});
    if exit
        return
    end

    %% ESTIMULO 2
    
    [exit, ~, log.estimulo{3}{1}] = EstimuloComun(secuencia{3}, TIEMPOS.ESTIMULOS{3}, [], log.estimulo{3}{1});
    if exit
        return
    end
    
    %% ESTIMULO 3 CON CIRCULO DOT.STIM(1) == 3 + 1
    
    [exit, respuesta_dot, log.estimulo{4}] = EstimuloCirculo(secuencia{4}, TIEMPOS.ESTIMULOS{4}, amarillo, log.estimulo{4});
    if exit
        return
    end
    log.amarillo.absoluto = respuesta_dot.tiempo;
    
    %% ESTIMULO 4
    
    %% ESTIMULO 5
    
    %% PREGUNTA
    
    
    for i = 1:largo
        
        if i == DOT.STIM(1)
            [exit, respuesta_dot, log.estimulo{i}] = EstimuloCirculo(secuencia{i}, TIEMPOS.ESTIMULOS{i}, amarillo, log.estimulo{i});
            if exit
                return
            end
            log.amarillo.absoluto = respuesta_dot.tiempo;

        
        elseif i == PREGUNTA.STIM;
            [exit, respuesta, log.estimulo{i}] = EstimuloPregunta(secuencia{i}, TIEMPOS.ESTIMULOS{i}, log.estimulo{i});
            if exit
                return
            end
                if isempty(respuesta.valor) % Sin respuesta
                    accuracy = 0;
                elseif respuesta.valor == secuencia{end-1} % Respuesta Correcta
                    accuracy = 1;
                else % Respuesta incorrecta
                    accuracy = -1;
                end
                log.respuesta.accuracy = accuracy;
                log.respuesta.tiempo = respuesta.tiempo;
            if entrenamiento
                reaction_time = respuesta.tiempo - log.estimulo{PREGUNTA.STIM}{2};
                stat = FeedbackDisplay(accuracy, reaction_time, stat);
            end
            
            
            
        else
            if amarillo && isempty(respuesta_dot.valor) && i >= DOT.STIM(1) && i <= DOT.STIM(1)+1
                [exit, respuesta_dot, log.estimulo{i}] = EstimuloComun(secuencia{i}, TIEMPOS.ESTIMULOS{i}, {DOT}, log.estimulo{i});
                if exit
                    return
                end
                log.amarillo.absoluto = respuesta_dot.tiempo;
            else
                [exit, ~, log.estimulo{i}{1}] = EstimuloComun(secuencia{i}, TIEMPOS.ESTIMULOS{i}, [], log.estimulo{i}{1});
                if exit
                    return
                end
            end
        end
        
        Screen('Flip', hd.window);
        if amarillo && isempty(respuesta_dot.valor) && i >= DOT.STIM(1) && i <= DOT.STIM(1)+1
            [exit, respuesta_dot] = Esperar(TIEMPOS.BLANCOS{i}, ExitKey, {DOT});
            if exit
                return
            end
            log.amarillo.absoluto = respuesta_dot.tiempo;
        else
            [exit, ~] = Esperar(TIEMPOS.BLANCOS{i}, ExitKey, []);
            if exit 
                return
            end
        end
    end

end