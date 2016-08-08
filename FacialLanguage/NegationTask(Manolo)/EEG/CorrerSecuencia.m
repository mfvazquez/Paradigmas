function [exit, accuracy, stat, log] = CorrerSecuencia(secuencia, entrenamiento, stat, log)

    global hd
    global ExitKey
    global DOT
    global PREGUNTA
    global TIEMPOS
    global MARCAS
    global pportobj pportaddr
    
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
    for i = 1:largo
        
        if i == DOT.STIM(1)
            [exit, respuesta_dot, log.estimulo{i}] = EstimuloCirculo(secuencia{i}, TIEMPOS.ESTIMULOS{i}, amarillo, log.estimulo{i}, MARCAS.ESTIMULOS{i}, entrenamiento);
            if exit
                return
            end
            log.amarillo.absoluto = respuesta_dot.tiempo;
        elseif i == PREGUNTA.STIM;
            [exit, respuesta, log.estimulo{i}] = EstimuloPregunta(secuencia{i}, TIEMPOS.ESTIMULOS{i}, log.estimulo{i}, MARCAS.ESTIMULOS{i}, entrenamiento);
            if exit
                return
            end
                if isempty(respuesta.valor) % Sin respuesta
                    accuracy = 0;
                    marca_enviar = 0;
                elseif respuesta.valor == secuencia{end-1} % Respuesta Correcta
                    accuracy = 1;
                    marca_enviar = MARCAS.ACIERTO;
                else % Respuesta incorrecta
                    accuracy = -1;
                    marca_enviar = MARCAS.ERROR;
                end
                if ~entrenamiento
                    io32(pportobj,pportaddr, marca_enviar);
                    WaitSecs(MARCAS.DURACION);
                    io32(pportobj,pportaddr,0);
                end

                log.respuesta.accuracy = accuracy;
                log.respuesta.tiempo = respuesta.tiempo;
            if entrenamiento
                reaction_time = respuesta.tiempo - log.estimulo{PREGUNTA.STIM}{2};
                stat = FeedbackDisplay(accuracy, reaction_time, stat);
            end
        else
            if amarillo && isempty(respuesta_dot.valor) && i >= DOT.STIM(1) && i <= DOT.STIM(1)+1
                [exit, respuesta_dot, log.estimulo{i}] = EstimuloComun(secuencia{i}, TIEMPOS.ESTIMULOS{i}, {DOT}, MARCAS.ESTIMULOS{i}, entrenamiento);
                if exit
                    return
                end
                log.amarillo.absoluto = respuesta_dot.tiempo;
            else
                [exit, ~, log.estimulo{i}{1}] = EstimuloComun(secuencia{i}, TIEMPOS.ESTIMULOS{i}, [], MARCAS.ESTIMULOS{i}, entrenamiento);
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
            log.amarillo.absoluto = respuesta_dot.tiempo;
        else
            [exit, ~] = Esperar(TIEMPOS.BLANCOS{i}, ExitKey, [], []);
            if exit 
                return
            end
        end
    end

end