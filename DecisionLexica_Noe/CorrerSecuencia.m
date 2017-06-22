function [log, exit] = CorrerSecuencia(bloque, hd, teclas, log, n_bloque)

    global TIEMPO_FIJACION
    global TIEMPO_VACIO_ALEATORIO
    global TIEMPO_ESTIMULO
    global TIEMPO_VACIO_FIN
    global MARCAS
    global TAMANIO_ESTIMULOS
    
    botones = {teclas.Negativo teclas.Afirmativo};
    
    for x = 1:length(bloque)
    
        
        log_actual.estimulo = bloque(x,:);
        estimulo_actual = bloque{x,1};
        codigo_actual = bloque{x,2};
        log_actual.botones = botones;
        
        
        %% FIJACION
        TextoCentrado('+', TAMANIO_ESTIMULOS, hd);
        [~, log_actual.fijacion_onset] = Screen('Flip', hd.window);
        Esperar(TIEMPO_FIJACION, teclas.ExitKey, [], teclas.Pausa);
        log_actual.fijacion_offset = GetSecs;
        
        %% vacio
        [~, log_actual.vacio_aleatorio_onset] = Screen('Flip', hd.window);
        [exit, ~] = Esperar(TiempoDeEspera(TIEMPO_VACIO_ALEATORIO), teclas.ExitKey, [], teclas.Pausa);        
        log_actual.vacio_aleatorio_offset = GetSecs;
        if exit
            return
        end
        
        %% ESTIMULO
        TextoCentrado(estimulo_actual, TAMANIO_ESTIMULOS, hd);
        [~, log_actual.estimulo_onset_tiempo] = Screen('Flip', hd.window);
        if ~isempty(log)
            marca = MARCAS(codigo_actual) + 100*(n_bloque-1) + 20;
            EnviarMarca(marca);
            log_actual.estimulo_onset_marca = marca;
        end

        [exit, respuesta, tiempo_respuesta] = Esperar(TIEMPO_ESTIMULO, teclas.ExitKey, botones, teclas.Pausa);
        if exit
            return
        end
        log_actual.estimulo_offset_tiempo = GetSecs;
        if ~isempty(log)
            marca = MARCAS(codigo_actual) + 100*(n_bloque-1) + 30;
            EnviarMarca(marca);
            log_actual.estimulo_offset_marca = marca;
        end
        WaitSecs(TIEMPO_ESTIMULO-(GetSecs-log_actual.estimulo_onset_tiempo));
        
        %% VACIO
        [~, log_actual.vacio_fin_onset] = Screen('Flip', hd.window);
        if isempty(respuesta)            
            [exit, respuesta, tiempo_respuesta] = Esperar(TIEMPO_VACIO_FIN, teclas.ExitKey, botones, teclas.Pausa);
            if exit
                return
            end
            Esperar(TIEMPO_VACIO_FIN-(GetSecs-log_actual.vacio_fin_onset), teclas.ExitKey,[],teclas.Pausa);
        else
            Esperar(TIEMPO_VACIO_FIN, teclas.ExitKey,[],teclas.Pausa);
        end
        log_actual.vacio_fin_offset = GetSecs;
        
        %% GUARDO DATOS DE RESPUESTA
        if ~isempty(respuesta)
            respuesta_correcta = codigo_actual(3);
            if respuesta_correcta == 'n'
                log_actual.respuesta_correcta = 1;
            else
                log_actual.respuesta_correcta = 2;
            end
            
            log_actual.accuracy = 0;
            if log_actual.respuesta_correcta == respuesta
                log_actual.accuracy = 1;
            end
            if ~isempty(log)
                marca = MARCAS(codigo_actual) + 100*(n_bloque-1) + (log_actual.accuracy + 4) * 10;
                EnviarMarca(marca);
                log_actual.respuesta_marca = marca;
            end
            
            log_actual.respuesta_subindice = respuesta;
            log_actual.respuesta_boton = botones{respuesta};
            log_actual.respuesta_tiempo = tiempo_respuesta;
            log_actual.reaction_time = log_actual.respuesta_tiempo  - log_actual.estimulo_onset_tiempo;
        end
        
        if ~isempty(log)
           log{x} = log_actual;
        end
        
        %% FEEDBACK SI ES PRACTICA
        if isempty(log) && ~isempty(respuesta)
            if log_actual.accuracy == 0
                TextoCentrado('¡INCORRECTO!', TAMANIO_ESTIMULOS, hd, hd.red);
                Screen('Flip', hd.window);
            else
                TextoCentrado('¡CORRECTO!', TAMANIO_ESTIMULOS, hd, hd.blue);
                Screen('Flip', hd.window);                
            end
            Esperar(0.5, teclas.ExitKey, [], teclas.Pausa);
        end
        

    end
    
    if ~isempty(log)
        marca = n_bloque + 10;
        EnviarMarca(marca);
    end

end