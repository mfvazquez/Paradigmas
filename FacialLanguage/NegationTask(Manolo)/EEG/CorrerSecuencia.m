function [exit, stat, log] = CorrerSecuencia(secuencia, entrenamiento, stat)

    global hd
    global ExitKey
    global DOT
    global PREGUNTA
    global TIEMPOS
    global MARCAS
    
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
    for i = 1:largo
        
        if i == DOT.STIM(1)
            [exit, respuesta_dot, log.estimulo{i}] = EstimuloCirculo(secuencia{i}, TIEMPOS.ESTIMULOS{i}, amarillo, MARCAS.ESTIMULOS{i}, entrenamiento);
            if exit
                return
            end
            log.respuesta_amarillo = respuesta_dot.tiempo;
        elseif i == PREGUNTA.STIM;
            pregunta = ['¿' secuencia{4} ' ' secuencia{5} ' ' secuencia{6}(1:end-1) '?'];
            [exit, respuesta, log.estimulo{i}] = EstimuloPregunta(pregunta, TIEMPOS.ESTIMULOS{i}, MARCAS.ESTIMULOS{i}, entrenamiento);
            if exit
                return
            end
                if isempty(respuesta.valor) % Sin respuesta
                    accuracy = 0;
                    marca_enviar = 0;
                elseif strcmp(respuesta.valor,secuencia{3}) % Respuesta Correcta
                    accuracy = 1;
                    marca_enviar = MARCAS.ACIERTO;
                else % Respuesta incorrecta
                    accuracy = -1;
                    marca_enviar = MARCAS.ERROR;
                end
                if ~entrenamiento
                    EnviarMarca(marca_enviar)
                end
                log.respuesta_correcta = secuencia{3};
                log.respuesta_accuracy = accuracy;
                log.respuesta_tiempo = respuesta.tiempo;
                log.respuesta_elegida = respuesta.valor;
                log.secuencia = secuencia(2:6);
            if entrenamiento
                reaction_time = respuesta.tiempo - log.estimulo{PREGUNTA.STIM}{end};
                stat = FeedbackDisplay(accuracy, reaction_time, stat);
            end
        else
            if amarillo && isempty(respuesta_dot.valor) && i >= DOT.STIM(1) && i <= DOT.STIM(1)+1
                [exit, respuesta_dot, log.estimulo{i}] = EstimuloComun(secuencia{i}, TIEMPOS.ESTIMULOS{i}, {DOT}, MARCAS.ESTIMULOS{i}, entrenamiento);
                if exit
                    return
                end
                log.respuesta_amarillo = respuesta_dot.tiempo;
            else
                [exit, ~, log.estimulo{i}] = EstimuloComun(secuencia{i}, TIEMPOS.ESTIMULOS{i}, [], MARCAS.ESTIMULOS{i}, entrenamiento);
                if exit
                    return
                end
            end
        end
        
        Screen('Flip', hd.window);
        if amarillo && isempty(respuesta_dot.valor) && i >= DOT.STIM(1) && i <= DOT.STIM(1)+1
            if ~entrenamiento
                [exit, respuesta_dot] = Esperar(TIEMPOS.BLANCOS{i}, ExitKey, {DOT}, MARCAS.AMARILLO);
            else
                [exit, respuesta_dot] = Esperar(TIEMPOS.BLANCOS{i}, ExitKey, {DOT}, []);
            end
            if exit
                return
            end
            log.respuesta_amarillo = respuesta_dot.tiempo;
        else
            [exit, ~] = Esperar(TIEMPOS.BLANCOS{i}, ExitKey, [], []);
            if exit 
                return
            end
        end
    end
    
    if isfield(log,'respuesta_tiempo')
        log.pregunta_reaction_time =  log.respuesta_tiempo - log.estimulo{PREGUNTA.STIM}{end};
    end
    
    if amarillo && isfield(log,'respuesta_amarillo')
        log.amarillo_reaction_time = log.respuesta_amarillo - log.estimulo{DOT.STIM(1)}{DOT.STIM(2)};
    end

end