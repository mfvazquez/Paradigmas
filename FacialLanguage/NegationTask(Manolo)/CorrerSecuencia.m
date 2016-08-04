function [exit, accuracy, stat, log] = CorrerSecuencia(secuencia, entrenamiento, stat, log)

    global hd
    global ExitKey
    global DOT
    global PREGUNTA
    global TIEMPOS
    global MARCAS
    
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
            [exit, respuesta_dot] = EstimuloCirculo(secuencia{i}, TIEMPOS.ESTIMULOS{i}, amarillo);
            if exit
                return
            end
        elseif i == PREGUNTA.STIM;
            [exit, respuesta] = EstimuloPregunta(secuencia{i}, TIEMPOS.ESTIMULOS{i});
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
            
            if entrenamiento
                stat = FeedbackDisplay(accuracy, respuesta.tiempo, stat);
            end
        else
            if amarillo && isempty(respuesta_dot.valor) && i >= DOT.STIM(1) && i <= DOT.STIM(1)+1
                [exit, respuesta_dot] = EstimuloComun(secuencia{i}, TIEMPOS.ESTIMULOS{i}, {DOT});
            else
                [exit, ~] = EstimuloComun(secuencia{i}, TIEMPOS.ESTIMULOS{i}, []);
            end
            if exit
                return
            end
        end
        
        Screen('Flip', hd.window);
        if amarillo && isempty(respuesta_dot.valor) && i >= DOT.STIM(1) && i <= DOT.STIM(1)+1
            [exit, respuesta_dot] = Esperar(TIEMPOS.BLANCOS{i}, ExitKey, {DOT});
        else
            [exit, ~] = Esperar(TIEMPOS.BLANCOS{i}, ExitKey, []);
        end
        if exit
            return
        end
    end

end